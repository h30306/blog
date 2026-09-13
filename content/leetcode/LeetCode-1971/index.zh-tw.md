---
title: "LeetCode 1971: Find if Path Exists in Graph"
summary: "LeetCode 解題筆記：Find if Path Exists in Graph"
description: "2026-04-08 的 LeetCode 學習紀錄"
date: 2026-04-08
tags: ["easy", "graph", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-08
來源筆記：`notes/day2-topological-sort-dag-union-find-dns-http.md`

## 解題思路

這篇整理 Find if Path Exists in Graph 的解題筆記，重點放在 BFS/DFS OR Union-Find、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** BFS/DFS OR Union-Find
- **Critical:** This is an **undirected** graph — add both directions when building adjacency list
- **BFS approach:** Standard BFS from source. Return true if destination is reached.
- **Union-Find approach:** Group all connected nodes. Return `find(source) == find(destination)`
- **Common bugs:**
  1. Building directed adjacency list for undirected graph
  2. Applying Kahn's in-degree logic to undirected graph — in-degree is meaningless here
  3. Never calling `union` on edges — nodes stay in separate components
  4. Calling `union(x, y)` with raw nodes instead of roots `union(find(x), find(y))`
  5. Wrong rank increment — only increment when two trees of equal rank merge

- **Union-Find template:**
```python
parent = [i for i in range(n)]
rank = [0] * n

def find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])  # path compression
    return parent[x]

def union(x, y):
    rx, ry = find(x), find(y)
    if rx == ry:
        return
    if rank[rx] > rank[ry]:
        parent[ry] = rx
    elif rank[rx] < rank[ry]:
        parent[rx] = ry
    else:
        parent[rx] = ry
        rank[ry] += 1
```

- **Trade-off:** BFS = simpler, good for single query. Union-Find = better for multiple path queries on same graph (near O(1) per query after O(V+E) build).

## Topic — Networking

## DNS Resolution — 8 Steps
1. Browser cache
2. OS cache / /etc/hosts
3. Recursive Resolver (ISP or 8.8.8.8)
4. Root Server — "who handles .com?"
5. TLD Server — "who handles google.com?"
6. Authoritative Server — returns actual IP
7. Resolver returns IP + caches with TTL
8. Browser connects to IP

## DNS Key Concepts
- **TTL (Time To Live):** How long to cache the DNS result. Stale cache = browser connects to old IP after server migration. Fix: lower TTL before planned IP change. User fix: flush DNS cache.
- **Why UDP:** DNS queries are tiny (<512 bytes). TCP handshake overhead not worth it. Falls back to TCP for large responses.
- **Recursive vs Iterative:** Recursive Resolver does all the work for you — browser makes one request, gets back the final IP.
- **Root Servers:** 13 clusters (A–M), 1500+ physical machines worldwide using Anycast. Only knows which TLD server handles each extension.
- **DNS operates at L7** — uses UDP at L4 as transport (transport ≠ operating layer)

## HTTP/1.1 vs HTTP/2 vs HTTP/3

| | HTTP/1.1 | HTTP/2 | HTTP/3 |
|---|---|---|---|
| Transport | TCP | TCP | UDP (QUIC) |
| Requests | One at a time | Multiplexed (streams) | Multiplexed |
| HOL blocking | Yes — HTTP level | Partial — TCP level | No |
| Header compression | No | Yes (HPACK) | Yes (QPACK) |
| Connection setup | TCP + TLS (2 RTT) | TCP + TLS (2 RTT) | QUIC (1 RTT) |

- **HOL Blocking:** One slow response/packet blocks everything behind it
- **HTTP/1.1 problem:** One request at a time per connection. Browser workaround: 6 parallel TCP connections per domain (still slow — each costs a handshake)
- **HTTP/2 solution:** Multiplexing — breaks requests/responses into frames tagged with stream IDs, interleaved over one TCP connection. Still has TCP-level HOL blocking.
- **HTTP/3 solution:** Replaces TCP with QUIC (over UDP). Each stream is independent — lost packet only blocks its own stream. Also adds connection migration (WiFi → 4G keeps connection).
- **Why HTTP/3 uses UDP:** QUIC reimplements reliability (retransmission, ordering, flow control) per stream on top of UDP, without TCP's connection-wide blocking.
- **QUIC advantage:** Combines transport + TLS 1.3 handshake into 1 RTT (vs TCP + TLS = 2 RTT)
- **In practice:** Browsers only support HTTP/2 and HTTP/3 over HTTPS (TLS enforced)

## Terminology Precision
- TCP operates at L4 → unit is **segment**, not packet
- When a "TCP packet is lost" — technically the **packet** (L3) carrying the **segment** (L4) is lost
- Precise version: "If a packet is lost at L3, TCP at L4 detects the missing segment and triggers retransmission"

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
