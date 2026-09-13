---
title: "Sharding, Hot Shards, And Cross-Shard Pain"
summary: "Shard-key choice as workload design, not just picking a column"
description: "Database scaling review notes for shard-key choice, hot shards, cross-shard queries, and resharding"
date: 2026-05-27
tags: ["database", "database-scaling", "sharding", "hot-shard", "multi-tenant"]
categories: ["database"]
aliases:
  - /distribution-system/sharding-hot-shards/
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Review Points

Sharding questions are not solved by saying:

```text
the table is too big, so split by hospital_id
```

At a Tier A/S interview bar, you need to explain:

- why sharding is needed now instead of a query, index, replica, or cache fix
- whether the dominant routing unit is tenant, hospital, patient, region, or entity id
- how the shard key affects distribution, locality, routing, transactions, and resharding
- how hot tenants and hot shards happen, how to detect them, and how to mitigate them
- which queries become cross-shard fanout
- how global uniqueness, foreign keys, transactions, pagination, and reporting become harder
- how resharding, backfill, cutover, and rollback avoid data correctness incidents
- which metrics expose hot spots that averages hide

The core rule:

```text
Sharding buys write/storage headroom by giving up simple global operations.
The shard key decides which operations stay cheap and which operations become distributed problems.
```

## Tier A/S Readiness

If the answer is only:

```text
I would shard by hospital_id because each hospital has its own data.
```

that is not enough.

A strong answer adds:

- why `hospital_id` matches the main access pattern
- whether one hospital can become 20x hotter than the rest
- how cross-hospital reporting, global search, and multi-shard transactions are handled
- how the routing map, schema boundary, and migration plan work
- whether cheaper fixes like better indexes, read replicas, cache, or pool tuning were ruled out first
- what future resharding costs if the key is wrong

## Sharding Mental Model

Sharding is not:

```text
database slow -> split table
```

A better phrasing:

```text
sharding partitions data and traffic so most hot operations can be routed to one shard,
but any operation that does not match the partitioning rule becomes harder.
```

Sharding can make these cheaper:

- tenant-scoped writes
- tenant-scoped point reads
- per-shard storage growth
- per-shard connection pressure
- per-shard write throughput

It also makes these more expensive:

- global search
- cross-tenant reporting
- cross-shard joins
- global ordering / pagination
- global uniqueness
- multi-shard transactions
- resharding and backfills

So shard-key choice is not picking a nice schema column. It is a workload trade-off.

## When Not To Shard First

Sharding is an expensive operational decision. Ask first:

- is the system slow because one primary is at capacity, or because a few queries are bad?
- are predicates SARGable?
- do composite indexes match filter / sort / projection?
- are response payloads too wide?
- are connection pools misconfigured?
- are write transactions too long or blocked by lock contention?
- can read replicas already handle stale-tolerant reads?
- can Redis handle repeated, stale-tolerant hot reads?
- should reporting leave the OLTP path?

If the root cause is:

```text
one dashboard scans a huge transactional table every few seconds
```

the first fix is usually not sharding. It may be:

- query rewrite
- index fix
- summary table
- materialized aggregation
- reporting replica / warehouse
- cache with explicit freshness semantics

Strong answer:

```text
I shard only after I can explain which bottleneck remains after cheaper fixes.
```

## Shard-Key Decision Framework

Before choosing a shard key, answer five questions.

### 1. What Is The Dominant Routing Unit?

Possible units:

- tenant / hospital
- patient
- appointment
- region
- account
- order
- device

Ask:

```text
Most requests start with which identifier?
```

If most APIs already include `hospital_id` and authorization, filtering, and ownership are hospital-scoped, `hospital_id` is a natural candidate.

If most queries are patient-centric and patients can move across hospitals, the answer may change.

### 2. Which Operations Must Stay Single-Shard?

Try to keep these single-shard:

- critical writes
- common OLTP reads
- authorization-scoped reads
- read-modify-write transactions
- idempotency lookups
- hot user flows

If appointment booking updates appointment, doctor availability, and billing draft under one hospital scope, `hospital_id` keeps that workflow simpler.

### 3. Where Can Skew Appear?

Distribution is not only row count.

Measure:

- tenant size
- write rate
- read QPS
- hot entities
- time-window bursts
- storage growth
- expensive query concentration

A hospital may not have the most rows, but it can still be hot if it has high appointment-write traffic.

### 4. Which Queries Can Tolerate Fanout?

Fanout is not forbidden, but it has a cost.

More acceptable for:

- reporting
- analytics
- offline export
- admin global dashboard
- compliance audit jobs

Usually risky for:

- user-facing request path
- latency-sensitive search
- transaction-critical reads
- high-QPS endpoints

### 5. Can The Resharding Cost Be Paid Later?

Once a shard key is shipped, it enters:

- routing layer
- data model
- indexes
- backup / restore
- monitoring
- deployment
- incident response
- developer mental model

Ask:

```text
If this key fails, how do we split, move, or rebalance data later?
```

## Common Shard-Key Strategies

### Tenant / Hospital Key

```text
shard = hash(hospital_id) % N
```

Pros:

- good tenant locality
- natural authorization boundary
- hospital-scoped queries stay single-shard
- clear data ownership
- easier per-tenant incident debugging

Cons:

- a large tenant can create a hot shard
- cross-tenant reporting becomes fanout
- global search and global uniqueness are harder
- tenant migration or tenant split requires additional machinery

Good fit:

```text
Most OLTP traffic is scoped by hospital_id.
```

### Patient Key

```text
shard = hash(patient_id) % N
```

Pros:

- patient-centric queries are local
- patient-record reads and writes have good locality
- one large hospital's traffic can be spread out

Cons:

- hospital-level dashboards fan out
- hospital-scoped authorization and filters may cross many shards
- appointment capacity and department workflows may be less natural

Good fit:

```text
Most traffic follows patient records rather than tenant boundaries.
```

### Hash Key

```text
shard = hash(entity_id) % N
```

Pros:

- usually better distribution
- avoids placing one tenant entirely on one shard

Cons:

- weak locality
- poor range-query behavior
- tenant-scoped transactions may cross shards
- operational ownership is harder to reason about

Good fit:

```text
High-volume independent entities where distribution matters more than locality.
```

### Hybrid / Large-Tenant Split

Common evolution:

```text
small tenants share pooled shards
large tenants move to dedicated shard
very large tenants split by sub-key
```

Possible sub-keys:

- department
- region
- patient bucket
- appointment date bucket
- hash suffix

Pros:

- keeps small tenants simple
- gives large tenants more headroom
- avoids one tenant crushing a pooled shard

Cons:

- routing logic becomes more complex
- one tenant may span multiple shards
- tenant-local queries can become fanout
- migration and observability need to be more mature

## Hot Shards

A hot shard receives much more load than the others.

Sources:

- one large tenant
- one hot doctor / department / resource
- time-based key sends recent data to one shard
- enterprise customer traffic spike
- reporting queries focused on a few tenants
- write-heavy events concentrated on one owner row

Symptoms:

- one shard has much worse p95 / p99 latency
- connection saturation is shard-specific
- lock waits or write queues cluster on one shard
- CPU, I/O, or cache misses are imbalanced
- average latency looks fine, but one tenant is slow
- retries and timeouts happen only on a few shards

Interview-safe line:

```text
Averages hide hot shards. I need per-shard and per-tenant metrics.
```

## Hot-Shard Mitigation

### 1. Dedicated Shard

Move a large tenant out of the shared pool.

Good fit:

- one large tenant has sustained high traffic
- tenant boundary is clear
- you want to avoid deeper application partitioning at first

Cost:

- capacity planning becomes more specific
- tenant migration must be safe
- the dedicated shard can still become hot later

### 2. Split Tenant

Partition inside the large tenant.

Examples:

```text
hospital_id + department_id
hospital_id + patient_bucket
hospital_id + appointment_month
hospital_id + hash_suffix
```

Good fit:

- one tenant exceeds one shard
- there is a natural sub-domain inside the tenant

Cost:

- tenant-local queries may fan out
- transaction boundaries become more complex
- routing map becomes more complex

### 3. Virtual Shards

Add an indirection layer:

```text
entity -> virtual shard -> physical shard
```

Pros:

- rebalancing is easier than direct physical hashing
- a subset of virtual shards can move

Cons:

- another routing map
- cache, deploy, and consistency management become more involved

### 4. Move Workload, Not Data

Sometimes the shard key is not the real issue. The workload is.

Options:

- move reporting to a warehouse
- use summary tables for dashboards
- cache stale-tolerant hot reads
- queue write bursts
- move expensive search to a search index

These can be cheaper than changing the shard key.

## Cross-Shard Pain

After sharding, any query that does not include the shard key becomes harder.

### Cross-Shard Joins

Before sharding:

```sql
SELECT *
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.hospital_id = :hospital_id;
```

If both `appointments` and `patients` are sharded by `hospital_id`, this can still stay single-shard.

If one table is sharded by hospital and the other by patient, the join may cross shards.

Fixes:

- co-locate related data by the same shard key
- denormalize a read model
- precompute projections
- avoid cross-shard joins on OLTP request paths

### Global Search

Example:

```text
search patient by phone number across all hospitals
```

If the main shard key is `hospital_id`, this may require:

- global secondary index service
- search index
- fanout query with timeout budget
- async search pipeline

Mention partial results and timeout:

```text
fanout means one slow shard can slow the whole request unless the product accepts partial or degraded results.
```

### Global Ordering / Pagination

Example:

```text
show latest appointments across all hospitals
```

Each shard has its own latest rows.

Global order requires:

- query each shard
- merge-sort results
- keep a cursor across shards
- handle new writes during pagination

This is much harder than one database doing `ORDER BY created_at LIMIT 50`.

### Cross-Shard Transactions

If one workflow must update two shards:

- latency increases
- failure modes multiply
- rollback and retry get harder
- distributed transaction vs saga becomes a design choice

Strong answer:

```text
I try to choose a shard key so critical writes stay single-shard.
If a workflow must cross shards, I need explicit compensation, idempotency, and observability.
```

### Global Uniqueness

A single database unique constraint is cheap.

After sharding, global uniqueness may require:

- routing uniqueness ownership to one shard
- central reservation service
- globally generated ids
- compound unique key with tenant id
- async duplicate detection for non-critical cases

Example:

```text
unique per hospital: (hospital_id, external_id) is easy
globally unique email across all hospitals: harder
```

## Routing Layer

A sharded system needs an explicit routing layer.

The router needs:

- shard key
- shard map
- physical shard health
- read/write role
- tenant split status
- migration state
- fallback / circuit breaker policy

Common routing inputs:

- `hospital_id`
- `patient_id`
- resource id
- endpoint policy
- operation type: read/write
- consistency requirement

Common routing outputs:

- target shard
- primary or replica inside the shard
- fanout plan
- reject / pending / degraded response

Important:

```text
If an endpoint cannot identify the shard key early, the design will accidentally fan out.
```

API shape and data model must support the shard key.

## Security / Tenant Boundary

Multi-tenant sharding is not only performance.

Also handle:

- shard key is not authorization proof
- a request-provided `hospital_id` is not automatically trusted
- user access to the tenant must be checked before and after routing
- cross-tenant admin endpoints need stricter audit
- logs and metrics must not leak sensitive tenant data
- migration must avoid tenant data mixing

Interview-safe line:

```text
Shard routing helps locality, but authorization still belongs in the application / policy layer.
```

## Resharding Pain

If the shard key is wrong or a tenant grows too large, resharding becomes necessary.

Common resharding steps:

1. create a new shard or virtual-shard map
2. backfill historical data
3. run dual-read or shadow-read validation
4. dual-write or CDC-sync changes
5. compare counts, checksums, and sampled records
6. cut over the routing map
7. monitor errors and lag
8. rollback or freeze writes if needed
9. clean old data after a confidence window

Risks:

- missed rows during backfill
- dual-write succeeds on one side and fails on the other
- routing-map cache is stale
- reads see different states after cutover
- idempotency keys or external references are not moved consistently
- foreign-key or uniqueness semantics change

Do not say:

```text
we can always reshard later
```

Say:

```text
resharding is a migration project with correctness, routing, and rollback risks.
```

## Failure Matrix

| Failure | Symptom | Root cause | Fix |
|---|---|---|---|
| Hot tenant | one tenant has high p99 | `hospital_id` skew | dedicated shard or tenant split |
| Time hot partition | newest shard melts | monotonic time in key | hash suffix / time-bucket redesign |
| Accidental fanout | one request hits all shards | API lacks shard key | change API shape or add global index |
| Cross-shard transaction | high latency, hard rollback | workflow spans shards | co-locate or use saga / outbox |
| Global search slow | timeout or partial result | shard key does not support lookup | search index / async projection |
| Rebalance incident | inconsistency after cutover | backfill / dual-write bug | checksum, shadow read, rollback plan |
| Averages look fine | a few customers are slow | hot shard hidden by averages | per-shard and per-tenant metrics |
| Primary inside shard overloaded | replicas do not fix writes | write / lock bottleneck | transaction tuning, split hot writer |

## What Breaks At Scale

As the system moves from a few tenants to many tenants:

- tenant size distribution matters more than averages
- one shard can bottleneck before cluster averages look bad
- cross-shard queries quietly grow
- global reporting can slow OLTP shards
- the shard map becomes critical infrastructure
- resharding windows get longer
- deployment, backup, and restore become per-shard operations
- incident response must quickly identify shard, tenant, and endpoint

The important idea:

```text
sharding turns database scaling into an operational system.
```

## What To Log

Each request should record:

- shard key
- resolved shard id
- tenant id
- route decision
- fanout count
- read source: primary / replica
- query shape / endpoint
- latency by shard
- error by shard
- retry count
- migration state / shard map version

Each background job or migration should record:

- source shard
- target shard
- batch id
- copied row count
- checksum / validation result
- dual-write success/failure
- cutover timestamp

## What To Measure

Core metrics:

- per-shard QPS
- per-shard write rate
- per-shard p95 / p99 latency
- per-shard CPU / I/O / storage growth
- per-shard connection pool saturation
- hot tenant distribution
- fanout query count
- fanout width
- cross-shard transaction count
- retry / timeout / partial failure rate
- rebalance duration
- backfill lag
- validation mismatch count

Do not only look at:

```text
average CPU across shards
```

Hot shards usually die outside the average.

## Debugging Playbook

Issue:

```text
Only one hospital is slow after sharding.
```

Debug:

1. Resolve that tenant to its shard.
2. Compare that shard's p95 / p99 to other shards.
3. Inspect that tenant's read/write QPS, storage growth, and hot endpoints.
4. Check whether a request is accidentally fanning out.
5. Check whether slow queries only occur for that tenant.
6. Inspect connection pool, lock wait, and replica lag.
7. Decide whether this is tenant skew, query shape, or write contention.
8. Choose mitigation: dedicated shard, tenant split, index fix, cache, or reporting isolation.

Issue:

```text
Global reporting is slow.
```

Debug:

1. How many shards are involved?
2. Which shard is slowest?
3. Does the product require all-or-nothing results?
4. Can aggregation run asynchronously?
5. Should this move to a warehouse or summary table?
6. Are retries creating a shard storm?

## 10-15 Minute Deep Dive Path

Answer in this order:

1. Do not shard immediately:

```text
I first verify the bottleneck: slow query, index, read load, write throughput, lock contention, or storage.
```

2. If sharding is needed, define the workload:

```text
most OLTP reads/writes are hospital-scoped
critical writes must remain single-shard
cross-hospital reporting can be async
```

3. Choose a shard key:

```text
hospital_id is natural for tenant locality, but I need to handle large-tenant skew.
```

4. Draw routing:

```text
API -> shard router -> shard map -> target shard primary/replica
```

5. Explain hot shards:

```text
one large tenant can overload one shard even if average load is fine
```

6. Explain cross-shard pain:

- reporting
- global search
- global uniqueness
- cross-shard transaction

7. Explain mitigations:

- dedicated shard
- tenant split
- virtual shards
- async reporting
- search index
- cache non-critical reads

8. Explain observability:

- per-shard metrics
- per-tenant skew
- fanout count
- resharding validation

## 30-45 Minute Design Pushback

Prompt:

```text
Scale a hospital backend from 10 to 500 hospitals.
Single primary is hitting limits. How would you shard?
```

Answer structure:

### 1. Clarify Bottleneck

- write CPU?
- storage?
- connection pool saturation?
- lock contention?
- read-heavy query?
- reporting overloading OLTP?

### 2. Choose The First Split

If the main flows are hospital-scoped:

```text
start with hospital_id or tenant_id as the routing key
```

Then immediately add:

```text
I would measure tenant skew before committing to plain tenant sharding.
```

### 3. Keep Critical Writes Single-Shard

Keep these local:

- appointment booking
- patient note update
- billing draft update
- idempotency record for tenant-scoped writes

### 4. Move Global Reads Away From OLTP

For cross-hospital reporting:

- async aggregation
- warehouse
- summary table
- search index
- precomputed projections

Do not make every high-QPS user request fan out to all shards.

### 5. Plan For Skew

Prepare:

- large-tenant dedicated shard
- tenant split by department / patient bucket
- virtual shard map
- migration playbook

### 6. Plan For Resharding

Mention:

- backfill
- dual-write / CDC
- shadow read
- checksum validation
- routing cutover
- rollback

### 7. Operational Controls

- shard map versioning
- per-shard dashboards
- per-tenant rate / latency
- fanout budget
- migration alarms
- circuit breaker for bad shard

## Interview Pushback

1. Why is `hospital_id` a good shard key, and when does it fail?
2. What if one hospital is 20x larger than the others?
3. Which queries become cross-shard first?
4. How would you support global patient search?
5. How do you handle global ordering and pagination?
6. What happens to global uniqueness after sharding?
7. Why not add replicas or Redis instead of sharding?
8. How do you detect hot shards before customers complain?
9. What is your resharding plan?
10. How do you avoid tenant data leakage during routing and migration?

## 60-90 Second Answer

I choose a shard key from workload, not schema convenience. For a hospital backend, if most OLTP reads and writes, authorization boundaries, booking, and billing workflows are scoped by hospital, `hospital_id` is a natural candidate because tenant-scoped requests can route to one shard. But I would immediately check tenant skew: if one hospital is 20x larger, plain `hospital_id` creates a hot shard, so I may need a dedicated shard, tenant split, or virtual shards. After sharding, cross-hospital reporting, global search, global ordering, global uniqueness, and multi-shard transactions become harder, so reporting should usually move to async aggregation or a warehouse, while critical writes stay single-shard. Before sharding, I would rule out query/index/schema fixes, read replicas, and cache. After launch, I would measure per-shard QPS, p95/p99, storage, connection pools, hot tenant distribution, fanout query rate, and resharding validation.

## Final Deliverables

After reviewing this note, you should be able to:

- explain why sharding is not the first scaling reflex
- choose shard keys from workload instead of schema convenience
- compare `hospital_id`, `patient_id`, hash key, and hybrid tenant split
- name hot-shard sources, symptoms, and mitigations
- explain cross-shard joins, global search, pagination, transactions, and uniqueness
- draw API, shard router, shard map, target shard, and primary/replica flow
- separate tenant authorization from shard routing
- propose a resharding / backfill / cutover / rollback plan
- design per-shard, per-tenant, fanout, and migration metrics
- handle pushback on replicas, Redis, 20x tenant skew, and global reporting
