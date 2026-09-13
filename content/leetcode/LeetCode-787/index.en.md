---
title: "LeetCode 787: Cheapest Flights Within K Stops"
summary: "LeetCode Problem Solving - Cheapest Flights Within K Stops"
description: "LeetCode study note from 2026-04-25"
date: 2026-04-25
tags: ["medium", "graph", "bellman-ford", "shortest-path"]
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
Source Note: `notes/day11-week3-day3-delete-and-earn-cert-validation.md`

## Intuition

Current understanding: Plain Dijkstra with visited = set(city) is wrong. Why Plain visited = set(city) Is Wrong The state is not only the city. Reaching the same city with: can be worse than: because the second route may

Pattern: see the study notes below.

## Approach

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

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Partial repair only; full Bellman-Ford practice deferred.
