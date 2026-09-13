---
title: "Replication Lag And Replica Routing"
summary: "Database replication as a freshness and routing problem, not just read scaling"
description: "Database scaling review notes for primary/replica, replication lag, and read-after-write consistency"
date: 2026-05-26
tags: ["database", "database-scaling", "replication", "read-replica", "consistency"]
categories: ["database"]
aliases:
  - /distribution-system/replication-lag-and-replica-routing/
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

This topic is not just:

```text
replicas can serve reads
```

At a Tier A/S interview bar, you need to explain:

- what the primary / replica write path looks like
- what user-visible bug replication lag creates
- which endpoints require read-your-writes behavior
- how immediate reads are routed after writes
- what to do when lag exceeds the expected consistency window
- why replicas do not fix bad queries, missing indexes, or primary write bottlenecks
- which metrics prove the routing design is healthy

The core rule:

```text
Read replicas scale stale-tolerant reads, not every read.
The hard part is deciding which reads are allowed to be stale.
```

## Tier A/S Readiness

If the answer is only:

```text
replicas help reads, but replication lag may make data stale
```

that is not enough.

A strong answer adds:

- a write committed on the primary is not necessarily visible on replicas immediately
- lag creates read-after-write inconsistency, not vague eventual-consistency trivia
- freshness policy should be endpoint-specific, not one global rule
- post-write reads can use primary pinning, session stickiness, resource stickiness, or version / LSN / timestamp gating
- a fixed sticky window is a heuristic, not a correctness proof
- lag spikes, failover, reporting queries, and long apply backlogs can break naive routing
- observability must answer whether a stale response came from replica lag, cache, or routing

## Primary / Replica Mental Model

Basic flow:

```text
client
  -> API service
  -> write transaction on primary
  -> commit success
  -> replication stream / log shipping / apply on replica
  -> later reads may hit primary or replica
```

Replicas help with:

- read QPS
- isolating some read-heavy workloads
- keeping reporting or dashboard reads away from the primary
- high availability and failover architecture

But replicas add:

- freshness decisions
- routing policy as a correctness concern
- product bugs during lag spikes
- debugging that must include read source and observed version

## Product Bug

Appointment confirmation:

```text
POST /appointments/123/confirm
  -> primary commit success

GET /appointments/123
  -> routed to lagging replica
  -> returns old status = PENDING
```

The user does not experience this as "eventual consistency."

The user experiences:

- the success response did not seem to stick
- they press confirm again
- support sees conflicting status
- downstream workflow makes a decision from old state

Billing and payment are riskier:

```text
payment captured on primary
invoice page reads lagging replica
UI still shows unpaid
user retries payment
```

That turns a stale read into duplicate-action risk.

So a strong answer starts with product impact, not only database delay.

## Freshness Classes

Do not say:

```text
all reads go to replicas
```

Do not say:

```text
all reads go to primary
```

Classify endpoints by freshness.

### Primary-Consistent Reads

These reads need the newest state, so they usually hit primary or require a proven freshness gate.

Examples:

- payment result after charge
- appointment booking / confirmation result
- patient record immediately after update
- next validation step in a mutation workflow
- idempotency result lookup after retry
- immediate status read after an admin action

Decision rule:

```text
If stale data can cause duplicate action, wrong workflow, or user-visible contradiction,
do not blindly route it to a replica.
```

### Bounded Read-Your-Writes

These reads may normally use replicas, but need freshness for a short period after a write.

Examples:

- user refreshes a profile right after saving it
- appointment list right after creating or canceling an appointment
- note list right after creating a note

Common strategy:

```text
after a successful write, pin related reads to primary for N seconds
```

Or:

```text
after a successful write, pin reads for this user / session / resource to primary
until freshness is proven.
```

### Stale-Tolerant Reads

These are good replica candidates.

Examples:

- reporting dashboards
- historical logs
- read-mostly reference data
- catalog-style lookup
- aggregate metrics with a freshness label

But:

```text
stale-tolerant does not mean unboundedly stale.
```

A dashboard may tolerate data being 30 seconds old. That does not mean it can silently show yesterday's state.

### Async / Pending UX

Some flows cannot guarantee immediate visibility cheaply.

In those cases, a better product behavior may be:

- `processing`
- `pending confirmation`
- `refreshing`
- `last updated at`
- disabling duplicate action buttons temporarily

This is not avoiding consistency. It is representing the actual consistency model honestly.

## Read-After-Write Routing Strategies

### Strategy 1 - Endpoint-Based Primary Routing

The simplest rule:

```text
freshness-critical endpoints always read primary
```

Pros:

- clear correctness story
- easy debugging
- does not depend on guessed lag windows

Cons:

- more primary load
- if classification is too broad, replicas do not help much

Good fit:

- payment status
- booking confirmation
- critical status after a user action

### Strategy 2 - Sticky Read-After-Write Window

Common practical rule:

```text
after write success, route related reads to primary for 5-30 seconds
```

Stickiness can be scoped by:

- session
- user
- tenant
- resource id
- request context

Pros:

- relatively simple
- handles common short lag
- does not require every replica to expose exact catch-up state

Cons:

- too short: lag spikes still produce stale reads
- too long: primary receives too many reads
- multiple devices or sessions may not share the marker
- it is a heuristic, not a strict proof

Interview-safe line:

```text
Sticky read-after-write is practical, but it is still a bounded heuristic unless tied to real freshness signals.
```

### Strategy 3 - Version / Timestamp / LSN Gating

A stronger approach is to carry a freshness requirement with the read.

The write returns:

```json
{
  "appointment_id": "123",
  "status": "CONFIRMED",
  "commit_version": "v84291"
}
```

The follow-up read requires:

```text
serve from a replica only if replica_version >= v84291
otherwise route to primary or return pending
```

Possible markers:

- commit timestamp
- monotonically increasing version
- log sequence number / GTID / WAL position
- application-level `updated_at`, with caveats

Pros:

- stronger than a fixed window
- avoids overusing primary when replicas are already fresh
- handles lag spikes with accurate fallback

Cons:

- requires database or middleware support for comparable replication progress
- increases system complexity
- clock-based markers need care around clock skew and semantics

### Strategy 4 - Lag-Aware Replica Selection

With multiple replicas, do not choose randomly.

Select by:

- lag threshold
- region / latency
- workload class
- query type
- replica health

Example:

```text
critical stale-tolerant reads require replica lag < 2s
analytics reads can tolerate lag < 5m
```

If all replicas exceed the threshold:

- route to primary
- return stale data with a label
- disable a non-critical panel
- return `202` / pending for async workflows

## Failure Matrix

| Failure | User sees | Likely cause | Correct response |
|---|---|---|---|
| Immediate read misses new row | newly created data is missing | read hit lagging replica | primary pin or version gate |
| Old status after successful mutation | UI shows previous state | replica lag or stale cache | log source and bypass stale layers on critical paths |
| Sticky window fails | intermittent stale bug | lag spike > fixed window | dynamic fallback or primary read |
| Replica slow but not stale | high read latency | expensive query / overloaded replica | query/index fix, read-pool isolation |
| Primary still overloaded | replicas did not solve load | writes, critical reads, locks remain on primary | narrow primary-consistent reads, fix write path |
| Refreshes show different states | replicas are at different lag points | load balancing across replicas | session affinity or version-aware routing |
| Cache refilled from stale replica | cache contains old value again | refill source was lagging | post-write bypass or refill from primary |
| Failover breaks routing | reads/writes hit wrong role | topology changed | role discovery, health checks, circuit breaker |

## What Replicas Do Not Fix

Replicas are a read-scaling tool, not a universal database fix.

They do not fix:

- bad query shape
- missing or wrong indexes
- non-SARGable predicates
- over-wide response payloads
- primary write bottleneck
- lock contention
- long transactions
- writer connection pool pressure
- cross-entity correctness invariants

If the original query is:

```text
scan huge table -> filter late -> return wide rows
```

adding replicas just copies the bad access pattern to more machines.

Strong answer order:

1. Determine whether the bottleneck is read QPS or bad query shape.
2. If query/index/schema is clearly wrong, fix the access path first.
3. If the workload is read-heavy and stale reads are acceptable, use replicas.
4. If the bottleneck is primary writes or lock contention, replicas do not cure it.

## Replicas Vs Redis

They are not interchangeable.

| Tool | Solves | Adds |
|---|---|---|
| Read replica | DB read capacity | replication lag, freshness routing |
| Redis cache | repeated expensive reads / low-latency hot data | invalidation, stale cache, stampede, outage fallback |

Replica lag:

```text
primary is newer than replica for a while
```

Cache invalidation bug:

```text
database is newer than cache because cache update/delete/refill policy failed
```

If the endpoint is payment status or appointment status immediately after write, blindly stacking Redis and replicas makes debugging harder:

```text
Is the stale value from cache?
Was cache refilled from a lagging replica?
Did routing ignore the post-write marker?
```

Freshness-critical paths should stay simple.

## Design Example: Appointment Confirmation

Goal:

```text
After POST /appointments/{id}/confirm returns success,
the user must not see the appointment as unconfirmed on refresh.
```

Write path:

```text
API -> primary transaction -> commit -> response includes status/version
```

Read policy:

- immediate GET by same user/resource goes to primary
- appointment confirmation page is primary-consistent
- appointment list can use post-write stickiness for that user/resource
- background reporting can read replicas

Fallback:

- if replica lag exceeds threshold, route related reads to primary
- if primary pressure is high, keep only critical paths on primary
- if freshness cannot be guaranteed cheaply, show `pending confirmation`

Metrics:

- confirm write latency
- immediate read source
- stale status mismatch count
- duplicate confirm click rate
- fallback-to-primary rate
- replica lag at read time

## Design Example: Billing / Payment

Goal:

```text
After payment succeeds, the invoice page must not encourage a duplicate payment.
```

Read policy:

- payment result read: primary
- idempotency result lookup: primary or strongly consistent store
- invoice status immediately after payment: primary or pending
- historical invoice list: replica allowed if there is a freshness label

Why:

- stale unpaid status can cause duplicate user action
- idempotency protects the write side, but stale reads still hurt UX and support
- if the external payment result is ambiguous, use idempotency and reconciliation, not stale replica state

## Design Example: Reporting Dashboard

Reporting is a better replica candidate.

Why:

- read-heavy
- not in the critical mutation path
- can show freshness
- can tolerate bounded delay

But still watch for:

- long-running reports slowing replica apply
- dashboard queries that remain slow because indexes are missing
- reporting workloads competing with user-facing OLTP reads

Strong answer:

```text
I would not let heavy reporting queries compete with user-facing read replicas unless the capacity and lag budget are explicit.
```

## What Breaks At Scale

As tenants, hospitals, or traffic grow:

- write bursts increase replica lag
- read-your-writes traffic falls back to primary and fills the primary pool
- hot tenants overload a subset of replicas or a primary partition
- reporting queries consume replica CPU / I/O and slow apply
- failover changes topology while the application routing cache is stale
- the read pool looks healthy, but freshness-critical endpoints keep falling back to primary
- stale reads cause duplicate clicks, support tickets, client retries, and more traffic

This is why average QPS is not enough.

## What To Log

Each read request should ideally record:

- endpoint
- user / tenant / resource id
- read source: primary, replica id, cache
- whether the request carried a post-write marker
- required freshness version / timestamp
- served version / timestamp
- replica lag at serve time
- fallback reason
- trace id / correlation id

Each write request should record:

- commit success time
- returned version / timestamp
- affected resource
- idempotency key if relevant
- immediate follow-up reads

These logs let you say:

```text
The user saw stale data because the GET after write went to replica-2,
which was 18 seconds behind, and the post-write primary pin marker was missing.
```

## What To Measure

System metrics:

- replica lag by node
- primary QPS / replica QPS
- primary write latency
- replica read latency
- connection pool saturation by role
- slow query count by role
- failover events and routing errors
- replication apply delay

Product metrics:

- read-after-write fallback-to-primary rate
- stale-read incident count on critical endpoints
- duplicate action rate after mutation
- support tickets related to "update not showing"
- pending-state duration
- freshness label age distribution

Do not only look at:

```text
average replica lag = 1s
```

Product bugs may happen at:

- p99 lag
- one bad replica
- one tenant
- one endpoint
- one post-write flow

## Debugging Playbook

Issue:

```text
I confirmed an appointment, refreshed, and still saw pending.
```

Debug order:

1. Did the write actually commit?
2. Did the response include status / version / resource id?
3. Did the follow-up read hit primary, a replica, or Redis?
4. Did the read request carry a post-write marker?
5. Did the routing layer correctly apply the freshness requirement?
6. How much lag did that replica have at the time?
7. If cache was involved, when was the cache written and was it refilled from primary or replica?
8. Did another device or session miss the stickiness marker?
9. Did the UI enable duplicate action based on stale state?

This is stronger than merely saying "replica lag caused it" because it gives a complete debugging path.

## 10-15 Minute Deep Dive Path

Use this order:

1. Draw the request path:

```text
client -> API -> primary write -> replication stream -> replicas -> read router
```

2. State the bug caused by lag:

```text
write succeeded, but immediate read sees old state
```

3. Classify endpoints by freshness:

| Endpoint | Policy |
|---|---|
| payment result | primary |
| appointment confirmation | primary or proven-fresh replica |
| patient record after update | post-write primary pin |
| normal list/search | replica if stale is acceptable |
| reporting dashboard | replica / reporting store with freshness label |

4. Choose routing strategy:

- primary by endpoint
- sticky window after write
- version / LSN gating
- lag-aware replica selection
- pending UX when freshness is expensive

5. Explain fallback:

- lag under threshold: use replica
- lag too high: primary or pending
- primary overloaded: narrow critical paths, optimize query/write path
- failover: refresh topology and use health checks

6. Explain observability:

- source logging
- lag by node
- fallback rate
- stale incident count
- duplicate action rate
- p95 / p99 latency by role

## 30-45 Minute Design Pushback

Prompt:

```text
Scale a hospital backend from 10 to 500 hospitals.
Reads are growing fast, writes still go through one primary,
and some patient-facing pages refresh immediately after updates.
```

Answer structure:

### 1. Ask For The Bottleneck

- Is read QPS actually overloading the primary?
- Is the slow path really an index or query-shape problem?
- Are writes, locks, or transactions the real bottleneck?
- Which endpoints are truly allowed to be stale?

### 2. Split The Workload

- OLTP mutation path
- immediate post-write reads
- stale-tolerant browsing / search
- reporting / analytics
- background jobs

### 3. Design The Read Router

Router inputs:

- endpoint policy
- user / session marker
- resource id
- last write version
- replica health / lag
- feature flag / failover state

Router outputs:

- primary
- specific replica
- pending response
- stale-labeled response
- degraded response

### 4. Handle Pushback

If asked "why not send every read to replicas":

```text
because read traffic and freshness-critical read traffic are different workloads.
```

If asked "why not send every read to primary":

```text
because stale-tolerant reads should not consume writer capacity if replicas can serve them safely.
```

If asked "what about lag spikes":

```text
fixed sticky windows are not enough; use lag-aware fallback or primary routing for critical paths.
```

If asked "can Redis solve it":

```text
Redis helps repeated reads, but it adds invalidation complexity and can be refilled from stale sources.
It does not remove the need for endpoint-level freshness policy.
```

## Interview Pushback

1. How do you handle a read right after a write if replicas lag?
2. Which endpoints can tolerate stale reads, and which cannot?
3. Why is a sticky read-after-write window only a heuristic?
4. What if lag exceeds the stickiness window?
5. How would version / LSN gating improve the design?
6. Why are replicas not a fix for bad query shape?
7. Why can adding replicas still leave primary overloaded?
8. How do you debug whether stale data came from replica lag or Redis?
9. What changes during failover?
10. How do you measure product impact, not just database lag?

## 60-90 Second Answer

Read replicas can reduce read load, but they create freshness trade-offs. Writes usually commit on the primary first and replicas catch up later, so the classic bug is read-after-write inconsistency: an appointment confirmation succeeds, then the immediate GET hits a lagging replica and the user sees the old status or not found. I would not route all reads to replicas. I would classify endpoints: payment, booking confirmation, and patient records right after update need primary-consistent or proven-fresh reads; dashboards, historical logs, and non-critical lists can use replicas with freshness labels. After a write, I can pin related reads to primary for a short window or use version / LSN gating to prove a replica caught up. If lag exceeds the threshold, I fallback to primary, show pending, or degrade non-critical panels. Finally, replicas do not fix bad query/index/schema design or primary write bottlenecks, so I would measure replica lag, fallback rate, stale incidents, primary/replica pools, and slow queries.

## Final Deliverables

After reviewing this note, you should be able to:

- draw the primary write, replication apply, and read-router request path
- explain read-after-write inconsistency with an appointment or payment flow
- classify endpoints into primary-consistent, bounded read-your-writes, and stale-tolerant
- compare primary routing, sticky windows, version / LSN gating, and pending UX
- explain when sticky windows fail
- explain why replicas do not fix bad queries, missing indexes, or primary write bottlenecks
- distinguish replica lag from Redis invalidation bugs
- design read-router inputs and outputs
- name debugging log fields and production metrics
- handle lag spike, failover, primary overload, and Redis pushback
