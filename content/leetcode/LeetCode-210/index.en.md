---
title: "LeetCode 210: Course Schedule II"
summary: "LeetCode Problem Solving - Same as LC 207 but return the actual ordering Key insight: The order nodes are popped from the queue IS the topological order Difference from LC 207: Append each popped node to result list. If len(result) == num"
description: "LeetCode study note from 2026-04-08"
date: 2026-04-08
tags: ["leetcode", "medium", "graph", "topological-sort"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-08
Source Note: `notes/day1-topological-sort-osi-model.md`

## Intuition

Pattern: Same as LC 207 but return the actual ordering Key insight: The order nodes are popped from the queue IS the topological order Difference from LC 207: Append each popped node to result list. If len(result) == num

Pattern: Same as LC 207 but return the actual ordering

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Captured from the learning note; no separate failure note was recorded.
