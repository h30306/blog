---
title: "Transactions, Isolation, And MVCC"
summary: "把 ACID、isolation anomalies、MVCC、locking 和 retry 拆成可防守的 backend 答案"
description: "ACID、isolation levels、MVCC、deadlocks、Oracle Read Committed 的資料庫複習筆記"
date: 2026-05-19
tags: ["database", "transactions", "isolation", "mvcc", "locking", "oracle"]
categories: ["database"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

- ACID as backend correctness guarantees, not textbook slogans
- Isolation levels, dirty read, non-repeatable read, phantom read, lost update
- MVCC and what it does not solve by itself
- Optimistic versioning / ETag vs pessimistic row locking
- Deadlock, write skew, serializable abort, bounded retry
- Oracle `READ COMMITTED`, statement-level consistency, `ORA-08177`

## 心智模型

Transaction 題目不要只背：

```text
Atomicity, Consistency, Isolation, Durability
```

強回答要從 business invariant 開始：

```text
What state must never become invalid, even under retry, crash, and concurrent writes?
```

例如：

- appointment slot capacity 不能超賣
- billing row、payment ledger、appointment status 必須一致
- patient note 不能被 stale client 覆蓋
- duplicate payment retry 不能產生第二筆 side effect

## ACID 用 backend 方式講

Atomicity：一個交易裡的多個變更要一起成功或一起失敗。
例子：建立 billing record、payment ledger、更新 appointment payment status，不能只成功一半。

Consistency：資料庫 constraints 和 application invariants 不能被寫成壞狀態。
但注意，DB 不會自動知道所有 business invariant，所以 schema constraints、transaction logic、idempotency 還是要設計。

Isolation：concurrent transactions 不能互相看見或踩到不該看到的中間狀態。
重點是 isolation level 會決定哪些 anomaly 仍可能發生。

Durability：commit 成功後，即使 crash，資料也應該能恢復。

## Isolation Levels

面試裡要避免只講「越高越安全、越慢」。比較好的方式是：

| Level | 大致防什麼 | 還可能有什麼問題 |
|---|---|---|
| Read Uncommitted | 幾乎不防 dirty read | dirty read, non-repeatable read, phantom |
| Read Committed | dirty read | non-repeatable read, phantom, lost update risk |
| Repeatable Read | 同一 row 重複讀較穩 | engine-specific phantom / range behavior |
| Serializable | 等價於某個 serial order | contention, blocking, abort, retry cost |

Oracle 常見 default 是 `READ COMMITTED`，而且有 statement-level read consistency。要注意：這不代表整個 transaction 期間都看到同一份 snapshot，也不代表可以防住所有 booking / billing invariant。

## MVCC

MVCC 的安全說法：

```text
MVCC lets transactions read a consistent committed snapshot with better read/write concurrency.
```

但不要 overclaim：

```text
readers and writers never block each other
```

不同 engine 的細節不同，而且 MVCC 本身不等於：

- stale-write prevention
- duplicate-request prevention
- range invariant protection
- hot resource serialization

MVCC 讓讀取更平順，但如果兩個 client 都拿舊版本病歷表單提交更新，仍然可能 lost update，除非有 version / ETag / lock / constraint 之類的保護。

## Optimistic vs Pessimistic Locking

Optimistic locking 適合：

- conflict 少
- user think time 長
- 不想長時間持有 DB lock

典型做法：

```text
version column or ETag + If-Match
```

失敗時回：

```text
409 Conflict or 412 Precondition Failed
```

然後 client refetch、reconcile、再送。

Pessimistic locking 適合：

- hot scarce resource
- critical section 短
- 需要早點 serialize decision

例如 hot appointment slot：

```sql
SELECT *
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;
```

鎖住 owner row 後，在同一個 transaction 裡 re-check capacity，再 insert booking 或更新 used count。

## Range Invariant 和 Phantom

危險 pattern：

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'confirmed';

-- if count < capacity, insert booking
```

這個 invariant 活在一組符合 predicate 的 rows 上，不一定有共同的一列會被 concurrent transactions 一起鎖住。兩個交易都 count 到還有位子，然後一起 insert，就可能 overbook。

解法通常是：

- lock 一個 owner/capacity row
- unique constraint 適用於 capacity = 1 的情境
- Serializable / serializable-like protection
- bounded retry after serialization abort

## Deadlock 和 Retry

Deadlock 是 circular wait，不是單純「等很久」。

預防方式：

- consistent lock ordering
- transaction 盡量短
- 不要在 transaction 裡做慢外部呼叫
- lock granularity 要清楚

被 DB 偵測到 deadlock 或 serialization abort 後，常見策略是 bounded retry。但前提是 operation 本身 safe to retry，或有 idempotency key 防止 duplicate side effect。

Oracle `SERIALIZABLE` 可能遇到 `ORA-08177` 這類需要 retry 的 failure mode。這不是「資料庫壞了」，而是高隔離下用 abort 保護 serializable behavior 的成本之一。

## Idempotency 不是 Isolation

這是 note 裡很重要的修正。

- optimistic locking：防 stale write / lost update
- uniqueness constraint：保護 schema invariant，例如一個 encounter 只能有一筆 payment row
- idempotency key：保護 request semantic，尤其是 client timeout 後 retry
- isolation level：限制 concurrent transactions 的可見性和 interleaving

它們是不同層，不要混在一起。

## 我要量測什麼

- lock wait time
- deadlock count
- serialization abort count
- retry count and retry success rate
- conflict / precondition failure rate
- transaction duration
- hot row / hot slot contention
- duplicate idempotency replay outcome

## 60-90 秒回答

我會先定義 business invariant，而不是先背 isolation 名詞。`READ COMMITTED` 可以防 dirty read，但仍可能有 non-repeatable read、phantom、lost update 風險，所以 booking 或 billing correctness 通常還需要 row lock、version check、constraint、idempotency 或更高隔離。MVCC 讓讀取看到 committed snapshot，提升 read/write concurrency，但它不是 stale-write prevention。對長時間編輯的 patient note，我用 optimistic version / ETag；對 hot appointment slot，我會 lock capacity owner row 並在交易內 re-check。Deadlock 或 serialization abort 要 bounded retry，但只有在操作本身 retry-safe 或有 idempotency 保護時才安全。
