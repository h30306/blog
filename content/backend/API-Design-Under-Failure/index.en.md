---
title: "API Design Under Failure"
summary: "Retry-safe backend APIs, idempotency keys, pagination, and recoverable errors"
description: "Production API failure handling, status codes, idempotency, pagination, concurrency, and recovery contracts"
date: 2026-04-28
tags: ["api-design", "idempotency", "grpc", "pagination", "retries", "observability"]
categories: ["backend"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- Failure-first API design for timeout, retry, duplicate requests, partial success, and stale state
- Idempotency-key contract for side-effecting `POST`
- Transaction ordering between idempotency records, business rows, and external side effects
- `201` / `202` / `204` / `409` / `412` / `422` / `429` status-code boundaries
- Cursor pagination on changing datasets
- REST vs gRPC trade-offs, deadline propagation, and request tracing
- Metrics and logs that let both client and operator recover

## Tier A/S Readiness

The basic version of this topic is not enough for Tier A/S. A list of HTTP verbs and status codes sounds like documentation recall.

A stronger interview answer starts with this claim:

```text
An API contract is incomplete until it defines what clients should do after timeout, retry, duplicate submission, stale writes, partial downstream failure, and pagination over changing data.
```

For Tier A/S, the answer should show that you can design the write path, not only name the status code. The interviewer should hear:

- what state is stored durably
- what is safe to retry
- what must not be retried blindly
- how race conditions are prevented
- how a client recovers without guessing
- how the system is debugged after production incidents

## Scenario To Anchor The Answer

Use a concrete example. For a hospital backend:

```text
POST /appointments
PATCH /appointments/{appointment_id}
POST /appointments/{appointment_id}/cancellations
GET /patients/{patient_id}/appointments?cursor=...
```

The hard case is not the happy path. The hard case is:

```text
The client sends POST /appointments.
The API commits the appointment.
The response is lost because of a timeout.
The client retries.
```

Without a replay contract, retry can create a duplicate appointment, double-charge a payment, or send duplicate notifications.

## Resource And Method Semantics

Paths should name resources. HTTP methods should carry operation semantics.

Better resource-oriented endpoints:

```text
GET    /patients/123
POST   /appointments
PATCH  /appointments/456
POST   /appointments/456/cancellations
```

Weaker RPC-style endpoints:

```text
POST /getPatient
POST /updateAppointmentStatus
POST /createAppointment
```

The important nuance:

- `GET` should be safe and should not mutate business state.
- `POST` is not idempotent by default, so side-effecting create APIs need an explicit idempotency design.
- `PUT` normally replaces a known resource representation. Repeating the same request should converge to the same final state.
- `PATCH` depends on semantics. `PATCH { "status": "inactive" }` is usually idempotent, while `PATCH { "increment_balance_by": 100 }` is not.
- `PUT` and `PATCH` do not automatically prevent stale writes. Use versions, ETags, or `If-Match`.

## Retry-Safe Create Contract

A retry-safe create endpoint usually accepts:

```text
Idempotency-Key: client-generated-unique-key
```

The server stores a durable idempotency record:

```text
idempotency_key
tenant_id / user_id
method
path
normalized_payload_hash
status: processing | completed | failed
resource_id
response_status
response_body
expires_at
created_at
updated_at
```

Replay rules:

| Condition | Response |
|---|---|
| same key, same payload, `completed` | replay the original response and original status |
| same key, same payload, `processing` | return `202 Accepted` with operation id or status URL |
| same key, different payload | return `409 Conflict` |
| no key for retry-sensitive write | reject with `400` or require a generated key |
| no existing record | atomically create the idempotency record, then perform the write |

The key sentence to say in interview:

```text
Client timeout is an unknown outcome, not proof that the server failed.
```

The server may not have started the operation, may have rolled it back, or may have committed while the response was lost.

## Transaction Ordering

This is where the answer becomes interview-strong.

For a payment, order, or appointment create, the idempotency record must be part of the correctness boundary. A common shape is:

```text
BEGIN
  INSERT idempotency record if absent
  lock/read idempotency record
  validate payload fingerprint
  create appointment row
  update idempotency record to completed with response payload
COMMIT
```

The idempotency key should have a unique constraint scoped by tenant/user:

```sql
UNIQUE (tenant_id, idempotency_key)
```

Do not use only an in-memory cache or Redis lock as the source of truth. A lock can reduce concurrent execution, but it does not give durable replay if the process crashes after the business commit.

If the API also sends email, publishes an event, or calls a payment provider, avoid doing the external side effect directly in the DB transaction. Prefer an outbox/event table:

```text
transaction commits appointment + outbox event
background worker publishes event
consumer side is also idempotent
```

That gives a recoverable path when the database commit succeeds but the downstream notification fails.

## Failure Matrix

| Failure | Bad Outcome Without Design | Strong Contract |
|---|---|---|
| client timeout after commit | duplicate create on retry | idempotency replay |
| two concurrent retries | two rows or lock race | unique key + transactional idempotency record |
| same key, different payload | accidental overwrite | `409 IDEMPOTENCY_KEY_REUSED` |
| process crash after DB commit | client cannot recover | completed idempotency record or recoverable reconciliation |
| downstream email/payment failure | partial success hidden from client | outbox + operation status |
| stale update from old UI | lost update | `If-Match` version check + `412` |
| invalid cursor | client loops or misses data | structured error with restart action |

## Status Codes You Must Be Crisp On

| Code | When To Use | Example |
|---|---|---|
| `201 Created` | synchronous create succeeded and the resource exists now | `POST /appointments` created an appointment |
| `202 Accepted` | request accepted but work is still pending | async operation or idempotent retry still `processing` |
| `204 No Content` | success with intentionally empty body | delete or update with no response body |
| `400 Bad Request` | syntax or basic request format is invalid | malformed JSON |
| `401 Unauthorized` | no valid authentication | missing or expired token |
| `403 Forbidden` | authenticated but not authorized | user cannot access another hospital tenant |
| `409 Conflict` | conflicts with current state or operation contract | same idempotency key with different payload |
| `412 Precondition Failed` | explicit client precondition failed | `If-Match` version mismatch |
| `422 Unprocessable Entity` | syntactically valid but domain-invalid | `end_time < start_time` |
| `429 Too Many Requests` | client or tenant exceeded rate limit | retry after quota reset |

Be careful with `419`. It is not a standard HTTP status code. Some frameworks use it for session expired or CSRF token expired, but public API design should prefer standard status codes plus a machine-readable error code.

## Error Body Contract

Clients should not parse human text. Give them stable machine-readable fields:

```json
{
  "error": {
    "code": "STALE_VERSION",
    "message": "Resource was updated by another request",
    "retryable": false,
    "recovery": "fetch_latest_and_reapply",
    "current_version": 8,
    "request_id": "req_abc",
    "trace_id": "trace_xyz"
  }
}
```

Useful fields:

- `code`: stable application error code
- `message`: human-readable, not used for branching
- `retryable`: whether automatic retry is safe
- `recovery`: what the client should do next
- `request_id` / `trace_id`: support ticket and distributed tracing hook
- optional domain fields, such as `current_version` or `retry_after_seconds`

## Stale-Write Prevention

Update paths usually fail through lost update, not duplicate create.

Use versioning:

```text
GET /appointments/456
ETag: "v7"

PATCH /appointments/456
If-Match: "v7"
```

The server updates only if the submitted version matches the current version. If someone else updated the appointment first, return:

```text
412 Precondition Failed
```

The client should not blindly retry the stale payload. The recovery flow is:

1. fetch the latest resource
2. reapply the intended change if still valid
3. ask the user to reconcile if the conflict is semantic
4. submit again with the new version

The `409` vs `412` distinction:

- `412`: the client supplied an explicit precondition and it failed
- `409`: the request conflicts with the current business/resource state, not necessarily through `If-Match`

## Pagination Under Change

Offset pagination is easy:

```text
GET /items?page=10&limit=20
```

But it is unstable on large, changing datasets. Inserts or deletes between page requests can create duplicates or skipped items.

Cursor pagination is usually stronger:

```text
GET /appointments?cursor=opaque_token&limit=20
```

The cursor should encode a deterministic ordering boundary:

```text
(created_at, id)
```

`created_at DESC` alone is not enough because multiple rows can share the same timestamp. Add a tie-breaker such as `id` to create a total order.

Response shape:

```json
{
  "items": [],
  "next_cursor": "opaque-token",
  "has_more": true,
  "request_id": "req_abc"
}
```

Invalid or expired cursor response:

```json
{
  "error": {
    "code": "INVALID_CURSOR",
    "message": "The pagination cursor is invalid or expired",
    "retryable": false,
    "recovery": "restart_from_first_page",
    "request_id": "req_abc"
  }
}
```

## Rate Limits And Abuse Boundaries

Failure design also includes protecting the service.

Rate limits should be scoped by the real blast radius:

- per user for normal product usage
- per tenant for noisy customers
- per IP for anonymous abuse
- per API key for external integrations
- per endpoint for expensive writes or exports

Return `429` with a clear retry contract:

```text
Retry-After: 30
```

Do not let retry logic become a self-DDoS. Clients should use exponential backoff with jitter, respect server deadlines, and avoid retrying non-idempotent writes without an idempotency key.

## REST vs gRPC

REST is often better for public APIs:

- simple mental model
- browser and third-party compatibility
- easier debugging with common HTTP tooling
- cache-friendly semantics

gRPC is often better for internal service-to-service APIs:

- strict protobuf contracts
- code generation
- streaming
- efficient binary encoding
- first-class deadlines and cancellation

The critical production point:

```text
gRPC deadlines must propagate downstream.
```

If the caller times out but downstream services keep working, the system burns resources on work nobody is waiting for. A strong answer mentions deadlines, cancellation, retry budgets, and circuit breaking.

## Request Path And Failure Hooks

A full request-path answer can be:

```text
browser -> DNS -> TCP/TLS -> L7 gateway/load balancer -> FastAPI -> service layer -> DAL -> Oracle -> response
```

Put responsibilities in the right layer:

- gateway: TLS termination, WAF, request size limits, coarse authentication, rate limiting
- app: schema validation, authorization, idempotency check, business invariant checks
- service layer: transaction boundary, downstream deadline, retry policy
- DAL / DB: constraints, isolation, version checks, unique keys
- response: status code, structured error, request id, trace id

## What To Log Or Measure

Minimum useful signals:

- request id and trace id
- authenticated user and tenant, without leaking sensitive data
- endpoint, method, status code, latency
- idempotency key outcome: `new`, `replayed`, `processing`, `payload_mismatch`
- retry count and timeout count by endpoint
- `409`, `412`, `422`, and `429` rates
- invalid cursor rate
- DB connection-pool wait time
- transaction retry/deadlock count
- downstream timeout and deadline-exceeded count
- p95 and p99 latency

The interview-grade explanation:

```text
I want logs for individual debugging, metrics for trend detection, and traces for cross-service causality.
```

## Common Mistakes

- treating timeout as failure instead of unknown outcome
- putting idempotency state only in Redis without durable replay
- generating the idempotency key on the server after receiving duplicate requests
- replaying a response for the same key but different payload
- retrying `PATCH increment` as if it were idempotent
- using `409` and `412` interchangeably
- designing cursor pagination without a tie-breaker
- returning human-only error messages with no machine-readable recovery code
- letting downstream work continue after upstream timeout

## Interview Answer Shapes

For 60-90 seconds:

```text
I design APIs around recoverability. For side-effecting POST endpoints, retries need idempotency keys backed by durable storage. The server stores the payload fingerprint, operation status, and original response, so a retry after timeout can replay completed work, return 202 for processing work, or 409 if the key is reused with a different payload. For updates, I use ETag/version with If-Match and return 412 for stale writes. Errors include stable codes, retryability, recovery action, request id, and trace id. For list endpoints, I prefer cursor pagination with a deterministic key like created_at plus id. Then I measure retries, conflicts, stale writes, rate limits, latency, and downstream deadline failures.
```

For a 10-15 minute deep dive, walk through:

1. resource model and method choice
2. idempotency table and unique constraints
3. transaction sequence for create
4. replay rules for timeout and duplicate requests
5. stale update handling with `If-Match`
6. structured error response
7. cursor pagination
8. observability and rate-limit protection

For a 30-45 minute design discussion, be ready to draw:

```text
client
  -> gateway/rate limit/authn
  -> API service/idempotency check/authz
  -> DB transaction/business rows/idempotency rows/outbox rows
  -> worker/downstream service
  -> logs/metrics/traces
```

Then answer pushback:

- What if the client retries while the first request is still processing?
- What if the same idempotency key is reused with a different payload?
- What if the DB commits but the response is lost?
- What if notification succeeds but the API returns 500?
- What if two users update the same appointment from old screens?
- What if pagination happens while new rows are inserted?
- What if a downstream service ignores cancellation?

## Final Takeaway

The Tier A/S answer is not "use REST and status codes." It is:

```text
define the recovery contract, store enough durable state to honor it, make unsafe retries impossible or explicit, and expose enough telemetry to debug the path when the distributed system lies.
```
