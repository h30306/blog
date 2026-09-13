---
title: "API Design Under Failure"
summary: "Retry-safe backend APIs, idempotency keys, pagination, and recoverable errors"
description: "API failure handling, status codes, idempotency, pagination, and recovery contracts"
date: 2026-04-28
tags: ["api-design", "idempotency", "grpc", "pagination", "retries"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- Resource-oriented endpoint design and method semantics
- `POST` retry safety with durable idempotency records
- `PUT` / `PATCH` behavior and stale-write prevention
- `201` / `202` / `204` / `409` / `412` / `422` / `429` status-code choice
- Cursor pagination, invalid-cursor recovery, request IDs, trace IDs
- REST vs gRPC trade-offs and deadline propagation

## Mental Model

A good backend API is not only clean when everything works. It must define what happens when the client times out, retries, sends duplicate requests, sends stale updates, or paginates through changing data.

The interview bar is:

```text
correctness under retries + clear recovery contract + observable request path
```

Saying only:

```text
REST is stateless and uses HTTP verbs
```

is not enough. A strong answer covers:

- resource modeling
- method semantics
- status-code correctness
- retry behavior
- durable idempotency
- stale-write prevention
- structured error bodies
- tracing and metrics

## Resource And Method Semantics

Paths should name resources. Methods should carry the operation semantics.

Better resource-oriented examples:

```text
GET /patients/123
POST /appointments
PATCH /appointments/456
POST /appointments/456/cancellations
```

Weaker RPC-style examples:

```text
POST /getPatient
POST /updateAppointmentStatus
POST /createAppointment
```

`POST` usually creates a new resource or action result controlled by the server. It is not idempotent by default, so payment, order, and appointment create APIs need an explicit idempotency design.

`PUT` usually replaces the full representation of a known resource. Repeating the same full request should converge to the same final state.

`PATCH` partially updates a resource. It may or may not be idempotent depending on patch semantics.

```text
PATCH { "status": "inactive" }          # usually idempotent
PATCH { "increment_balance_by": 100 }   # not idempotent
```

The production nuance: neither `PUT` nor `PATCH` automatically prevents stale writes. If a user can submit an update from an old screen, use versioning, ETags, or `If-Match`.

## Status Codes You Must Be Crisp On

| Code | When To Use | Example |
|---|---|---|
| `201 Created` | synchronous create succeeded and the resource exists now | `POST /appointments` created a resource |
| `202 Accepted` | request accepted but work is still pending | async job, or idempotent retry finds the same key still `processing` |
| `204 No Content` | success with intentionally empty body | delete, or some update flows |
| `400 Bad Request` | syntax or basic request format is invalid | broken JSON, malformed required field |
| `401 Unauthorized` | no valid authentication | missing or expired token |
| `403 Forbidden` | authenticated but not authorized | user cannot access another hospital |
| `409 Conflict` | request conflicts with current resource state or operation contract | same idempotency key with different payload, checked-in transition from cancelled state |
| `412 Precondition Failed` | explicit client precondition failed | `If-Match` / version mismatch for stale-write prevention |
| `422 Unprocessable Entity` | request is understandable but domain validation fails | `end_time < start_time`, invalid enum combination |
| `429 Too Many Requests` | rate limit exceeded | client or tenant exceeded allowed rate |

Be careful with `419`. It is not a standard HTTP status code. Some frameworks or products use it for session expired or CSRF token expired, but public API design should not rely on it as general HTTP semantics. If an internal system uses it, define it explicitly in the API contract. For external APIs, prefer a standard status code plus a machine-readable error code.

## Retry-Safe Create

Plain `POST /orders` is usually not idempotent. If the client times out after the database commit, retrying the same request can create a duplicate.

A safer design uses an idempotency key:

```text
Idempotency-Key: client-generated-unique-key
```

The server stores:

- idempotency key
- request fingerprint: method, path, normalized payload hash
- operation status: `processing`, `completed`, `failed`
- original response status code
- original response body or created resource id
- timestamps / expiry policy

Replay rules:

- same key + same payload + `completed`: replay the original response and original status code
- same key + same payload + `processing`: return `202 Accepted` with an operation id or status URL
- same key + different payload: return `409 Conflict`
- no record: atomically create the idempotency record before the side effect

The key idea:

```text
client timeout does not prove the side effect failed
```

A timeout only means the client did not receive the result. The server may not have started, may have rolled back, or may have committed while the response was lost. Retry-sensitive `POST` needs a durable replay contract.

## Why A Redis Lock Alone Is Not Enough

A lock may reduce concurrent execution, but it is not the durable source of truth. If the process crashes after committing the database row but before releasing or recording the response, the retry still needs a durable idempotency record.

For side-effect-heavy APIs, idempotency state should live in durable storage with the business transaction or in a table with transactional guarantees.

## Stale-Write Prevention

For updates, the failure is often not duplicate create but lost update. Use versioning:

```text
If-Match: version-or-etag
```

The server updates only if the submitted version matches the current version. Otherwise return:

```text
412 Precondition Failed
```

After `412`, the client should not blindly retry the same stale payload. A better recovery flow:

1. fetch the latest resource
2. reapply the intended change if still valid
3. ask the user to reconcile when needed
4. submit again with the new version / ETag

The error body should help the client recover:

```json
{
  "error": {
    "code": "STALE_VERSION",
    "message": "Resource was updated by another request",
    "current_version": 8,
    "request_id": "abc-123"
  }
}
```

Difference between `409` and `412`:

- `412`: the client supplied an explicit precondition and it failed
- `409`: the request conflicts with the current business/resource state, but not necessarily through an `If-Match` precondition

## Pagination

Offset pagination is easy but unstable on large changing datasets:

```text
GET /items?page=10&limit=20
```

Cursor pagination is safer:

```text
GET /items?cursor=opaque_token&limit=20
```

The cursor must encode a stable ordering key, such as:

```text
(created_at, id)
```

This avoids duplicates and skipped rows when inserts or deletes happen between page requests. `created_at DESC` alone is not enough because multiple rows can share the same timestamp; add an `id` tie-breaker to create a deterministic total order.

Response shape should include:

```json
{
  "items": [],
  "next_cursor": "opaque-token",
  "has_more": true,
  "request_id": "abc-123"
}
```

An invalid or expired cursor should not leave the client guessing. Use a fixed contract, commonly `400` or `422`, and include a recovery action:

```json
{
  "error": {
    "code": "INVALID_CURSOR",
    "message": "The pagination cursor is invalid or expired",
    "action": "restart_from_first_page",
    "request_id": "abc-123"
  }
}
```

## REST vs gRPC

REST is usually better for public APIs because it is simple, cache-friendly, and easy for broad clients to consume. gRPC is strong for internal service-to-service calls because it has strict contracts, efficient binary encoding, streaming support, and deadline propagation.

The important point from the notes:

```text
gRPC deadlines must propagate downstream.
```

Otherwise one service can time out while downstream work continues wastefully.

Avoid saying:

```text
gRPC is just faster than HTTP
```

Safer phrasing: gRPC is often a stronger internal service-to-service fit because contracts, deadlines, streaming, and code generation are consistent in a controlled environment. REST is often a better external API fit because it is broadly compatible, easy to debug, browser-friendly, and cache-friendly.

## Request Path And Failure Hooks

A full request-path answer can be:

```text
browser -> DNS -> TCP/TLS -> L7 gateway/load balancer -> FastAPI -> DAL -> Oracle -> response
```

Put the right responsibilities in the right place:

- gateway / edge: TLS termination, WAF, rate limiting, coarse authentication
- app: payload validation, authorization, idempotency check, business invariants
- DAL / DB: transaction, constraints, lock/version behavior
- response: status code, structured error, request id / trace id

Timeout pushback:

```text
timeout is an unknown outcome, not proof of failure
```

That is why write paths need idempotency keys, traceability, and replayable stored results.

## What To Log Or Measure

- request id and trace id
- idempotency key and replay outcome
- payload hash mismatch
- timeout count by endpoint
- retry count
- `409` conflict count
- `412` stale-version count
- `422` validation-error count
- invalid cursor count
- `429` rate-limit count
- p95 and p99 latency
- DB connection-pool wait time
- downstream timeout / deadline exceeded count

## Interview Answer Shape

I would design APIs around failure first. For side-effecting create endpoints, I use a durable idempotency key and store the method/path/payload fingerprint, operation status, original response status, and original response body. If the client times out and retries with the same key and payload, a completed operation replays the original result; a processing operation returns `202` with a status URL; same key with different payload returns `409`. For updates, I use versioning or ETags with `If-Match`; stale writes return `412` and the client must refetch and reconcile. `422` is for semantically invalid payloads, while `419` is not a standard HTTP status and should not be used as general public API semantics. For pagination, I prefer deterministic cursor pagination such as `(created_at, id)`, and invalid cursors should return a structured error with a recovery action. Finally, request IDs, trace IDs, and metrics make the contract operable.
