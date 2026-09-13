---
title: "LeetCode 1631: Path With Minimum Effort"
summary: "LeetCode 解題筆記：Path With Minimum Effort"
description: "2026-04-25 的 LeetCode 學習紀錄"
date: 2026-04-25
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
來源筆記：`notes/day10-week3-day2-dp-repair-tls-handshake.md`

## 解題思路

這篇整理 Path With Minimum Effort 的解題筆記，重點放在 Dijkstra on a grid with non-sum path cost、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Dijkstra on a grid with non-sum path cost.

## Why Dijkstra Still Works
The path cost is not the sum of edge weights.

Instead:
```text
new_effort = max(current_effort, abs(height_diff))
```

That means the path effort is:
```text
non-decreasing as the path extends
```

not strictly increasing.

That monotonic property is why Dijkstra still works.

## Heap State
```text
(effort, row, col)
```

## Transition
For each neighbor:
```text
new_effort = max(current_effort, abs(heights[r][c] - heights[nr][nc]))
```

## Finalization Rule
```text
when a cell is popped from the min-heap for the first time, its minimum effort is finalized
```

## Complexity
```text
Time: O(R * C * log(R * C))
Space: O(R * C)
```

## Common Mistakes
- Do not say the effort strictly increases.
- Do not say time is just `O(R * C)`; heap operations add a log factor.
- Do not say a public key decrypts a signature in the TLS analogy. That was a separate wording issue from the topic block.

## Topic - TLS Handshake Precision

## Correct Order
After TCP is established:

```text
ClientHello
-> ServerHello + certificate chain + selected parameters + key exchange info
-> client validates certificate chain, hostname, expiry
-> server proves private-key ownership by signing handshake data
-> client verifies that signature with server public key
-> both sides derive symmetric session keys
-> encrypted HTTP traffic begins
```

## ClientHello Must-Know Fields
- supported TLS versions
- cipher suites
- random data
- SNI
- key exchange information

## Server Reply Must-Know Fields
- selected TLS parameters
- server random data
- certificate chain
- key exchange information

## Certificate Validation
The client checks:
- chain to a trusted root CA
- hostname matches requested domain
- certificate is not expired

## Server Private-Key Proof
The server signs handshake data with its private key.

The client:
```text
verifies the signature using the server public key
```

## After Verification
Do not say the random data itself becomes the encryption key.

Correct wording:
```text
client and server derive shared symmetric session keys from the key exchange and handshake values
```

Those symmetric keys are then used for encrypted HTTP traffic.

## Mistakes To Avoid
- Do not say the public key decrypts the signature.
- Do not say the certificate must be signed directly by a root CA.
- Do not say HTTP traffic uses a random-data key directly.

## One-Minute TLS Answer

After TCP is established, the client sends `ClientHello` with supported TLS versions, cipher suites, random data, SNI, and key exchange information. The server replies with selected parameters, its own random data, key exchange information, and its certificate chain. The client validates the certificate chain, hostname, and expiry. Then the server proves it owns the private key matching the certificate by signing handshake data, and the client verifies that signature using the server public key. After that, both sides derive shared symmetric session keys and use them to encrypt HTTP traffic.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough after wording repair.
