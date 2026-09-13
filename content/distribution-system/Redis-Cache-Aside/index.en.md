---
title: "Redis Cache-Aside And Query Fixes"
summary: "When Redis is the right fix, and when it only hides query, index, or schema problems"
description: "Week 8 learning notes: cache-aside, invalidation, stale reads, hot keys, Redis vs DB fixes"
date: 2026-05-28
tags: ["distributed-systems", "redis", "cache-aside", "caching", "database-scaling"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 45: Redis cache-aside, invalidation, stale-read trade-offs
- Day 46: when Redis helps vs when query / index / schema fixes should come first
- Week 10 carry-forward target: cache stampede, hot keys, Redis vs Memcached, when not to cache

## Mental Model

Redis is not:

```text
DB slow -> add cache
```

A safer rule:

```text
cache repeated expensive reads only when stale-data risk and invalidation cost are acceptable.
```

If the root cause is bad query shape, wrong index order, or poor schema shape, Redis only hides the problem. It returns during misses, cold starts, invalidation bugs, and Redis outages.

## Cache-Aside

Read path:

```text
read cache
if miss:
    read database
    write cache with TTL
return data
```

Write path:

```text
write database
delete or refresh cache key
```

The write path matters. If the database is updated but cache is not invalidated, users can read stale data.

## Good Cache Candidates

Better candidates:

- read-heavy data
- expensive query or computation
- stale for a few seconds is acceptable
- stable key shape
- clear invalidation rule

Examples:

- hospital profile / department metadata
- read-mostly reference data
- dashboard summaries with freshness label
- non-critical aggregations

Risky candidates:

- payment state immediately after charge
- appointment booking capacity
- patient record immediately after mutation
- permission or authorization decisions
- rapidly changing personalized state

## Invalidation Strategies

Options:

- TTL only
- refresh cache after DB write
- delete cache key after DB write
- event-driven invalidation
- versioned keys

Trade-offs:

- TTL-only always has a stale window
- delete-on-write can cause miss bursts
- refresh-on-write adds another failure point
- event-driven invalidation can be delayed or dropped
- short TTL reduces staleness but hurts hit rate

## Cache Stampede

If a hot key expires and many requests miss together, all of them can hit the database.

Mitigations:

- single-flight / request coalescing
- short rebuild lock
- TTL jitter
- stale-while-revalidate
- pre-warm critical keys
- rate-limit expensive rebuilds

## Hot Keys

A hot key concentrates traffic on one cached item.

Symptoms:

- very high QPS for one key
- one Redis node has high CPU or network
- p99 latency spikes
- DB overload after key expiry

Mitigations include key replication, local cache for read-only data, request coalescing, natural key splitting, precompute/prewarm, and TTL jitter.

## If Redis Is Down

First decide whether cache is an optimization or a correctness dependency.

If it is an optimization:

- fallback to DB
- rate-limit fallback
- use circuit breaker behavior
- skip cache writes temporarily
- monitor DB pressure

If Redis participates in correctness, be careful. For duplicate payments or orders, Redis should not be the only durable source of truth. Use a durable idempotency record in the database.

## Redis vs Query / Index / Schema Fix

Before adding cache, ask:

1. Is the bottleneck repeated reads or one bad query?
2. Is the query SARGable?
3. Does index order match predicate and ordering?
4. Is projection too wide?
5. Does schema shape force expensive joins or aggregations?
6. Can the endpoint tolerate stale data?
7. Is invalidation clear?

If a single query is inherently bad, cache hits look good but cache misses remain dangerous.

## What To Measure

- cache hit / miss rate
- p95 and p99 latency by hit vs miss
- DB QPS during cache miss
- hot key distribution
- eviction count
- stale-read incidents
- cache rebuild duration
- Redis CPU, memory, network
- fallback-to-DB rate
- invalidation failure count

## 60-90 Second Answer

Redis is a good fit for repeated expensive reads when the endpoint can tolerate a clear stale window and invalidation is well-defined. I would not use it as the first answer to a slow query. If the query is not SARGable, the index order is wrong, projection is too wide, or the schema is fighting the access pattern, cache misses will still hurt the database. In cache-aside, the read path checks cache first and loads from DB on miss; the write path must delete or refresh the cache key after DB commit. I also need to handle stampedes, hot keys, and Redis outage fallback. For payment state, booking capacity, and patient-record reads after mutation, stale cache is usually not a correctness source.
