---
title: "API Design Under Failure"
summary: "Retry-safe API、idempotency key、pagination 與 recoverable errors"
description: "從 Week 4 learning notes 重新整理的 backend API 設計筆記"
date: 2026-04-28
tags: ["api-design", "idempotency", "grpc", "pagination", "retries"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 15: API design under failure, REST vs gRPC
- Day 16: retry-safe API design, idempotency storage, gRPC deadlines
- Day 17: stale-write prevention, pagination, recoverable error contracts
- Day 18-21: full request path, timeout ambiguity, duplicate create prevention

## 心智模型

好的 backend API 不是只在 happy path 乾淨。它要定義 client timeout、retry、duplicate request、stale update、以及在資料變動中 pagination 時會發生什麼。

面試標準是：

```text
correctness under retries + clear recovery contract + observable request path
```

## Retry-Safe Create

普通的 `POST /orders` 通常不是 idempotent。如果 client 在 DB commit 後 timeout，retry 同一個 request 可能產生 duplicate create。

比較安全的設計會用 idempotency key：

```text
Idempotency-Key: client-generated-unique-key
```

Server 需要存：

- idempotency key
- request payload hash
- operation status
- final response 或 created resource id

Replay 規則：

- same key + same payload + completed operation：回傳原本 response
- same key + same payload + in-progress operation：回傳 in-progress 或 retry-later response
- same key + different payload：回傳 conflict-style error

## 為什麼 Redis Lock 不夠

Lock 可以減少 concurrent execution，但它不是 durable source of truth。如果 process 在 DB commit 後、寫入 response record 或釋放 lock 前 crash，retry 仍然需要 durable idempotency record 判斷原本操作是否完成。

對 side-effect-heavy API，idempotency state 應該存在 durable storage，最好能和 business transaction 有一致性保證。

## Stale-Write Prevention

Update 題目常見問題不是 duplicate create，而是 lost update。可以用 version：

```text
If-Match: version-or-etag
```

Server 只在 submitted version 等於 current version 時更新。否則回傳 conflict 或 precondition failure，讓 client refetch。

## Pagination

Offset pagination 簡單，但在大量且持續變動的資料上不穩：

```text
GET /items?page=10&limit=20
```

Cursor pagination 比較安全：

```text
GET /items?cursor=opaque_token&limit=20
```

Cursor 要 encode stable ordering key，例如 `(created_at, id)`，這樣 inserts/deletes 才不容易造成 duplicate 或 skipped rows。

## REST vs gRPC

REST 通常適合 public APIs，因為簡單、容易 cache、各種 client 都好接。gRPC 適合 internal service-to-service，因為有 strict contracts、binary encoding、streaming、deadline propagation。

筆記裡的重要點：

```text
gRPC deadlines must propagate downstream.
```

否則上游服務 timeout 了，下游工作還繼續跑，會浪費資源。

## 要量測什麼

- request id and trace id
- idempotency key and replay outcome
- payload hash mismatch
- timeout count by endpoint
- retry count
- conflict / precondition failure rate
- p95 and p99 latency

## 面試回答形狀

我會先從 failure 設計 API。對有 side effects 的 create endpoint，我用 durable idempotency key，並存 payload hash 和 final result。client timeout 後 retry 同一個 key，server 回傳原本結果，而不是建立 duplicate。對 update，我用 version 或 ETag 防止 stale write。Pagination 則偏好有 stable ordering 的 cursor pagination。最後把 request ID、trace ID、structured errors 放進 contract，讓 client 和 operator 都能 recover。
