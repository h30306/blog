---
title: "Sharding, Hot Shards, And Cross-Shard Pain"
summary: "Shard key 不是選一個欄位而已，而是承擔 workload、skew、routing 和 transaction trade-off"
description: "Shard key choice、hot shard、cross-shard query、resharding 的資料庫擴展複習筆記"
date: 2026-05-27
tags: ["database", "database-scaling", "sharding", "hot-shard", "multi-tenant"]
categories: ["database"]
aliases:
  - /zh-tw/distribution-system/sharding-hot-shards/
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 複習重點

Sharding 題目不能只回答：

```text
table too big, split by hospital_id
```

Tier A/S 強度要能回答：

- 為什麼現在真的需要 sharding，而不是先修 query / index / replica / cache
- dominant routing unit 是 tenant、hospital、patient、region，還是 entity id
- shard key 如何同時影響 distribution、locality、routing、transaction 和 resharding
- hot tenant / hot shard 怎麼發生、怎麼偵測、怎麼緩解
- 哪些 query 會變成 cross-shard fanout
- global uniqueness、foreign key、transaction、pagination、reporting 會怎麼變難
- resharding / backfill / cutover 要怎麼設計才不會炸資料一致性
- production 要量哪些 metrics 才知道瓶頸不是平均值掩蓋的 hot spot

一句話：

```text
Sharding buys write/storage headroom by giving up simple global operations.
The shard key decides which operations stay cheap and which operations become distributed problems.
```

## Tier A/S 判斷

如果答案只有：

```text
I would shard by hospital_id because each hospital has its own data.
```

這還不夠。

強回答需要補上：

- `hospital_id` 為什麼符合主要 access pattern
- 一個大 hospital 20x 流量時會不會變 hot shard
- cross-hospital reporting、global search、multi-shard transaction 怎麼處理
- routing map、schema boundary、migration plan 怎麼設計
- sharding 前是否已經排除 bad index、slow query、read replica、cache、connection pool 等更便宜的解法
- 如果 shard key 選錯，未來 resharding 成本是什麼

## Sharding 的心智模型

Sharding 不是：

```text
database slow -> split table
```

比較好的說法：

```text
sharding partitions data and traffic so most hot operations can be routed to one shard,
but any operation that does not match the partitioning rule becomes harder.
```

Sharding 會讓一些事情變便宜：

- tenant-scoped writes
- tenant-scoped point reads
- per-shard storage growth
- per-shard connection pressure
- per-shard write throughput

也會讓一些事情變貴：

- global search
- cross-tenant reporting
- cross-shard joins
- global ordering / pagination
- global uniqueness
- multi-shard transactions
- resharding and backfills

所以 shard key 不是 schema 欄位選美，是 workload trade-off。

## 什麼時候不該先 Shard

Sharding 是昂貴的 operational decision。面試裡先問：

- 慢是因為 single primary 容量，還是某些 query 本來就爛？
- predicate 是否 SARGable？
- composite index 是否符合 filter / sort / projection？
- response payload 是否過寬？
- connection pool 是否設定錯？
- write transaction 是否太長或 lock contention 太高？
- read replicas 是否已經足夠分擔 stale-tolerant reads？
- Redis 是否可以處理 read-heavy、stale-tolerant、重複查詢？
- reporting 是否應該離開 OLTP path？

如果 root cause 是：

```text
one dashboard scans a huge transactional table every few seconds
```

那第一步通常不是 sharding，而是：

- query rewrite
- index fix
- summary table
- materialized aggregation
- reporting replica / warehouse
- cache with clear freshness semantics

強回答：

```text
I shard only after I can explain which bottleneck remains after cheaper fixes.
```

## Shard Key Decision Framework

選 shard key 前，先回答五個問題。

### 1. Dominant Routing Unit 是什麼？

可能是：

- tenant / hospital
- patient
- appointment
- region
- account
- order
- device

你要問：

```text
Most requests start with which identifier?
```

如果大多數 API 都有 `hospital_id` 並且權限、資料查詢都以 hospital 為邊界，`hospital_id` 就是自然候選。

如果大多數查詢是 patient-centric，而 patient 可能跨 hospital，就要重新思考。

### 2. 哪些操作必須保持 Single-Shard？

優先讓這些操作 single-shard：

- critical writes
- common OLTP reads
- authorization-scoped reads
- read-modify-write transaction
- idempotency lookup
- hot user flow

如果 appointment booking 需要同時改 appointment、doctor availability、billing draft，而這些都以 hospital 為 scope，`hospital_id` 可以讓 transaction 比較簡單。

### 3. Skew 會在哪裡？

分布平均不是看 row count 而已。

要看：

- tenant size
- write rate
- read QPS
- hot entity
- time-window burst
- storage growth
- expensive query concentration

一個 hospital 資料量不大，但一天有大量 appointment writes，也可能是 hot shard。

### 4. 哪些 Query 可以接受 Fanout？

Fanout query 不是不能做，但要知道成本。

比較可能接受 fanout 或 async：

- reporting
- analytics
- offline export
- admin global dashboard
- compliance audit jobs

不適合 fanout 的通常是：

- user-facing request path
- latency-sensitive search
- transaction-critical read
- high-QPS endpoint

### 5. Resharding 成本能否承受？

Shard key 一旦上線，會進入：

- routing layer
- data model
- indexes
- backup / restore
- monitoring
- deployment
- incident response
- developer mental model

所以要問：

```text
If this key fails, how do we split, move, or rebalance data later?
```

## 常見 Shard Key 方案

### Tenant / Hospital Key

```text
shard = hash(hospital_id) % N
```

優點：

- tenant locality 好
- auth boundary 自然
- 大多數 hospital-scoped queries 可以單 shard
- data ownership 清楚
- per-tenant incident/debug 比較直覺

缺點：

- 大 tenant 會造成 hot shard
- cross-tenant reporting 變 fanout
- global search / global uniqueness 變難
- tenant migration / split 需要額外機制

適合：

```text
Most OLTP traffic is scoped by hospital_id.
```

### Patient Key

```text
shard = hash(patient_id) % N
```

優點：

- patient-centric query 可以單 shard
- patient record 的寫入和讀取 locality 好
- 單一大 hospital 的流量可能被分散

缺點：

- hospital-level dashboard 會 fanout
- hospital-scoped auth/filter 可能跨很多 shards
- appointment capacity / department workflow 不一定自然

適合：

```text
Most traffic follows patient records rather than tenant boundaries.
```

### Hash Key

```text
shard = hash(entity_id) % N
```

優點：

- distribution 通常比較平均
- 避免單一 tenant 全部打同一 shard

缺點：

- locality 差
- range query 差
- tenant-scoped transaction 可能跨 shards
- operational/debug ownership 不直覺

適合：

```text
High-volume independent entities where locality is less important than distribution.
```

### Hybrid / Large-Tenant Split

常見演進：

```text
small tenants share pooled shards
large tenants move to dedicated shard
very large tenants split by sub-key
```

子 key 可以是：

- department
- region
- patient bucket
- appointment date bucket
- hash suffix

優點：

- 保留小 tenant 的 simplicity
- 對大 tenant 給更多 headroom
- 避免一個 tenant 壓垮 pooled shard

缺點：

- routing logic 變複雜
- tenant 可能有多個 shard
- cross-bucket query 增加
- migration 和 observability 需要更完整

## Hot Shard

Hot shard 是某一個 shard 承受遠高於平均的負載。

來源可能是：

- 一個大 tenant
- 一個 hot doctor / department / resource
- time-based key 讓最新資料都進同一 shard
- celebrity / enterprise customer spike
- reporting query 集中掃某些 tenant
- write-heavy event 集中打同一 owner row

常見症狀：

- 某一 shard p95 / p99 明顯高
- 某一 shard connection pool 滿
- lock wait / write queue 集中
- CPU / IO / cache miss 不平均
- average latency 看起來 OK，但某 tenant 很慢
- retry / timeout 只發生在少數 shards

面試安全句：

```text
Averages hide hot shards. I need per-shard and per-tenant metrics.
```

## Hot Shard Mitigation

### 1. Dedicated Shard

把大 tenant 從 shared pool 搬出去。

適合：

- 大 tenant 長期穩定高流量
- tenant boundary 很清楚
- 不想改 application-level partitioning 太多

代價：

- capacity planning 要更細
- tenant migration 要安全
- dedicated shard 也可能再次變熱

### 2. Split Tenant

大 tenant 內再切。

例如：

```text
hospital_id + department_id
hospital_id + patient_bucket
hospital_id + appointment_month
hospital_id + hash_suffix
```

適合：

- 單 tenant 已經超過單 shard
- tenant 內部有自然 sub-domain

代價：

- tenant-local query 可能變 fanout
- transaction boundary 變複雜
- routing map 更複雜

### 3. Virtual Shards

用 virtual shard / logical partition 做間接層：

```text
entity -> virtual shard -> physical shard
```

優點：

- rebalancing 比直接 hash 到 physical shard 更容易
- 可以搬一部分 virtual shards

缺點：

- 多一層 routing map
- cache / deploy / consistency 要管理

### 4. Move Workload, Not Data

有時候 hot shard 不是 key 選錯，而是 workload 放錯地方。

可做：

- reporting 移到 warehouse
- dashboard 用 summary table
- read-heavy stale-tolerant path 用 cache
- write burst 進 queue
- expensive search 用 search index

這些可能比重切 shard key 便宜。

## Cross-Shard Pain

Sharding 後，凡是不帶 shard key 的 query 都開始變麻煩。

### Cross-Shard Join

原本：

```sql
SELECT *
FROM appointments a
JOIN patients p ON a.patient_id = p.id
WHERE a.hospital_id = :hospital_id;
```

如果 `appointments` 和 `patients` 都用同一個 `hospital_id` shard，這還可以單 shard。

但如果一個按 hospital shard、一個按 patient shard，join 可能跨 shards。

解法：

- co-locate related data by same shard key
- denormalize read model
- precompute projection
- avoid cross-shard join in OLTP request path

### Global Search

例如：

```text
search patient by phone number across all hospitals
```

如果主 shard key 是 `hospital_id`，這可能需要：

- global secondary index service
- search index
- fanout query with timeout budget
- async search pipeline

面試要講 partial result / timeout：

```text
fanout means one slow shard can slow the whole request unless the product accepts partial or degraded results.
```

### Global Ordering / Pagination

例如：

```text
show latest appointments across all hospitals
```

每個 shard 都有自己的 latest rows。

要做 global order，需要：

- query each shard
- merge sort results
- handle cursor across shards
- avoid unstable pagination when new writes arrive

這比單 DB `ORDER BY created_at LIMIT 50` 難很多。

### Cross-Shard Transaction

如果一個 workflow 要同時更新兩個 shards：

- latency 變高
- failure modes 變多
- rollback / retry 變難
- distributed transaction 或 saga 取捨變成設計題

強回答：

```text
I try to choose a shard key so critical writes stay single-shard.
If a workflow must cross shards, I need explicit compensation, idempotency, and observability.
```

### Global Uniqueness

單 DB 的 unique constraint 很便宜。

Sharding 後 global uniqueness 可能需要：

- route uniqueness owner to one shard
- central reservation service
- globally generated ids
- compound unique key with tenant id
- async duplicate detection for non-critical cases

例如：

```text
unique per hospital: (hospital_id, external_id) is easy
globally unique email across all hospitals: harder
```

## Routing Layer

Sharded system 需要明確 routing layer。

Router 需要知道：

- shard key
- shard map
- physical shard health
- read/write role
- tenant split status
- migration state
- fallback / circuit breaker policy

Routing 常見輸入：

- `hospital_id`
- `patient_id`
- resource id
- endpoint policy
- operation type: read/write
- consistency requirement

Routing 常見輸出：

- target shard
- primary or replica inside shard
- fanout plan
- reject / pending / degraded response

注意：

```text
If an endpoint cannot identify the shard key early, the design will accidentally fan out.
```

所以 API shape 和 data model 也要配合 shard key。

## Security / Tenant Boundary

Multi-tenant sharding 不能只講 performance。

也要注意：

- shard key 不等於 authorization proof
- request 裡帶 `hospital_id` 不能直接信任
- routing 前後都要檢查 user 是否有 tenant access
- cross-tenant admin endpoint 要更嚴格 audit
- logs / metrics 不要洩漏 sensitive tenant data
- data migration 時要避免 tenant data mix-up

面試可以說：

```text
Shard routing helps locality, but authorization still belongs in the application / policy layer.
```

## Resharding Pain

Shard key 選錯或某些 tenant 成長太大，就會需要 reshard。

Resharding 常見步驟：

1. 建新 shard 或新 virtual shard map
2. backfill historical data
3. dual-read 或 shadow-read validation
4. dual-write 或 CDC sync changes
5. compare counts / checksums / sampled records
6. cut over routing map
7. monitor errors and lag
8. rollback 或 freeze writes if needed
9. clean old data after confidence window

風險：

- backfill 漏資料
- dual-write 一邊成功一邊失敗
- routing map cache stale
- cutover 後讀到兩份不同狀態
- idempotency key / external reference 沒跟著搬
- foreign key / unique constraint 語意改變

強回答不要說：

```text
we can always reshard later
```

要說：

```text
resharding is a migration project with correctness, routing, and rollback risks.
```

## Failure Matrix

| Failure | 現象 | 根因 | 修法 |
|---|---|---|---|
| Hot tenant | 某 tenant p99 很高 | `hospital_id` skew | dedicated shard 或 tenant split |
| Time hot partition | 最新資料 shard 爆掉 | key 包含 monotonic time | hash suffix / time bucket redesign |
| Accidental fanout | 一個 request 打所有 shards | API 沒有 shard key | 改 API shape 或加 global index |
| Cross-shard transaction | latency 高、rollback 難 | workflow 橫跨 shards | 重新 co-locate 或 saga / outbox |
| Global search slow | search timeout / partial result | shard key 不支援 global lookup | search index / async projection |
| Rebalance incident | cutover 後資料不一致 | backfill/dual-write bug | checksum、shadow read、rollback plan |
| Average metrics look fine | 少數客戶很慢 | hot shard 被平均掩蓋 | per-shard/per-tenant metrics |
| Primary inside shard overloaded | replicas 沒解寫入瓶頸 | write / lock bottleneck | transaction tuning、split hot writer |

## What Breaks At Scale

當規模從少數 tenants 到大量 tenants：

- tenant size distribution 會比平均值重要
- one shard becomes bottleneck before cluster average looks bad
- cross-shard query 數量會慢慢長出來
- global reporting 會把 OLTP shards 拖慢
- routing map 會變成 critical infrastructure
- resharding window 會越來越長
- deployment / backup / restore 變成 per-shard 操作
- incident response 要能快速知道是哪個 shard、哪個 tenant、哪個 endpoint

這題的重點是：

```text
sharding turns database scaling into an operational system.
```

## What To Log

每個 request 最好記：

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

每個 background job / migration 最好記：

- source shard
- target shard
- batch id
- copied row count
- checksum / validation result
- dual-write success/failure
- cutover timestamp

## What To Measure

核心 metrics：

- per-shard QPS
- per-shard write rate
- per-shard p95 / p99 latency
- per-shard CPU / IO / storage growth
- per-shard connection pool saturation
- hot tenant distribution
- fanout query count
- fanout width
- cross-shard transaction count
- retry / timeout / partial failure rate
- rebalance duration
- backfill lag
- validation mismatch count

不要只看：

```text
average CPU across shards
```

因為 hot shard 通常死在平均值之外。

## Debugging Playbook

問題：

```text
Only one hospital is slow after sharding.
```

排查：

1. 找出 tenant 對應 shard。
2. 比較該 shard 和其他 shards 的 p95 / p99。
3. 看該 tenant 的 read/write QPS、storage growth、hot endpoints。
4. 檢查是否 accidental fanout。
5. 檢查 slow queries 是否只有該 tenant 觸發。
6. 看 connection pool、lock wait、replica lag。
7. 判斷是 tenant skew、query shape、還是 write contention。
8. 選 mitigation：dedicated shard、tenant split、index fix、cache、reporting isolation。

問題：

```text
Global report becomes slow.
```

排查：

1. fanout 到多少 shards？
2. 最慢 shard 是誰？
3. 是否需要 all-or-nothing result？
4. 是否可以 async aggregation？
5. 是否應該移到 warehouse / summary table？
6. retry 是否造成 shard storm？

## 10-15 分鐘 Deep Dive 路線

可以這樣回答：

1. 先說不會直接 shard：

```text
I first verify the bottleneck: slow query, index, read load, write throughput, lock contention, or storage.
```

2. 如果真的需要 shard，先定義 workload：

```text
most OLTP reads/writes are hospital-scoped
critical writes must remain single-shard
cross-hospital reporting can be async
```

3. 選 shard key：

```text
hospital_id is natural for tenant locality, but I need to handle large-tenant skew.
```

4. 畫 routing：

```text
API -> shard router -> shard map -> target shard primary/replica
```

5. 講 hot shard：

```text
one large tenant can overload one shard even if average load is fine
```

6. 講 cross-shard pain：

- reporting
- global search
- global uniqueness
- cross-shard transaction

7. 講 mitigation：

- dedicated shard
- tenant split
- virtual shards
- async reporting
- search index
- cache non-critical reads

8. 講 observability：

- per-shard metrics
- per-tenant skew
- fanout count
- resharding validation

## 30-45 分鐘設計追問

Prompt：

```text
Scale a hospital backend from 10 to 500 hospitals.
Single primary is hitting limits. How would you shard?
```

回答架構：

### 1. Clarify Bottleneck

- 是 write CPU？
- storage 太大？
- connection pool 滿？
- lock contention？
- read-heavy query？
- reporting 壓垮 OLTP？

### 2. Choose First Split

如果主要 flow 都是 hospital-scoped：

```text
start with hospital_id or tenant_id as the routing key
```

但立刻補：

```text
I would measure tenant skew before committing to plain tenant sharding.
```

### 3. Keep Critical Writes Single-Shard

讓這些留在同 shard：

- appointment booking
- patient note update
- billing draft update
- idempotency record for tenant-scoped write

### 4. Move Global Reads Away From OLTP

對於 cross-hospital reporting：

- async aggregation
- warehouse
- summary table
- search index
- precomputed projections

不要讓 high-QPS user request 每次 fan out all shards。

### 5. Plan For Skew

準備：

- large tenant dedicated shard
- tenant split by department / patient bucket
- virtual shard map
- migration playbook

### 6. Plan For Resharding

要講：

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

## 60-90 秒回答

Shard key 要從 workload 選，不是從 schema 直覺選。以 hospital backend 來說，如果多數 OLTP read/write、權限邊界、booking 和 billing workflow 都以 hospital 為 scope，`hospital_id` 是自然候選，因為它讓 tenant-scoped request 可以直接 route 到單一 shard。但我會立刻檢查 tenant skew：如果一個 hospital 20x 大，plain `hospital_id` 會產生 hot shard，可能需要 dedicated shard、tenant split、或 virtual shard。Sharding 後 cross-hospital reporting、global search、global ordering、global uniqueness、multi-shard transaction 都會變難，所以 reporting 應該走 async aggregation / warehouse，critical writes 盡量保持 single-shard。Sharding 前我也會排除 query/index/schema、read replica、cache 是否已足夠。上線後我會量 per-shard QPS、p95/p99、storage、connection pool、hot tenant distribution、fanout query rate 和 resharding validation。

## 最後要能交付

讀完這篇，要能做到：

- 說清楚為什麼 sharding 不是第一個 scaling reflex
- 從 workload 選 shard key，而不是只從 schema 欄位選
- 比較 `hospital_id`、`patient_id`、hash key、hybrid tenant split
- 說出 hot shard 的來源、症狀和 mitigation
- 解釋 cross-shard join、global search、pagination、transaction、uniqueness 的痛點
- 畫出 API、shard router、shard map、target shard、primary/replica 的 flow
- 說明 tenant authorization 和 shard routing 的邊界
- 提出 resharding / backfill / cutover / rollback plan
- 設計 per-shard / per-tenant / fanout / migration metrics
- 扛住「為什麼不 replica / Redis」、「一個 tenant 20x 怎麼辦」、「global report 怎麼辦」的追問
