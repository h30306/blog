---
title: "Replication Lag And Replica Routing"
summary: "Read replicas as a freshness and routing problem, not just read scaling"
description: "Distributed systems review notes for primary/replica, replication lag, and read-after-write consistency"
date: 2026-05-26
tags: ["distributed-systems", "database-scaling", "replication", "read-replica", "consistency"]
categories: ["distribution-system"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

- Primary / replica model and async replication
- Replication lag and read-after-write inconsistency
- Endpoint-level freshness classification
- Post-write primary pinning and replica catch-up checks
- Why replicas do not fix bad query/index/schema design
- What to measure when scaling a hospital DAL read path

## Mental Model

Read replicas are not simply:

```text
reads are slow, add replicas
```

They increase read capacity, but they introduce freshness choices. If a write commits on the primary and a following read goes to a lagging replica, the user may not see their own update.

## Product Bug

Example:

```text
POST /appointments/123/confirm -> primary commit success
GET /appointments/123 -> routed to lagging replica
```

The UI may show the appointment as unconfirmed even though the write succeeded. That can cause duplicate actions, support confusion, and incorrect downstream decisions.

## Classify Endpoints By Freshness

Primary-consistent reads:

- payment result after charge
- appointment booking confirmation
- patient record immediately after update
- admin flows that depend on the just-written state

Replica-tolerant reads:

- public lookup pages
- dashboards with freshness labels
- historical logs
- non-critical list pages

Mixed policy:

- default list reads can use replicas
- immediately-after-write reads are pinned to primary
- if lag exceeds a threshold, fallback to primary or degrade

## Read-After-Write Routing

Common strategy:

```text
after a write, pin this user/session/resource reads to primary for N seconds
```

Another strategy is a freshness marker:

```text
client observed write version/timestamp -> read requires replica caught up to that marker
```

If the replica cannot prove it is caught up, route to primary, return retry-after, or show clearly labeled stale data depending on endpoint correctness needs.

## What Replicas Do Not Fix

Replicas do not fix:

- bad query shape
- missing or wrong indexes
- low-selectivity scans
- primary write bottlenecks
- writer connection pool pressure
- transactional contention
- over-wide response payloads

If a query performs a full scan on a large table, adding replicas may only duplicate the bad access pattern.

## What Breaks At Scale

When hospitals, tenants, or traffic multiply:

- replica lag can increase
- read and write pools need separate monitoring
- hot tenants may overload specific replicas
- reporting queries can slow replica catch-up
- failover changes routing assumptions
- stale reads become user-visible correctness bugs

## What To Measure

- replica lag in seconds, bytes, or log sequence distance
- read-after-write fallback count
- consistency mismatch reports
- primary vs replica QPS
- primary write latency
- replica query latency
- connection pool saturation by role
- slow queries on replicas
- failover events and routing errors

## 60-90 Second Answer

Read replicas add read capacity, but they create freshness trade-offs. If a write commits on the primary and the next read goes to a lagging replica, the user may not see their own update. I would classify endpoints by freshness: booking confirmation, payment results, and patient-record reads after update should stay primary-consistent, while reporting and non-critical lists can tolerate replica reads with clear freshness policy. After a write, I can pin reads to primary for a short window or require the replica to catch up to an observed version. Replicas also do not fix bad query/index/schema design, so I would validate access paths before treating replication as the main fix.
