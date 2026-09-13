---
title: "LeetCode 1631: Path With Minimum Effort"
summary: "LeetCode Problem Solving - Dijkstra on a grid with nonsum path cost. Why Dijkstra Still Works The path cost is not the sum of edge weights. Instead: That means the path effort is: not strictly increasing. That monotonic property is why Di"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
Source Note: `notes/day10-week3-day2-dp-repair-tls-handshake.md`

## Intuition

Pattern: Dijkstra on a grid with nonsum path cost. Why Dijkstra Still Works The path cost is not the sum of edge weights. Instead: That means the path effort is: not strictly increasing. That monotonic property is why Di

Pattern: Dijkstra on a grid with non-sum path cost

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough after wording repair.
