---
title: "Sharding, Hot Shards, And Cross-Shard Pain"
summary: "Shard-key choice as workload design, not just picking a column"
description: "Week 8 learning notes: shard key choice, hot shards, cross-shard queries, resharding"
date: 2026-05-27
tags: ["distributed-systems", "database-scaling", "sharding", "hot-shard", "multi-tenant"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Learning Note Sources

- Day 44: shard key choice, hot tenant / hot shard, cross-shard read and transaction pain
- Week 8 target: compare schema/index fixes vs cache vs replication vs sharding

## Mental Model

Sharding is not simply:

```text
table too big, split it
```

It is:

```text
choose a partitioning rule that matches the dominant access pattern,
then accept which operations become harder after the split.
```

A bad shard key creates harder debugging, hot spots, cross-shard operations, and painful resharding.

## When Not To Shard First

Before sharding, check:

- whether predicates are SARGable
- whether indexes are missing or ordered badly
- whether full scans come from broad predicates
- whether response payloads are too wide
- whether connection pools are misconfigured
- whether the primary is truly capacity-limited
- whether replicas or cache are enough

If the root cause is bad query or index design, sharding only distributes the bad access pattern.

## Shard-Key Trade-Off

For a hospital DAL, the obvious key is:

```text
hospital_id
```

Pros:

- clear tenant isolation
- hospital-scoped queries stay single-shard
- auth boundaries and routing are natural
- operational ownership is understandable

Cons:

- large hospitals may become hot shards
- cross-hospital reporting becomes fanout aggregation
- skewed hospital sizes cause imbalance
- resharding later is painful

Hash sharding gives more even distribution, but hurts tenant locality and range-style operations. A hybrid model can keep tenant-aware routing while splitting very large tenants into logical partitions.

## Hot Shards

A hot shard can come from data size or traffic skew:

- one large hospital
- one hot doctor or department
- current-time appointment traffic
- write-heavy events concentrated on one logical key

Symptoms:

- one shard has much worse p99 latency
- connection saturation is shard-specific
- lock waits or write queues cluster on one shard
- CPU, IO, or cache misses are imbalanced

## Cross-Shard Pain

Sharding makes these operations more expensive:

- joins
- global search
- global ordering and pagination
- cross-shard transactions
- reporting aggregation
- global uniqueness
- foreign-key enforcement across shards

Example:

```text
get appointments by status across all hospitals last month
```

If data is sharded by `hospital_id`, the query fans out to many shards and merges results. That adds latency, partial failure behavior, and retry complexity.

## Resharding Pain

Shard keys affect routing, storage, backup, monitoring, migration, and deployment.

Resharding may require:

- dual-write or change data capture
- backfill
- routing-table migration
- consistency validation
- cutover and rollback
- old and new key coexistence

Do not say "we can reshard later" without explaining the migration plan.

## Mitigations

Possible hot-shard mitigations:

- split a large tenant
- move a hot tenant to a dedicated shard
- use virtual shards
- isolate reporting workloads
- cache read-heavy non-critical data
- batch or queue write bursts
- redesign schema to remove a hot owner row

Each mitigation has cost and operational complexity.

## What To Measure

- per-shard QPS, p95, p99
- per-shard CPU, IO, storage
- per-shard connection pool saturation
- hot tenant / hot key distribution
- cross-shard query count
- fanout width
- partial failure and retry rate
- resharding/backfill validation mismatch

## 60-90 Second Answer

I choose a shard key from workload shape, not from schema convenience. In a hospital DAL, `hospital_id` is a natural candidate because most queries and authorization boundaries are hospital-scoped, so many reads stay single-shard. The risks are hot large hospitals, cross-hospital reporting, cross-shard transactions, and resharding pain. Before sharding, I would verify query/index/schema quality and whether replicas or cache already solve the bottleneck. If sharding is needed, I would monitor per-shard latency, QPS, storage, hot-tenant distribution, and fanout queries, then prepare strategies like large-tenant split or dedicated shards.
