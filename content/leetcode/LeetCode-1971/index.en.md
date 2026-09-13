---
title: "LeetCode 1971: Find if Path Exists in Graph"
summary: "LeetCode Problem Solving - BFS/DFS OR UnionFind Critical: This is an undirected graph — add both directions when building adjacency list BFS approach: Standard BFS from source. Return true if destination is reached. UnionFind approach: Gr"
description: "LeetCode study note from 2026-04-08"
date: 2026-04-08
tags: ["leetcode", "easy", "graph", "union-find"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-08
Source Note: `notes/day2-topological-sort-dag-union-find-dns-http.md`

## Intuition

Pattern: BFS/DFS OR UnionFind Critical: This is an undirected graph — add both directions when building adjacency list BFS approach: Standard BFS from source. Return true if destination is reached. UnionFind approach: Gr

Pattern: BFS/DFS OR Union-Find

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
