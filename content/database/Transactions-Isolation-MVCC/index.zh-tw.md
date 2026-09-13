---
title: "Transactions, Isolation, And MVCC"
summary: "把 ACID、isolation anomalies、MVCC、locking 和 retry 拆成可防守的 backend 答案"
description: "ACID、isolation levels、MVCC、deadlocks、write skew、Oracle Read Committed 的資料庫複習筆記"
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

這篇不是要背 `ACID = Atomicity, Consistency, Isolation, Durability`。

Tier A/S 強度的 transaction 題目，真正要答的是：

- business invariant 是什麼
- 併發交易會怎麼把 invariant 寫壞
- 目前 isolation level 還允許什麼 anomaly
- 該用 optimistic versioning、row lock、constraint、owner-row lock，還是 `SERIALIZABLE`
- DB abort、deadlock、timeout、client retry 發生時，應用層要怎麼安全處理
- production 裡要量什麼，才知道 contention 或 retry storm 正在變糟

一句話主軸：

```text
Transaction correctness is not about knowing the names.
It is about protecting a business invariant under concurrency, retry, crash, and partial failure.
```

## Tier A/S 判斷

如果答案只有：

```text
Read Uncommitted 最弱，Serializable 最強。
MVCC 讓 read 不 block write。
Deadlock 就 retry。
```

這還不夠。

強回答要能補上：

- `READ COMMITTED` 防 dirty read，但仍可能有 non-repeatable read、phantom、read-check-write race
- MVCC 改善 snapshot visibility，不等於自動防 stale write 或 predicate invariant
- optimistic locking 是防 stale write，不是防所有併發 bug
- idempotency key 是防 duplicate logical request，不是 isolation level
- `SERIALIZABLE` 可能用 blocking 或 abort 保 correctness，所以 application 要有 bounded retry
- retry 必須重跑整個 transaction，且不能已經放出不可逆外部 side effect

## 先從 Invariant 開始

面試裡不要先背名詞，要先問：

```text
What state must never become invalid if two requests run at the same time?
```

常見 invariant：

- appointment slot 不可以超賣
- patient note 不可以被 stale client 靜默覆蓋
- billing finalized 後，同一個 billing cycle 不能還有未入帳 charge line
- payment retry 不可以造成第二次實際扣款
- 一個外部 reference 或 idempotency key 只能對應一個 logical result

這個順序很重要，因為不同 invariant 對應不同工具：

| Invariant 形狀 | 常見 bug | 第一個會想到的保護 |
|---|---|---|
| 單一 row 的更新 | stale write / lost update | version column, `ETag`, `If-Match` |
| 熱門稀缺資源 | double booking / oversell | short transaction + `SELECT ... FOR UPDATE` |
| predicate / range 上的集合規則 | phantom / write skew | owner-row lock, redesign, `SERIALIZABLE` |
| exact uniqueness | duplicate row | unique constraint |
| 同一個 request 被重送 | duplicate side effect | idempotency key |

## ACID 用 Backend 語言講

### Atomicity

Atomicity 是 transaction boundary 裡的 DB changes 要一起 commit 或一起 rollback。

例子：

- 建立 invoice row
- 把 charge lines 標成 billed
- 更新 encounter billing status

如果只有 invoice row 成功，但 charge lines 沒有更新，系統就進入半完成狀態。Atomicity 的價值是讓這組 DB mutation 不是拆散成功。

但要注意：

```text
HTTP request boundary is not automatically the same as transaction boundary.
```

如果 request 裡還有呼叫 payment provider、寄 email、送 message queue，DB transaction 不會自動 rollback 那些外部 side effects。

### Consistency

Consistency 不是「資料會自己正確」。

比較好的說法是：

```text
The transaction preserves declared database constraints and the business invariants that the system actually encodes.
```

資料庫可以幫你保：

- primary key
- foreign key
- unique constraint
- check constraint
- not-null constraint

但資料庫不會自動知道：

- billing finalized 後還能不能新增 charge line
- 一次 appointment reschedule 要不要保留 audit trail
- stale patient note 要不要 merge 或拒絕

這些要靠 schema、transaction logic、locking contract、idempotency 和 background reconciliation 一起補。

### Isolation

Isolation 控制 concurrent transactions 可以互相看見什麼、干擾什麼。

強回答不要說：

```text
transactions are isolated from each other
```

要說：

```text
The isolation level decides which interleavings are allowed and which anomalies the database prevents.
```

### Durability

Durability 是 commit 回成功之後，即使 process crash 或 machine failure，資料庫仍應該能靠 log / recovery 保存結果。

面試時可以補一句：

```text
Durability protects committed database state, not necessarily an external provider call unless the system has an outbox, reconciliation, or idempotent integration design.
```

## Isolation Levels

不要只講「越高越安全、越慢」。應該講每個 level 防什麼、還留下什麼風險。

| Isolation level | Dirty read | Non-repeatable read | Phantom read | 面試安全說法 |
|---|---:|---:|---:|---|
| Read Uncommitted | 可能 | 可能 | 可能 | 幾乎不適合 correctness-sensitive OLTP flow |
| Read Committed | 防住 | 可能 | 可能 | 每次 statement 看 committed data，但同一 transaction 的後續 read 可能看到新 commit |
| Repeatable Read | 防住 | 通常防住 | engine-specific | row reread 更穩，但不要在沒有 engine context 時亂保證 range behavior |
| Serializable | 防住 | 防住 | 防住 | 結果等價於某個 serial order，但可能增加 blocking、abort、retry cost |

`READ COMMITTED` 常見誤區：

```text
It prevents dirty reads, but it does not mean a multi-step business decision is safe.
```

例如 booking：

1. transaction A 查 slot 還有 1 個位子
2. transaction B 也查 slot 還有 1 個位子
3. A insert booking
4. B insert booking
5. 最後 capacity 被超過

每個 statement 都可能只看到 committed data，但整個 read-check-write decision 仍然壞掉。

## Oracle Wording

Oracle 題目要講得準一點：

- 常見 default transaction isolation 是 `READ COMMITTED`
- 每個 query 看到的是該 query 開始時已 commit 的一致 snapshot
- 這叫 statement-level read consistency
- 這不代表整個 transaction 從頭到尾都看到同一份 snapshot
- `SERIALIZABLE` 更接近 transaction-level snapshot consistency
- Oracle 在無法維持 serializable outcome 時，可能讓 transaction 失敗，例如 `ORA-08177`

面試安全句：

```text
In Oracle READ COMMITTED, each statement sees a consistent committed snapshot as of the statement start.
That is useful, but it is not the same as full transaction-level serializability.
```

## 四個 Anomaly

### Dirty Read

Dirty read 是讀到別人尚未 commit、之後可能 rollback 的資料。

情境：

1. transaction A 暫時把 refund balance 改成新值
2. transaction B 讀到這個 uncommitted value，並做 downstream decision
3. transaction A rollback

問題：

```text
B used a state that never truly existed.
```

`READ COMMITTED` 一般會防住 dirty read。

### Non-Repeatable Read

Non-repeatable read 是同一個 transaction 讀同一列兩次，中間別人 commit 更新，所以第二次看到不同值。

情境：

1. transaction A 讀 patient billing row，看到 status = `PENDING`
2. transaction B commit，把 status 改成 `ADJUSTED`
3. transaction A 再讀同一 row，看到 status 變了

問題：

```text
The transaction cannot assume a stable view of a row it already read.
```

`READ COMMITTED` 仍可能允許這種情況。

### Phantom Read

Phantom read 是同一個 predicate / range query 重跑後，結果集合 membership 改變。

情境：

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'CONFIRMED';
```

1. transaction A 第一次查，看到 count = 0
2. transaction B insert 一筆符合條件的 confirmed appointment 並 commit
3. transaction A 重跑同一個 predicate，看到 count = 1

重點不是「多一列」這麼簡單，而是：

```text
The business invariant lives on a predicate-defined set, not one row.
```

### Lost Update / Stale Write

Lost update 是兩個人都讀到舊版本，後寫的人覆蓋先寫的人，而且系統沒有偵測衝突。

情境：

1. doctor A 讀 patient note version `12`
2. doctor B 也讀 version `12`
3. A 存檔，row 變 version `13`
4. B 用舊版內容送出更新
5. 如果沒有 version check，B 的內容可能靜默蓋掉 A

這通常要用：

- version column
- `ETag`
- `If-Match`
- optimistic lock exception
- 或短交易內 explicit lock

不要只說「提高 isolation level 就好」，因為長時間使用者編輯不適合一直持有 DB lock。

## MVCC

MVCC 的面試安全定義：

```text
MVCC lets transactions read a consistent committed snapshot with better read/write concurrency.
```

可以這樣理解：

- database 保留 row 的多個 committed versions 或 undo information
- reader 依照自己的 snapshot 決定看哪個版本
- 很多 read 不需要跟 writer 搶同一把 blocking lock
- 所以 read-heavy workload 通常會更平順

但不能 overclaim：

```text
MVCC improves visibility and concurrency.
It does not automatically prove the business invariant is safe.
```

MVCC 本身不等於：

- stale-write prevention
- duplicate request prevention
- range invariant protection
- hot resource serialization
- external side-effect safety

## Statement Snapshot Vs Transaction Snapshot

這是很容易被追問的點。

在某些 `READ COMMITTED` 實作裡，每個 statement 會看到 statement 開始時的一致 committed snapshot。

所以：

```text
SELECT #1 can see snapshot S1.
SELECT #2 in the same transaction can see snapshot S2.
```

這代表：

- 單一 query 的結果可以一致
- 但整個 transaction 不一定看到穩定世界
- multi-step read-check-write 還是可能受 concurrent commit 影響

在 transaction-level snapshot 或 stronger isolation 裡，transaction 期間可見資料更穩，但仍要注意 writer conflict、write skew、abort 和 retry。

## Optimistic Concurrency

Optimistic concurrency 適合：

- conflict 預期少
- user think time 長
- 不想持有 DB lock 等使用者按儲存
- stale overwrite 是主要風險

典型設計：

```http
GET /patient-notes/123
ETag: "v12"

PATCH /patient-notes/123
If-Match: "v12"
```

DB 更新：

```sql
UPDATE patient_notes
SET body = :body,
    version = version + 1
WHERE id = :id
  AND version = :expected_version;
```

如果 affected rows = 0：

- 回 `409 Conflict` 或 `412 Precondition Failed`
- 回傳最新 version 或重新取得最新內容的方式
- 讓 client / user 做 reconcile

不要盲目 auto-retry stale write，因為 retry 可能只是把舊內容再次蓋上去。

## Pessimistic Locking

Pessimistic locking 適合：

- hot scarce resource
- critical section 短
- conflict 預期高
- 早點 serialize decision 比晚點大量 retry 更便宜

例如 appointment capacity：

```sql
BEGIN;

SELECT capacity, used_count
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;

-- re-check used_count < capacity inside the same transaction
-- then insert appointment and increment used_count

COMMIT;
```

關鍵：

- lock 共同 owner row
- 在同一個 transaction 裡重查 invariant
- update owner row 或 insert booking
- transaction 要短
- 不要在 lock 持有期間做外部 API call

## Constraint 不是可有可無

Application check 很容易 race。

如果 invariant 可以被 schema 表達，DB constraint 通常應該是最後防線。

例子：

```sql
CREATE UNIQUE INDEX uniq_doctor_slot
ON appointments (doctor_id, slot_start)
WHERE status = 'CONFIRMED';
```

這適合 capacity = 1 的情境。

如果 capacity > 1，只靠 unique constraint 可能不夠，就要考慮：

- owner capacity row
- counter update
- checked constraint plus transaction logic
- `SERIALIZABLE`
- 或重新建模成有限 slot units

## Range Invariant 和 Phantom

最危險的 pattern：

```sql
SELECT count(*)
FROM appointments
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
  AND status = 'CONFIRMED';

-- if count < capacity, insert booking
```

這會出問題，因為：

- invariant 活在符合 predicate 的一組 rows 上
- 不一定存在一列共同 row 讓所有 transaction 必須一起鎖
- 兩個 transaction 可以各自看到合法 snapshot
- 兩個 transaction 都 insert 後，合起來變成非法狀態

更好的設計：

```text
Serialize all writers through an owner record.
```

例如：

```sql
SELECT *
FROM slot_capacity
WHERE doctor_id = :doctor_id
  AND slot_start = :slot_start
FOR UPDATE;
```

然後所有會影響該 slot capacity 的 writer 都必須遵守同一個 contract。

## Write Skew

Write skew 是一個經典 set-level invariant bug。

Invariant：

```text
At least one doctor must remain on call for the ICU night shift.
```

Schedule：

1. transaction A 看到 doctor A 和 doctor B 都 on call
2. transaction B 也看到 doctor A 和 doctor B 都 on call
3. transaction A 把 doctor A 改成 off call
4. transaction B 把 doctor B 改成 off call
5. 兩個 transaction 都 commit

每個 transaction 都更新不同 row，所以不一定有直接 writer/writer conflict。

但 final state 壞掉：

```text
Zero doctors remain on call.
```

面試裡要點出：

- 這不是 dirty read
- 這不是單列 stale write
- 這是 set-level invariant 沒被保護
- snapshot-style reads 可能讓每個 transaction 都覺得自己看到合法狀態

常見修法：

- lock 一個 shift owner row
- 把 remaining_on_call count 放在 owner row 並 transactionally update
- 用 `SERIALIZABLE` 並處理 abort / retry
- 用 constraint / trigger，但要非常清楚可維護性和 race behavior

## Billing Phantom 深入例子

Invariant：

```text
When an encounter is finalized for a billing cycle,
there must be no unbilled charge lines left for that encounter and cycle.
```

可能的 `READ COMMITTED` schedule：

1. transaction A 查：

```sql
SELECT *
FROM charge_lines
WHERE encounter_id = :encounter_id
  AND billing_cycle_id = :cycle_id
  AND invoice_id IS NULL;
```

2. A 根據目前查到的 charge lines 建立 invoice
3. transaction B insert 一筆新的 matching charge line 並 commit
4. A commit invoice finalization

壞結果：

- encounter / cycle 被標成 invoiced
- 但還有一筆 `invoice_id IS NULL` 的 charge line

為什麼不是 stale write：

- 沒有兩個人覆蓋同一 row
- concurrent danger 是一筆新 row 加入 predicate set
- version column on invoice row 不一定會看到這件事

`SERIALIZABLE` 的說法：

```text
The database must reject, block, or otherwise prevent a combined committed outcome
that cannot be explained by any serial order.
```

不同 engine 做法不同，有些會 block，有些會在 commit 時 abort 某個 transaction。

Owner-row redesign：

```sql
SELECT *
FROM encounter_billing_cycle
WHERE encounter_id = :encounter_id
  AND billing_cycle_id = :cycle_id
FOR UPDATE;
```

接著在同一個 transaction 裡：

- re-check unbilled charge lines
- create invoice
- mark charge lines billed
- update owner row status

前提：

```text
All writers that can create or modify charge lines for this invariant must also respect the owner-row lock contract.
```

## Deadlock

Deadlock 是 circular wait，不是單純 lock wait 很久。

例子：

1. transaction A 先 lock appointment row，再 lock billing row
2. transaction B 先 lock billing row，再 lock appointment row
3. A 等 B 的 billing lock
4. B 等 A 的 appointment lock

結果：

```text
Neither transaction can make progress.
```

DB 通常會選一個 victim abort，讓另一個繼續。

預防：

- 所有 code path 使用一致 lock order
- transaction 盡量短
- lock scope 盡量窄
- locking predicate 要有合適 index
- transaction 裡不要做慢外部呼叫
- 避免使用者 think time 期間持有 DB lock

## Retry Decision

不要把所有錯誤都 retry。

| Failure mode | 發生什麼事 | 常見處理 | Auto retry? |
|---|---|---|---|
| Lock wait | 被別的 transaction 擋住，但還不是 cycle | 等待、timeout、回報 latency | 不一定 |
| Deadlock victim | DB abort 一方打破 cycle | rollback 後重跑整個 transaction | 可以，但要 bounded 且 retry-safe |
| Serialization abort | DB 拒絕 non-serializable schedule | rollback 後重跑整個 transaction | 可以，但要 bounded 且 retry-safe |
| Optimistic conflict | stale version 要覆蓋新 state | 回 `409` / `412` 並 reconcile | 通常不要 blind retry |
| Unique violation | schema invariant 被撞到 | 回 duplicate / conflict semantic | 通常不要 blind retry |
| Duplicate request | 同一 logical request 重送 | idempotency replay 原結果 | 不等於重新執行 |

安全 retry 規則：

```text
Retry the full transaction only for transient concurrency failures,
only with a bounded budget,
and only if the workflow is idempotent and no irreversible external side effect has escaped.
```

如果 transaction 裡已經呼叫 payment provider、寄出 email、送出不可逆外部請求，就不能假裝 rollback DB 就等於 rollback world。

這時候需要：

- idempotency key
- outbox pattern
- reconciliation job
- external reference uniqueness
- clear "unknown result" recovery path

## Idempotency 不是 Isolation

這是很常被混在一起的點。

| 機制 | 保護什麼 | 不保護什麼 |
|---|---|---|
| Isolation level | transaction visibility / interleaving | duplicate logical request |
| Optimistic versioning | stale write / lost update | predicate insert / phantom |
| Row lock | known row 或 owner row decision | 沒走同一 contract 的 writer |
| Unique constraint | schema-expressible uniqueness | timeout 後 response replay 語義 |
| Idempotency key | request retry semantic | arbitrary concurrent invariant |

強回答：

```text
I use isolation or locking to control concurrent state transitions,
and idempotency to make the same logical request safe to repeat.
They solve different failure modes.
```

## What Breaks At Scale

- hot appointment slots 讓 lock wait 直接打到 `p95` / `p99`
- hot owner rows 會把 correctness bottleneck 集中在少數 rows
- serializable abort 在高 contention 下可能形成 retry storm
- optimistic conflict 在熱門資源上會讓大量 request 做完工作才失敗
- missing index 讓 locking query 掃更多 rows，擴大 contention
- long transaction 讓 snapshot、undo、lock wait、deadlock 機率一起變糟
- client retry 疊 server retry 會放大流量
- external side effect 沒有 idempotency 會讓 DB retry 變成重複扣款或重複通知

## What To Log Or Measure

至少要能講出：

- transaction latency by endpoint
- lock wait duration
- deadlock count
- serialization abort count，例如 Oracle `ORA-08177`
- retry count、retry success rate、retry exhaustion count
- optimistic conflict count，例如 `409` / `412`
- unique violation count by constraint name
- idempotency-key hit / replay / payload mismatch count
- rows scanned vs rows returned for predicate checks
- hot row / hot slot / hot tenant distribution
- business invariant violation alert

如果是 billing finalization：

- finalized encounter with remaining unbilled charge lines
- duplicate external charge reference
- invoice finalization retry exhaustion
- slow predicate scan on `charge_lines`

## Interview Pushback

1. Why is `READ COMMITTED` often not enough for appointment capacity?
2. Why does MVCC not automatically prevent stale writes?
3. When would you use optimistic versioning instead of `SELECT ... FOR UPDATE`?
4. When is `SERIALIZABLE` better than owner-row locking?
5. When is owner-row locking better than blanket `SERIALIZABLE`?
6. Why is a phantom-read bug really a predicate-invariant bug?
7. Why should deadlock retry replay the full transaction instead of only the failed SQL?
8. What happens if a payment call succeeds but the DB transaction later aborts?
9. Why can a missing index make locking behavior worse?
10. What exact Oracle wording would you use for `READ COMMITTED`?

## 60-90 秒回答

我會先從 business invariant 開始，而不是先背 isolation 名詞。`READ COMMITTED` 通常可以防 dirty read，但它仍可能讓同一 transaction 的 repeated read 改變，也可能讓 range query 看到 phantom，所以 booking、billing finalization 這種 read-check-write 流程不能只靠它。MVCC 讓 transaction 讀到一致的 committed snapshot，提升 read/write concurrency，但它不等於 stale-write prevention，也不保證 predicate invariant 安全。長時間 patient note 編輯，我會用 version column 或 `ETag` / `If-Match` 做 optimistic concurrency，衝突時回 `409` 或 `412` 讓 client reconcile。熱門 appointment slot 或 capacity row，我會用短 transaction 加 `SELECT ... FOR UPDATE`，lock owner row 後 re-check invariant。遇到 deadlock 或 serialization abort，可以 bounded retry 整個 transaction，但前提是 operation idempotent，且沒有不可逆外部 side effect 已經放出去。

## 10-15 分鐘 Deep Dive 路線

如果面試官要你展開，可以照這個順序：

1. 先畫一個 flow：

```text
client -> API -> service transaction -> DB rows -> optional external side effect
```

2. 標出 invariant：

```text
slot used_count <= capacity
or
invoice finalized implies no unbilled charge line remains
```

3. 給一個 `READ COMMITTED` 下會壞的 schedule。

4. 解釋 anomaly 名稱只是症狀：

```text
The real bug is the invalid final state.
```

5. 比較三種修法：

| Fix | 適合 | 成本 |
|---|---|---|
| Optimistic versioning | 單列 stale write | conflict 發生晚，不適合 hot scarce resource |
| Owner-row `FOR UPDATE` | 明確 owner / capacity / cycle | owner row 可能變 hotspot，所有 writer 必須遵守 contract |
| `SERIALIZABLE` | predicate invariant 難以建模 | abort / retry / tail latency 成本高 |

6. 補上 retry boundary：

```text
DB-only transient abort can retry the full transaction.
External side effects need idempotency, outbox, or reconciliation.
```

7. 最後講 production metrics：

```text
lock wait, deadlock, serialization abort, retry exhaustion, p95/p99, invariant alert.
```

## 常見錯誤

- 把 ACID 只背成四個英文單字
- 說 `READ COMMITTED` 就可以處理 booking correctness
- 說 MVCC 代表 read/write 永遠互不 block
- 把 lost update、phantom、write skew 混成同一種 bug
- 用 version column 嘗試解 open-ended predicate insert
- 在 user think time 持有 DB lock
- deadlock 後只 retry 最後一個 SQL statement
- unique constraint violation 也盲目 retry
- 忘記 external side effect 不是 DB rollback 的一部分
- 說 `SERIALIZABLE` 就是「所有 transaction 排隊」

## 最後要能交付

讀完這篇，要能做到：

- 用 60-90 秒講 ACID，但每個 property 都連到 backend failure mode
- 說出 dirty read、non-repeatable read、phantom read、lost update 的具體 scenario
- 解釋 `READ COMMITTED` 為什麼常常不夠
- 用正確詞彙描述 Oracle `READ COMMITTED` 和 statement-level consistency
- 說清楚 MVCC 幫了什麼、沒幫什麼
- 為 patient note 選 optimistic versioning，為 hot slot 選短 transaction row lock
- 為 predicate invariant 比較 owner-row lock、schema redesign 和 `SERIALIZABLE`
- 說出 deadlock、serialization abort、optimistic conflict、unique violation 的不同處理方式
- 說出 retry 何時安全、何時不該 blind retry
- 列出 contention 和 invariant 相關的 production metrics
