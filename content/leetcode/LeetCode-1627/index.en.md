---
title: "LeetCode 1627: Graph Connectivity With Threshold"
summary: "LeetCode 1627 note: no pairwise GCDs; for each z > threshold, connect all multiples of z, O(n log n) unions in total"
description: "LeetCode 1627 record from 2026-09-05"
date: 2026-09-05
tags: ["hard", "math", "number-theory", "union-find", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-05
- Submissions: Time Limit Exceeded → Accepted

## Approach

`x` and `y` are connected ⇔ some `z > threshold` divides both.

Turned around: **for each `z > threshold`, all of `z, 2z, 3z, ...` are connected** (`z` divides them all). So union every multiple of `z` with `z`.

- The number of unions is `Σ n / z`, a harmonic series, `O(n log n)`.
- With `threshold == 0`, `z = 1` divides everything, so all are connected.
- For `z > n / 2`, `z` has no other multiple in range, so skip it.

A query asks whether two cities share a root.

## My Attempts

Attempt 1 computed GCDs for every pair of cities, `O(n^2 log n)`, a TLE at `n = 10^4`. "Each `z` connects its multiples" passed in 44ms.

## Solution

```python
class Solution:
    def areConnected(self, n: int, threshold: int, queries: List[List[int]]) -> List[bool]:
        parent = list(range(n + 1))

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for z in range(threshold + 1, n // 2 + 1):
            for multiple in range(2 * z, n + 1, z):  # all multiples of z are connected
                parent[find(multiple)] = find(z)

        return [find(a) == find(b) for a, b in queries]
```

With `threshold == 0`, `z` starts at 1, whose multiples are everything, so the loop connects all cities with no special case.

## Complexity

Time `O(n log n · α(n) + q)`, space `O(n)`.

## Mistakes to Avoid

- Pairwise GCDs: `O(n^2)`.
- `z` must be **strictly greater** than `threshold`.

## Interview Explanation

Instead of pairwise GCDs I flip it: for each `z` above the threshold, all its multiples are connected, so I union them with `z` in Union-Find. The unions total a harmonic series, `O(n log n)`, and each query compares two roots.
