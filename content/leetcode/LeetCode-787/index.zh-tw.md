---
title: "LeetCode 787: Cheapest Flights Within K Stops"
summary: "LeetCode 解題筆記：Cheapest Flights Within K Stops"
description: "2026-04-25 的 LeetCode 學習紀錄"
date: 2026-04-25
tags: ["leetcode", "medium", "graph", "bellman-ford", "shortest-path"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
來源筆記：`notes/day11-week3-day3-delete-and-earn-cert-validation.md`

## 解題思路

這篇整理 Cheapest Flights Within K Stops 的解題筆記，重點放在解法判斷、狀態定義與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Current understanding:** Plain Dijkstra with `visited = set(city)` is wrong.

## Why Plain `visited = set(city)` Is Wrong
The state is not only the city.

Reaching the same city with:
```text
lower price but too many stops
```

can be worse than:
```text
higher price but fewer stops used
```

because the second route may leave enough stop budget for a cheaper final path.

So the state must include:
```text
(city, stops_used)
```

or:
```text
(city, edges_used)
```

## Week 3 Decision
Do not force Bellman-Ford learning in a rushed way.

Move full Bellman-Ford intro and full `LC 787` practice to:
```text
Week 3 Weekend Day 2
```

## Topic - Certificate Chain Validation vs Server Private-Key Proof

## The Two Checks Are Different

## 1. Certificate Chain Validation
Purpose:
```text
Check whether the certificate is trusted.
```

The client verifies:
- certificate chain up to a trusted root CA
- hostname matches the requested domain
- certificate is not expired

Correct wording:
```text
CA public keys verify certificate trust.
```

## 2. Server Private-Key Proof
Purpose:
```text
Check whether the server actually owns the private key matching the certificate's public key.
```

The server signs handshake data with its private key.

The client verifies that signature using the server public key from the certificate.

Correct wording:
```text
server public key verifies the server's handshake signature
```

## Mistakes To Avoid
- Do not say the client asks the CA during every handshake.
- Do not say the public key decrypts the signature.
- Do not collapse both checks into one vague sentence like `the certificate is valid`.

## One-Minute Answer

Certificate chain validation checks whether the server certificate is trusted. The client verifies the certificate chain to a trusted root CA, and also checks the hostname and expiry. Server private-key proof is a separate check. It verifies that the server actually owns the private key corresponding to the public key in the certificate. The server signs handshake data with its private key, and the client verifies that signature using the server public key.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Partial repair only; full Bellman-Ford practice deferred.
