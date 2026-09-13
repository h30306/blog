---
title: "LeetCode 210: Course Schedule II"
summary: "LeetCode 解題筆記：Course Schedule II"
description: "2026-04-08 的 LeetCode 學習紀錄"
date: 2026-04-08
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-08
來源筆記：`notes/day1-topological-sort-osi-model.md`

## 解題思路

這篇整理 Course Schedule II 的解題筆記，重點放在 Same as LC 207 but return the actual ordering、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Same as LC 207 but return the actual ordering
- **Key insight:** The order nodes are popped from the queue IS the topological order
- **Difference from LC 207:** Append each popped node to result list. If `len(result) == numCourses` → valid order exists.

## Topic — OSI Model

## OSI 7 Layers
- Only need depth on L1, L4, L7 for interviews
- L1 (Physical): bits/signals on the wire
- L2 (Data Link): frames, MAC addresses, node-to-node on local network
- L3 (Network): packets, IP addresses, routing between networks
- L4 (Transport): segments, port numbers, process-to-process reliability
- L5 (Session): theoretical, absorbed by L7 in TCP/IP
- L6 (Presentation): theoretical, encryption/encoding, absorbed by L7 in TCP/IP
- L7 (Application): HTTP, DNS, FTP — application logic

## Key Terminology
- **Segment** → L4 (TCP) — port numbers
- **Packet** → L3 (IP) — IP addresses
- **Frame** → L2 (Ethernet) — MAC addresses
- Frame is largest (wraps everything), segment is smallest

## Encapsulation
- Each layer wraps the layer above's data with its own header
- Sending: L7 → L4 → L3 → L2 → L1 (wrap at each layer)
- Receiving: L1 → L2 → L3 → L4 → L7 (strip at each layer)
- Decapsulation = reverse process on receiving side

## TCP vs UDP
| | TCP | UDP |
|---|---|---|
| Reliability | Guaranteed (ACK + retransmit) | None |
| Ordering | Yes (sequence numbers) | No |
| Speed | Slower | Faster |
| Use cases | HTTP, APIs, databases | Video streaming, gaming, DNS |

- **Why UDP for streaming:** Dropped frame = brief glitch. Waiting for retransmission = worse stutter. Latency matters more than completeness.
- **Why TCP for APIs:** Missing byte = unparseable JSON. Completeness is required.
- **ACK** = Acknowledgement. Receiver tells sender "got segment X, send X+1"
- TCP guarantees ordering via sequence numbers — receiver reorders before passing to L7

## Routing Devices
| Device | Layer | Routes by |
|---|---|---|
| Hub | L1 | Blind signal repeat |
| Switch | L2 | MAC address (intra-network) |
| Router | L3 | IP address (inter-network) |

- **Hop** = one router-to-router step. Frame (MAC) changes at every hop. Packet (IP) stays the same end-to-end.
- **TTL (Time To Live)** = counter in IP packet, decrements by 1 at each hop. Prevents infinite routing loops.

## TLS
- Sits between L4 and L7 — doesn't map to one OSI layer
- Closest to L6 in OSI model, but TCP/IP collapses L5/L6 into application layer
- Depends on TCP (L4) for reliable delivery
- Encrypts L7 payload before handing to TCP
- TLS handshake: Client Hello → Server Hello + Certificate → Key Exchange → Finished
- No HTTP headers involved — happens before any HTTP data is sent

## L4 vs L7 Load Balancer
- **L4:** reads IP + port only. Forwards raw TCP bytes without inspecting content. Cannot do TLS termination.
- **L7:** reads all the way to HTTP layer. Can route by URL path, headers, cookies. Can do TLS termination.
- **Why L4 can't do TLS termination:** Only reads TCP header. Everything above is opaque encrypted bytes — it has no access to certificates or decryption capability.

## Kubernetes context
- **Service (ClusterIP/NodePort):** L4 — routes by IP + port
- **Ingress:** L7 — routes by HTTP host + URL path, handles TLS termination

## OSI vs TCP/IP
- OSI: theoretical 7-layer model
- TCP/IP: what the internet actually uses — 4 layers (Application covers L5+L6+L7, Transport=L4, Internet=L3, Network Access=L1+L2)

## DNS
- Operates at **L7** (application layer protocol)
- Uses **UDP at L4** (small queries, no need for TCP overhead)
- L7 because it has application logic — query types, name resolution, TTL management

## Firewall layers
- Packet filter: L3/L4 — filters by IP + port
- Stateful firewall: L4 — tracks TCP connection state
- WAF (Web Application Firewall): L7 — inspects HTTP content, URLs, domains

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
