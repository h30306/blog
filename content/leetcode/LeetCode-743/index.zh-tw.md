---
title: "LeetCode 743: Network Delay Time"
summary: "LeetCode 解題筆記：Network Delay Time"
description: "2026-05-01 的 LeetCode 學習紀錄"
date: 2026-05-01
tags: ["leetcode", "medium", "graph", "dijkstra", "shortest-path"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-01
來源筆記：`notes/day16-week4-day2-jump-game-idempotency-grpc.md`

## 解題思路

這篇整理 Network Delay Time 的解題筆記，重點放在 Dijkstra / single-source shortest path、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Dijkstra / single-source shortest path.

## Why Dijkstra Fits
We need:
```text
minimum travel time from one source node k to every other node
```

The graph is:
- directed
- weighted
- non-negative edge costs

That is the standard Dijkstra fit.

## Core Data Structures
- adjacency list
- min-heap of `(time, node)`
- either:
  - shortest-distance table, or
  - finalized / visited set

## Final Answer Meaning
This is not:
```text
the longest arbitrary path from source
```

It is:
```text
the maximum shortest-path arrival time from source to any reachable node
```

So:
- if some node is unreachable -> return `-1`
- else -> return the maximum shortest arrival time

## Complexity
```text
Time: O((E + V) log V)
Space: O(E + V)
```

## Common Mistakes
- using BFS even though edge weights differ
- saying the answer is the "longest path"
- forgetting to skip stale heap entries or revisits

## Interview-Ready Explanation
I run Dijkstra from node `k` to compute the shortest signal arrival time to every node. If I cannot reach all nodes, I return `-1`. Otherwise I return the largest shortest arrival time, because that is when the last node receives the signal.

## Topic - Retry-Safe API Design Deepening

## First Judgment
Saying:
```text
use an idempotency key
```

is still below the Week 4 interview bar.

The stronger bar is:
- what exactly is stored for the key
- how retries are replayed
- how `processing` vs `completed` is handled
- which failures should actually be retried
- how remaining time budget is propagated across hops
- how to trace one request across multiple services

## What A Strong Mid-Level Candidate Must Know
- durable idempotency record shape
- same-key same-payload replay behavior
- same-key different-payload rejection
- why a lock alone is not enough
- which failures are retryable vs not
- request ID vs trace ID
- gRPC deadlines as remaining budget, not fresh timeout per hop
- unary vs streaming choice
- when internal gRPC is better than REST, and when it is the wrong trade-off

## Idempotency-Key Storage And Replay Rules
For:
```http
POST /payments
Idempotency-Key: abc-123
```

the server should store a durable record such as:
- `idempotency_key`
- request fingerprint:
  - method
  - path
  - normalized payload or payload hash
- status:
  - `processing`
  - `completed`
  - optionally `failed` by contract
- saved result:
  - response status code
  - response body, or
  - created resource ID
- timestamps / expiry metadata

Why these fields are needed:
- key identifies one logical operation
- request fingerprint detects same-key different-payload misuse
- status prevents duplicate concurrent execution
- saved result allows replay after timeout ambiguity

## Replay Rules
If the same key arrives again with the same payload:
- `completed` -> return the saved original result
- `processing` -> do not create another payment; return an in-progress answer, often `202 Accepted`

If the same key arrives with a different payload:
- reject it as an error
- common answer: `409 Conflict` by contract

Important nuance:
```text
replay the original response status/body, not always a new 200
```

If the original create returned `201 Created`, a retry after completion should normally replay that original success result.

## Why A Redis Lock Alone Is Not Enough
A lock helps with:
- short-window concurrent duplicate execution
- hot-path coordination

But a lock alone is not enough because:
- it is not durable
- it can expire
- it can be lost on restart or eviction
- it does not tell you whether the original request already succeeded
- it cannot replay the original result after timeout ambiguity

Primary source of truth should be:
```text
the main database
```

Redis can still help as:
```text
an optional accelerator / short-window dedupe helper
```

## Timeout Ambiguity
You must be able to say this clearly:

```text
A timeout is ambiguous. The client only knows it did not receive a response.
It does not know whether the server never processed the request, is still processing it,
or already committed the side effect and only the response was lost.
```

If the DB commit already succeeded and the client retries with the same key:
- do not create another payment
- look up the durable idempotency record
- replay the saved success result

## Retry Matrix By Failure Type
For retry-safe create APIs:

- network timeout before response:
  - usually retry with the same idempotency key
  - reason: timeout is ambiguous
- `422 Unprocessable Content`:
  - do not blindly retry unchanged payload
  - reason: semantic validation will fail again
- `401 Unauthorized`:
  - do not blindly retry unchanged request
  - fix credentials first
- `403 Forbidden`:
  - do not blindly retry
  - permission must change
- `429 Too Many Requests`:
  - often retryable, but only with backoff / `Retry-After`
- `503 Service Unavailable`:
  - often retryable if the operation is retry-safe and backoff is bounded

Interview point:
```text
retryable does not mean spam retries immediately
```

## Request ID Vs Trace ID
`request_id`:
- identifies one concrete request handling context
- often useful for one service's local logs and support debugging
- may change across internal hops

`trace_id`:
- identifies the full end-to-end distributed workflow
- should stay the same across gateway -> app -> downstream service hops

Good spoken explanation:
```text
request_id is usually local request correlation; trace_id is end-to-end distributed correlation
```

## gRPC Deadlines
A gRPC deadline is:
```text
the maximum time budget for that RPC
```

Why it matters:
- prevents indefinite downstream hangs
- bounds latency
- reduces wasted work after the caller has already given up
- helps prevent cascading failure

Important correction:
```text
do not reset a fresh full timeout at every hop
```

Use:
```text
remaining end-to-end budget
```

Example:
- total request budget = `5s`
- service already spent `1.8s`
- downstream call should get about `3.2s`, not a fresh `5s`

If the remaining budget is too small for a downstream call that usually takes much longer:
- fail fast
- return degraded behavior
- or switch to async if the business flow allows

## gRPC Deadline Propagation Vs HTTP
This is not only a gRPC idea.

With gRPC:
- deadlines are a first-class RPC concept
- libraries support deadline enforcement more naturally

With HTTP between services:
- the same end-to-end budget idea still applies
- you must propagate remaining budget explicitly, often via a header

Safer HTTP pattern:
```text
absolute deadline timestamp, not only "remaining milliseconds"
```

## Unary Vs Streaming
`unary`:
- one request
- one response

`streaming`:
- one or both sides send multiple messages over one RPC

Common streaming shapes:
- server streaming
- client streaming
- bidirectional streaming

Choose unary when:
- the interaction is naturally one request and one response
- simplicity, retries, and observability matter more than a long-lived message flow

Choose streaming when:
- the workflow naturally involves multiple messages
- chunk upload, live updates, or bidirectional exchange fits better than repeated unary calls

## gRPC Vs REST
Prefer REST more often when:
- the API is public
- browser compatibility matters
- external partner integration matters
- HTTP/JSON tooling and low-friction debugging matter

Prefer internal gRPC more often when:
- service-to-service traffic is high
- you control both sides
- strong contracts and generated clients help
- lower-overhead internal RPC matters

gRPC can still be the wrong internal choice when:
- simplicity matters more than efficiency
- teams rely heavily on generic HTTP tooling
- traffic is modest and the extra protobuf / tooling overhead is not worth it

## What To Log Or Measure
For this topic, a strong production answer should mention:
- duplicate-key mismatch count
- replay count for completed idempotency keys
- count of retries hitting `processing`
- `429` / `503` retry rate
- `DEADLINE_EXCEEDED` rate
- trace coverage across service hops

## Interview Drill Prompts
1. What fields do you store for an idempotency key, and why?
2. Same key + same payload + `completed`: what do you return?
3. Same key + different payload: what do you return, and why?
4. Why is a Redis lock alone not enough?
5. Which failures should the client retry, and which should it not retry blindly?
6. What is the difference between `request_id` and `trace_id`?
7. Why should deadline budget propagate across hops instead of resetting?
8. When is streaming better than unary?
9. When is internal gRPC better than REST, and when is it the wrong choice?

## Today’s Deliverable
By the end of W4D2, you should be able to do all 3:
1. explain the greedy invariant for `Jump Game` and `Jump Game II`
2. explain idempotency replay behavior for `processing` vs `completed`
3. explain why deadline propagation uses remaining time budget instead of resetting per hop

## Main Topic Mistakes Today
1. Deadline budget was first treated like a fresh timeout per service hop instead of a remaining end-to-end budget.
2. `request_id` vs `trace_id` started too vague and needed clearer distributed-tracing wording.
3. Idempotency storage was initially too focused on lock-based dedupe instead of durable replay state.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough no-hints recall.
