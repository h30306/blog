---
title: "LeetCode 4041: Minimum Operations to Form Subset Sum II"
summary: "LeetCode 4041 note: with operations in any order, BFS finds every value a number can become (up to sum) with the fewest steps, then the same grouped 0/1 knapsack as 4040"
description: "LeetCode 4041 record from 2026-08-30"
date: 2026-08-30
tags: ["hard", "dynamic-programming", "knapsack", "breadth-first-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-30
- Submissions: Accepted (first try)

## Approach

The same grouped 0/1 knapsack as [LeetCode 4040]({{< relref "/leetcode/LeetCode-4040" >}}), except operations may come in **any order**. Dividing then multiplying reaches new values, e.g. `5 → 2 → 4`, which neither multiplying nor dividing alone can reach.

So each number's options come from **BFS**: from `x`, each step multiplies or halves, recording the fewest steps for each value.

- Once doubling exceeds `sum`, stop: halving back is never better than not doubling (`2v // 2 = v`, just two extra steps).
- Halving can reach 0, which never helps a subset sum, but listing it changes nothing.

## My Solution

```python
from collections import deque

class Solution:
    def minOperations(self, nums: List[int], sum: int) -> int:
        INF = float("inf")
        dp = [0] + [INF] * sum
        for x in nums:
            dist = {x: 0}                          # BFS: value x can become -> fewest steps
            queue = deque([x])
            while queue:
                v = queue.popleft()
                for nv, ok in ((v * 2, v * 2 <= sum), (v // 2, True)):
                    if ok and nv not in dist:           # doubling stays within sum; halving always allowed
                        dist[nv] = dist[v] + 1
                        queue.append(nv)

            for s in range(sum, -1, -1):           # grouped 0/1 knapsack
                if dp[s] == INF:
                    continue
                for v, cost in dist.items():
                    if 0 < v and s + v <= sum:
                        dp[s + v] = min(dp[s + v], dp[s] + cost)
        return dp[sum] if dp[sum] < INF else -1
```

The starting `x` may exceed `sum`; it is in `dist`, but `s + v <= sum` filters it out, while the values halved from it remain usable.

## Complexity

Each number reaches about `O(log^2 sum)` values, so time is `O(n · sum · log^2 sum)`, space `O(sum)`. My accepted version took 14 seconds; this problem's time limit is generous.

## Mistakes to Avoid

- Considering only multiply-only or divide-only: in any order, dividing then multiplying reaches new values.
- In the BFS, stop doubling past `sum`, but **do not cap halving**: the starting value may exceed `sum` and has to be halved down first.

## Interview Explanation

Like 4040 this is a grouped 0/1 knapsack, except operations come in any order, so dividing then multiplying reaches new values. Each number's options come from a BFS that doubles or halves per step, never going past `sum`, recording each value's fewest steps. Then capacity runs backwards as before, with each number choosing at most one option.
