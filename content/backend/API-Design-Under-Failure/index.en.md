---
title: "API Design Under Failure"
summary: "Retry-safe backend APIs, idempotency keys, pagination, and recoverable errors"
description: "Backend API design notes rebuilt from Week 4 learning notes"
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

## Mental Model

A good backend API is not only clean when everything works. It must define what happens when the client times out, retries, sends duplicate requests, sends stale updates, or paginates through changing data.

The interview bar is:

```text
correctness under retries + clear recovery contract + observable request path
```

## Retry-Safe Create

Plain `POST /orders` is usually not idempotent. If the client times out after the database commit, retrying the same request can create a duplicate.

A safer design uses an idempotency key:

```text
Idempotency-Key: client-generated-unique-key
```

The server stores:

- idempotency key
- request payload hash
- operation status
- final response or created resource id

Replay rules:

- same key + same payload + completed operation: return the original response
- same key + same payload + in-progress operation: return in-progress or retry-later response
- same key + different payload: return a conflict-style error

## Why A Redis Lock Alone Is Not Enough

A lock may reduce concurrent execution, but it is not the durable source of truth. If the process crashes after committing the database row but before releasing or recording the response, the retry still needs a durable idempotency record.

For side-effect-heavy APIs, idempotency state should live in durable storage with the business transaction or in a table with transactional guarantees.

## Stale-Write Prevention

For updates, the failure is often not duplicate create but lost update. Use versioning:

```text
If-Match: version-or-etag
```

The server updates only if the submitted version matches the current version. Otherwise return a conflict or precondition failure and let the client refetch.

## Pagination

Offset pagination is easy but unstable on large changing datasets:

```text
GET /items?page=10&limit=20
```

Cursor pagination is safer:

```text
GET /items?cursor=opaque_token&limit=20
```

The cursor must encode a stable ordering key, such as `(created_at, id)`, so inserts and deletes do not cause duplicates or skipped rows.

## REST vs gRPC

REST is usually better for public APIs because it is simple, cache-friendly, and easy for broad clients to consume. gRPC is strong for internal service-to-service calls because it has strict contracts, efficient binary encoding, streaming support, and deadline propagation.

The important point from the notes:

```text
gRPC deadlines must propagate downstream.
```

Otherwise one service can time out while downstream work continues wastefully.

## What To Log Or Measure

- request id and trace id
- idempotency key and replay outcome
- payload hash mismatch
- timeout count by endpoint
- retry count
- conflict / precondition failure rate
- p95 and p99 latency

## Interview Answer Shape

I would design APIs around failure first. For create endpoints with side effects, I use an idempotency key stored durably with a payload hash and final result. If the client times out, a retry with the same key returns the original result instead of creating a duplicate. For updates, I use versions or ETags to prevent stale writes. For pagination, I prefer cursor pagination with stable ordering. I also make request IDs, trace IDs, and structured errors part of the contract so clients and operators can recover.
