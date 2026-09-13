---
title: "LeetCode 45: Jump Game II"
summary: "LeetCode Problem Solving - Greedy / BFS-layer frontier expansion"
description: "LeetCode study note from 2026-05-01"
date: 2026-05-01
tags: ["medium", "greedy", "bfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-01
Source Note: `notes/day16-week4-day2-jump-game-idempotency-grpc.md`

## Intuition

I treat the array like BFS layers. current_end is the farthest index reachable with the current number of jumps, and farthest is the farthest position I can reach while scanning that layer. When I finish the layer, I inc

Pattern: Greedy / BFS-layer frontier expansion

## Approach

- **Pattern:** Greedy / BFS-layer frontier expansion.

## Why Greedy Fits
This problem asks for:
```text
minimum number of jumps
```

The clean way to think about it is BFS by layers:
- all indices up to `current_end` are reachable with the current number of jumps
- while scanning that layer, compute the farthest index reachable with one more jump
- when the layer ends, commit one jump

## Core Invariants
```text
current_end = farthest index reachable with current jump count
farthest = farthest index reachable while scanning the current layer
jumps = number of committed layers / jumps
```

## Layer Transition
```text
for i in range(len(nums) - 1):
    farthest = max(farthest, i + nums[i])
    if i == current_end:
        jumps += 1
        current_end = farthest
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- defaulting to `O(n^2)` DP even though a linear greedy solution exists
- incrementing `jumps` when `farthest` changes instead of when the current layer ends
- iterating through the last index and adding one unnecessary jump

## Interview-Ready Explanation
I treat the array like BFS layers. `current_end` is the farthest index reachable with the current number of jumps, and `farthest` is the farthest position I can reach while scanning that layer. When I finish the layer, I increment `jumps` and move `current_end` to `farthest`.

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Good enough after BFS-layer greedy correction.
