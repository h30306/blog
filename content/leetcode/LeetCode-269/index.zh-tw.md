---
title: "LeetCode 269: Alien Dictionary"
summary: "LeetCode 解題筆記：Alien Dictionary"
description: "2026-04-26 的 LeetCode 學習紀錄"
date: 2026-04-26
tags: ["leetcode", "hard", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-26
來源筆記：`notes/day12-week3-day4-dp-speed-l4-l7.md`

## 解題思路

這篇整理 Alien Dictionary 的解題筆記，重點放在 Topological sort on characters、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Topological sort on characters.

## Correct Graph Construction
- initialize all characters as graph nodes
- compare adjacent word pairs only
- use only the first different character
- invalid prefix case:
```text
["abc", "ab"] -> ""
```

## Cycle Detection
Use Kahn's topological sort.

If the result length is smaller than the number of unique characters:
```text
cycle exists -> return ""
```

## Important Implementation Detail
Today’s code using list adjacency is still workable, because duplicate indegree increments are matched by duplicate decrements later.

But interview-cleaner version is:
```text
use set adjacency to avoid parallel-edge bookkeeping
```

That is easier to explain and less fragile.

## Interview-Ready Explanation
I build a directed graph over characters using adjacent word pairs only. For each pair, the first different character gives the ordering edge. If the first word is a strict prefix extension of the second, the order is invalid and I return an empty string. Then I run Kahn's topological sort. If I cannot process all characters, there is a cycle.

## Topic - L4 vs L7 Load Balancer

## Concrete Traffic Path
Use this scenario:
```text
Browser -> Load Balancer -> FastAPI backend
```

Example request:
```text
https://api.hospital.com/patients/123
```

## L4 Load Balancer
An L4 load balancer sees:
```text
IP + port + TCP connection information
```

It does **not** see:
- HTTP path
- headers
- cookies
- method

Choose L4 when:
- need transport-level balancing only
- non-HTTP protocol
- want TLS pass-through / client-to-backend end-to-end TLS
- do not need path or header-based routing

## Interview-Ready L4 Example
If the load balancer only needs to forward traffic to one of several FastAPI backends based on TCP connection information, and we want TLS to remain opaque all the way to the backend, choose L4.

## L7 Load Balancer
An L7 load balancer sees:
```text
HTTP host + path + headers + cookies + method
```

For HTTPS traffic, it must first terminate TLS to inspect the request.

Choose L7 when:
- need host/path/header routing
- centralized certificate management
- WAF / auth / rate limiting
- request-level logging and observability

## Interview-Ready L7 Example
If requests to:
```text
/patients/*
```

should go to one backend but:
```text
/billing/*
```

should go to another, the load balancer must inspect the HTTP path, so choose L7 and terminate TLS there.

## TLS Termination vs TLS Re-Encryption

## TLS Termination
Meaning:
```text
the client's TLS session ends at the load balancer
```

Model:
```text
Browser --TLS--> LB --HTTP--> FastAPI
```

The LB:
- decrypts the request
- inspects HTTP data
- forwards plain HTTP internally

## TLS Re-Encryption
Meaning:
```text
the LB terminates the client TLS session, then creates a second TLS session to the backend
```

Model:
```text
Browser --TLS #1--> LB --TLS #2--> FastAPI
```

This protects the backend leg too, but it is:
```text
not one end-to-end client-to-backend TLS session
```

It is:
```text
two separate TLS sessions
```

## One-Minute Answer

An L4 load balancer works at the transport layer and routes based on IP, port, and TCP connection information. It cannot inspect HTTP path or headers, so it is suitable for simple transport-level balancing or TLS pass-through. An L7 load balancer works at the application layer and can route based on host, path, headers, cookies, or method. For HTTPS traffic, it must terminate TLS first so it can inspect the HTTP request.

TLS termination means the client TLS session ends at the load balancer, for example `Browser --TLS--> LB --HTTP--> FastAPI`. TLS re-encryption means the load balancer terminates client TLS, then starts a second TLS session to the backend, for example `Browser --TLS #1--> LB --TLS #2--> FastAPI`. That protects the backend leg, but it is still not one end-to-end TLS session.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough pattern recognition; implementation detail still needs care.
