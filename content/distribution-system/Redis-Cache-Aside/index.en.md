---
title: "Redis Cache-Aside"
summary: "Cache-aside, invalidation, stale reads, hot keys, and Redis outage fallback"
description: "Distributed cache review notes for cache-aside, invalidation, stale reads, hot keys, and Redis fallback"
date: 2026-05-28
tags: ["distributed-systems", "redis", "cache-aside", "caching", "consistency"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

A Redis / caching answer cannot stop at:

```text
read cache first, miss then read DB
```

At a Tier A/S interview bar, you need to explain:

- which endpoints are cacheable and which should not be cached blindly
- cache-aside, read-through, write-through, and write-behind trade-offs
- how to choose TTL and whether the product accepts the stale window
- whether writes should delete, refresh, event-invalidate, or tolerate bounded staleness
- how to handle cache stampede, hot keys, negative caching, and cold start
- whether Redis outage falls back to DB, degrades, or fails closed
- when Redis is the right fix and when it is hiding bad query / index / schema design
- what to log so stale data can be traced to cache, replica, or DB state

The core rule:

```text
Cache is not just a faster read path.
It is a second data visibility layer with freshness, invalidation, and failure-mode cost.
```

## Tier A/S Readiness

If the answer is only:

```text
Redis makes reads faster, use TTL and invalidate after write.
```

that is not enough.

A strong answer adds:

- verify the DB path is healthy before caching it
- choose freshness policy by endpoint
- distinguish stale UX issues from correctness bugs
- protect the DB during cache miss, rebuild, and Redis outage
- handle hot keys that make the cache tier the bottleneck
- understand how negative caching can hide newly created resources
- avoid making stale-source debugging impossible when cache and replicas are stacked
- do not treat Redis as the only source of truth for payment, booking, or authorization correctness

## Mental Model

Redis is not:

```text
DB slow -> add cache
```

A better rule:

```text
Cache repeated expensive reads when the DB path is reasonable,
the data has reuse,
and the endpoint can tolerate the freshness model.
```

Cache can reduce:

- repeated read latency
- DB read QPS
- repeated aggregation cost
- hot metadata lookup

But it adds:

- stale reads
- invalidation complexity
- cache stampede
- hot key bottlenecks
- Redis outage fallback
- warmup / cold start problems
- another data source to debug

## First Ask: Should This Be Cached?

Before adding Redis, ask seven questions:

1. Is this endpoint read-heavy?
2. Is the same key read repeatedly?
3. Is the DB query already reasonable?
4. Can the data be stale for seconds, minutes, or not at all?
5. Is the write-side invalidation rule clear?
6. Can the DB survive cache misses?
7. If Redis is down, should the product fallback, degrade, or fail closed?

If the answers are unclear, do not rush into caching.

## Good Cache Candidates

Better candidates:

- hospital metadata
- department / doctor directory
- read-mostly reference data
- feature / configuration snapshot
- dashboard summary with freshness label
- expensive non-critical aggregation
- permission-derived view snapshot with short TTL and clear invalidation

Common traits:

- read-heavy
- repeated access
- relatively stable data
- explicit stale bound
- stable key shape
- explainable invalidation

## Risky Cache Candidates

Be careful with:

- payment status immediately after charge
- appointment booking capacity
- patient record immediately after mutation
- permission or authorization decisions with security impact
- idempotency result stored only in non-durable Redis
- inventory / slot availability that changes quickly
- rapidly changing personalized state

Decision rule:

```text
If stale data can cause duplicate action, wrong authorization, or broken business invariant,
cache cannot be treated as the source of truth.
```

Cacheable does not mean blindly trusted.

## Cache-Aside

Read path:

```text
read Redis
if hit:
    return cached value
if miss:
    read DB
    write Redis with TTL
    return DB value
```

Common write path:

```text
write DB
delete cache key
```

Or:

```text
write DB
refresh cache value
```

The hard part of cache-aside is not the miss path. It is how cache and DB converge again after writes.

### Delete-On-Write

Flow:

```text
commit DB write
delete cache key
next read rebuilds from DB
```

Pros:

- simple
- avoids calculating full cache value in the write path
- removes old data faster than TTL-only

Cons:

- failed delete leaves stale value
- next read can create a miss burst
- concurrent reads may still see the old value before delete
- if rebuild reads from a lagging replica, old data can be written back into cache

### Refresh-On-Write

Flow:

```text
commit DB write
compute latest cache value
set cache key
```

Pros:

- the next read is more likely to hit fresh cache
- good when the new value is easy to compute

Cons:

- heavier write path
- refresh failure creates DB/cache divergence
- concurrent writes can let an older refresh overwrite a newer value

Use with:

- versioned values
- compare-and-set
- monotonic update checks
- ordered events

### TTL-Only

Flow:

```text
set key with TTL
do not explicitly invalidate on write
```

Pros:

- simplest
- good for data where staleness is acceptable

Cons:

- stale window always exists
- after a write, users may keep seeing old value until TTL expires
- short TTL hurts hit rate; long TTL increases correctness risk

Good fit:

- metadata
- reference data
- dashboard summaries
- non-critical aggregates

Bad fit:

- payment result
- booking capacity
- immediate status after mutation

## Read-Through / Write-Through / Write-Behind

Cache-aside means the application controls miss and fill behavior.

Read-through:

```text
application reads cache layer
cache layer loads DB on miss
```

This simplifies app code, but can hide source and fallback behavior.

Write-through:

```text
write goes through cache layer and DB/cache are updated together
```

The cache is fresher, but write latency and failure handling become more complex.

Write-behind:

```text
write cache first, flush to DB asynchronously later
```

Use extreme care. Redis is usually not the durable source of truth. Unless durability, ordering, replay, DLQ, and reconciliation are designed explicitly, do not put critical payment or booking state behind write-behind.

## Key Design

A good cache key includes:

- namespace
- entity type
- id
- version or schema version
- tenant / hospital scope when needed
- language / locale when response differs
- authorization scope if response depends on permissions

Examples:

```text
hospital:{hospital_id}:doctor-directory:v3
patient:{patient_id}:profile-summary:v2
dashboard:{hospital_id}:{date}:summary:v5
```

Avoid:

- missing tenant scope, which can leak data across tenants
- missing schema version, which can serve old response shapes
- too many high-cardinality parameters, which destroys hit rate
- overly broad keys, which make invalidation too expensive

Security note:

```text
If the cached response depends on who is asking, the key must include the authorization scope
or the endpoint must not cache the personalized response directly.
```

## Invalidation Strategies

### 1. Delete-On-Write

Good fit:

- cache value can be rebuilt on the next read
- write path should not compute full response
- stale window should be shorter than pure TTL

Add:

- retry for delete failure
- idempotent invalidation
- after-commit invalidation, not pre-commit deletion that survives rollback

### 2. Refresh-On-Write

Good fit:

- next read comes soon after write
- new value is cheap to compute
- stale risk is high but still cacheable

Add:

- version check to prevent old refresh overwriting new value
- refresh failure fallback
- awareness of extra write latency

### 3. Event-Driven Invalidation

Flow:

```text
DB write commits
domain event / outbox emits change
consumer invalidates or refreshes cache
```

Pros:

- write path can stay lighter
- many keys can be handled by a consumer

Cons:

- event delivery delay
- consumer lag
- duplicate events
- out-of-order events
- invalidation gap

Use with:

- idempotent consumer
- versioned event
- retry / DLQ
- invalidation-lag monitoring

### 4. Versioned Keys

Flow:

```text
cache key includes data version
```

Example:

```text
doctor-directory:{hospital_id}:v42
```

Pros:

- old key cannot overwrite new key
- schema changes are easier to cut over

Cons:

- old-key cleanup is required
- version source must be reliable
- key count can grow quickly

## Stale-Read Trade-Off

Say what kind of staleness is acceptable.

Acceptable:

- doctor directory updated a few minutes late
- dashboard aggregate with `last updated at`
- reference data with TTL
- non-critical search results delayed slightly

Dangerous:

- payment succeeded but UI still shows unpaid
- appointment slot is booked but cache says available
- stale patient-note read causes overwrite
- authorization change happens but cache still allows access

Strong answer:

```text
Staleness is a product and correctness decision, not only a cache setting.
```

## Negative Caching

Negative caching stores `not found` or empty results.

Good fit:

- preventing nonexistent keys from repeatedly hitting DB
- repeated empty search results
- expensive external lookups that often miss

Risk:

```text
resource is created right after a cached negative result
```

Example:

1. `GET /patients/123` misses, cache `not found`
2. patient is created
3. cache still returns `not found`

Fixes:

- short TTL for negative cache
- invalidate related negative keys on create/update
- do not rely on negative cache in freshness-critical create flows
- include tenant / scope in the key

## Cache Stampede

A stampede happens when a hot key expires or misses and many requests hit DB together.

Example:

```text
popular dashboard key expires
10k requests miss together
all rebuild from DB
DB latency spikes
more retries arrive
```

Mitigations:

- single-flight / request coalescing
- per-key rebuild lock with short timeout
- TTL jitter
- stale-while-revalidate
- background refresh before expiry
- pre-warm critical keys after deploy
- rate-limit expensive rebuild paths
- serve stale value when DB is degraded

Important:

```text
The rebuild path must be protected, not just the happy cache-hit path.
```

## Hot Keys

A hot key concentrates traffic on one cached item.

Symptoms:

- one Redis node has high CPU / network
- one key has far higher QPS than others
- p99 cache latency spikes
- DB is hit hard when that key expires
- in cluster mode, slots look balanced but one key/slot is hot

Mitigations:

- local in-process cache for ultra-hot read-only values
- key replication / client-side read copies
- split key by natural dimension
- precompute smaller chunks
- TTL jitter
- single-flight
- stale-while-revalidate

Example:

```text
dashboard:{hospital_id}:today
```

If everyone reads the same dashboard, consider:

- per-department summary
- background precomputed summary
- local short-TTL cache
- stale display with async refresh

## If Redis Is Down

First decide whether Redis is:

```text
optimization
```

or:

```text
correctness dependency
```

### Redis As Optimization

If Redis is only acceleration:

- fallback to DB
- limit fallback QPS
- use circuit breaker behavior
- shed non-critical traffic
- serve a stale local snapshot if acceptable
- skip cache writes temporarily
- monitor DB pressure

But DB fallback is not free:

```text
Redis outage can turn into DB outage if every miss falls through at full speed.
```

### Redis As Correctness Dependency

If Redis is used for:

- lock
- rate limit
- dedupe
- session
- idempotency

be careful.

For critical mutations such as payment, order, and booking:

```text
Redis should not be the only durable source of truth.
```

Safer tools:

- durable idempotency table
- database unique constraint
- transaction boundary
- outbox / reconciliation
- Redis only as fast path or short-lived coordination layer

## Redis vs Query / Index / Schema Fix

Redis is not an automatic response to a slow query.

Diagnose first:

- is the query plan healthy?
- is there a full scan?
- is the predicate SARGable?
- does composite index order match the query?
- is projection too wide?
- is there an N+1 join pattern?
- does schema fight the access pattern?
- is the read repeated with high cache locality?
- is staleness acceptable?

If the DB path is bad:

```text
fix query/index/schema first, otherwise cache miss will reveal the same bottleneck.
```

If the DB path is reasonable but the same data is repeatedly read:

```text
Redis may be the right next layer.
```

The strong answer is not Redis vs index as a binary choice:

```text
The database path should remain survivable when cache misses or Redis degrades.
```

## Cache + Replica Risk

Redis and read replicas can be used together, but freshness gets harder.

Risky path:

```text
cache miss
  -> read lagging replica
  -> refill cache with stale value
  -> stale value survives TTL
```

For write-after-read critical endpoints:

- bypass cache briefly after writes
- refill cache from primary
- or require replica catch-up to a version
- include version / updated_at in cached value
- label stale responses

Debugging must answer:

- did the response come from cache hit?
- after cache miss, did DB read use primary or replica?
- what version was cached?
- how much lag did the replica have?

## Failure Matrix

| Failure | User sees | Root cause | Fix |
|---|---|---|---|
| Stale cache after write | old data after update | invalidation failed / TTL-only | after-commit delete, versioned key, short stale window |
| Cache stampede | DB spike after miss | hot key expired | single-flight, jitter, stale-while-revalidate |
| Hot key | Redis p99 spike | one key receives massive QPS | local cache, split key, key replication |
| Negative cache stale | new resource still not found | cached negative result | short TTL, invalidate on create |
| Redis outage -> DB outage | cache failure takes DB down | unbounded fallback | circuit breaker, rate limit, degrade |
| Cache refill stale | old data written back into cache | miss reads lagging replica | refill from primary or version gate |
| Wrong auth cache | user sees data they should not see | key missing auth scope | include scope or do not cache personalized response |
| Old refresh overwrites new | cache regresses to older value | out-of-order refresh | versioned values, compare-and-set |

## Design Example: Doctor Directory

This is a good cache candidate.

Why:

- read-heavy
- low update rate
- stale for a few minutes is usually acceptable
- clear key shape

Key:

```text
doctor-directory:{hospital_id}:v3
```

Read:

```text
cache hit -> return
cache miss -> DB query -> set TTL with jitter
```

Write:

```text
doctor profile update commits
delete doctor-directory:{hospital_id}:v3
optionally publish invalidation event
```

Metrics:

- hit rate
- fill latency
- stale complaint
- invalidation failure
- Redis latency

## Design Example: Appointment Availability

This is a risky cache candidate.

Why:

- data changes quickly
- stale availability can show unavailable slots as open
- correctness must still come from DB transaction / constraint / lock

Possible design:

- cache read-only slot suggestions with short TTL
- final booking confirmation uses authoritative DB path
- writes invalidate affected slot keys
- UI says availability can change
- final booking transaction re-checks capacity

Strong answer:

```text
Cache can help discovery, but the final booking decision must be made against the source of truth.
```

## Design Example: Dashboard Summary

Dashboards are usually good cache candidates, but must show freshness.

Strategy:

- precompute summary
- cache by tenant/date/filter
- TTL + jitter
- background refresh
- stale-while-revalidate
- `last_updated_at`

If the dashboard is heavy:

- do not run a huge aggregation synchronously on every miss
- use background job / materialized summary
- return stale value or pending during rebuild

## What Breaks At Scale

At scale:

- average hit rate is high, but one critical endpoint still misses often
- a hot key overloads one Redis node
- synchronized expiry creates DB spikes
- Redis deploy / failover creates cold cache
- unbounded DB fallback turns a Redis issue into a DB outage
- stale data causes duplicate actions and support tickets
- key explosion causes memory pressure and evictions
- invalidation consumer lag creates long stale windows
- cached responses without tenant/auth scope can leak data

## What To Log

Each read should log:

- endpoint
- cache key namespace
- cache hit / miss
- cache value version / updated_at
- Redis node / latency
- fallback source: primary / replica
- post-write bypass marker
- tenant / auth scope hash
- rebuild duration
- whether stale-while-revalidate was served

Each write / invalidation should log:

- affected keys
- after-commit invalidation result
- event id / version
- invalidation consumer lag
- refresh success / failure
- compare-and-set result

## What To Measure

Cache metrics:

- hit rate by endpoint
- miss rate by endpoint
- hit latency vs miss latency
- cache fill latency
- Redis CPU / memory / network
- Redis timeout / error rate
- eviction count
- hot key distribution
- key cardinality

DB protection metrics:

- fallback-to-DB rate
- DB QPS during miss bursts
- slow query during cache-degraded windows
- stampede prevention hit count
- rebuild concurrency per key

Correctness metrics:

- stale-read incident count
- negative-cache false miss
- duplicate action after stale page
- invalidation failure count
- invalidation lag
- auth/cache scope violation alert

## Debugging Playbook

Issue:

```text
I updated a doctor's profile, but the old value is still shown.
```

Debug:

1. Did the write commit?
2. Which cache keys should have been affected?
3. Did invalidation run after commit or before commit?
4. Did delete / refresh succeed?
5. Was the read a cache hit, DB read after miss, or replica refill?
6. What value version / updated_at was cached?
7. Was a secondary namespace missed?
8. Is TTL longer than the product freshness window?

Issue:

```text
DB load spiked exactly at Redis key expiry.
```

Debug:

1. Which keys expired together?
2. Was there no TTL jitter?
3. Was single-flight missing?
4. Is the rebuild query expensive?
5. Is fallback unbounded?
6. Can stale-while-revalidate be served?

## 10-15 Minute Deep Dive Path

Use this order:

1. Decide whether the endpoint should be cached:

```text
read-heavy, repeated, stable enough, clear invalidation, acceptable stale window
```

2. Draw cache-aside read path:

```text
client -> API -> Redis -> DB on miss -> Redis fill -> response
```

3. Draw write path:

```text
DB commit -> after-commit delete/refresh -> optional event invalidation
```

4. Discuss freshness:

- metadata stale is acceptable
- dashboard stale with label is acceptable
- payment / booking / auth stale is dangerous

5. Discuss failures:

- stampede
- hot key
- Redis down
- negative cache
- stale refill from replica

6. Discuss protections:

- single-flight
- TTL jitter
- stale-while-revalidate
- circuit breaker
- rate-limited DB fallback
- versioned keys

7. Close with metrics:

- hit/miss
- latency
- stale incidents
- invalidation lag
- fallback DB pressure

## 30-45 Minute Design Pushback

Prompt:

```text
Design a caching layer for a hospital backend.
Some metadata reads are hot, dashboards are expensive,
but booking/payment correctness cannot be stale.
```

Answer structure:

### 1. Classify Endpoints

Cache:

- doctor directory
- hospital metadata
- stable config
- dashboard summary with freshness label

Do not blindly cache:

- payment status after charge
- appointment booking capacity
- patient record after mutation
- auth-sensitive personalized response

### 2. Key Design

- namespace
- tenant scope
- entity id
- version
- locale/filter
- auth scope if needed

### 3. Read / Write Policy

- cache-aside for normal reads
- after-commit delete for mutable records
- background refresh for expensive dashboard
- versioned keys for schema/value ordering

### 4. Failure Handling

- Redis timeout: short timeout and fallback/degrade
- miss storm: single-flight + stale-while-revalidate
- hot key: local cache / split / precompute
- stale data: version check / freshness label / bypass after write

### 5. DB Protection

- fallback rate limit
- circuit breaker
- serve stale for non-critical data
- do not cache over a broken query path

### 6. Observability

- hit rate by endpoint
- miss burst
- stale incident
- invalidation lag
- DB QPS during Redis degradation
- hot keys

## Interview Pushback

1. How do you invalidate cache after a write?
2. Why is TTL alone not enough?
3. How do you stop 10k requests from stampeding the DB?
4. What if Redis is down?
5. Which endpoints should never use stale cache?
6. How do you avoid caching data across tenant/auth boundaries?
7. How do you debug stale data if both Redis and replicas exist?
8. When is Redis hiding a bad query instead of solving the problem?
9. What is negative caching, and what can go wrong?
10. How do you keep old cache refreshes from overwriting newer data?

## 60-90 Second Answer

Redis is a good fit for repeated expensive reads when the DB path is already reasonable, the data has reuse, the endpoint can tolerate a clear stale window, and invalidation is well defined. Cache-aside reads Redis first, falls back to DB on miss, then fills Redis; the write path is just as important, usually deleting or refreshing cache after DB commit. Doctor directory, metadata, and dashboard summaries are good candidates. Payment status, booking capacity, patient records right after mutation, and auth-sensitive responses are dangerous to treat as stale cache sources. I would also design for stampedes, hot keys, negative caching, Redis outage fallback, and DB protection so Redis failure does not become a DB outage. I would measure hit/miss rate, hit vs miss latency, fallback-to-DB rate, hot keys, invalidation lag, and stale-read incidents.

## Final Deliverables

After reviewing this note, you should be able to:

- explain cache-aside read path and write invalidation path
- name endpoints that should be cached and endpoints that should not be cached blindly
- compare TTL-only, delete-on-write, refresh-on-write, event invalidation, and versioned keys
- design tenant-safe and auth-safe cache keys
- explain stale-read trade-offs and product correctness boundaries
- handle cache stampede, hot keys, and negative caching
- describe Redis down fallback / degradation / circuit breaker behavior
- distinguish Redis, read replicas, and DB query/index fixes
- debug whether stale data came from cache, replica, or invalidation failure
- handle 10-15 minute deep dives and 30-45 minute design pushback
