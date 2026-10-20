---
title: "LeetCode 4040: Minimum Operations to Form Subset Sum I"
summary: "LeetCode 4040 note: with multiplications before divisions, the best is always multiply-only or divide-only; list each number's reachable values and costs, then run a grouped 0/1 knapsack"
description: "LeetCode 4040 record from 2026-08-30"
date: 2026-08-30
tags: ["medium", "dynamic-programming", "knapsack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-30
- Submissions: Accepted ×2

## Approach

Multiplying `x` by 2 `a` times and then halving `b` times:

- `a >= b`: the result is `x × 2^(a - b)`, reachable with only `a - b` multiplications, in fewer steps.
- `a < b`: the result is `x // 2^(b - a)`, reachable with only `b - a` divisions, in fewer steps.

So each number has just two kinds of options:

- `x, 2x, 4x, ...` (up to `sum`), costing `0, 1, 2, ...`.
- `x // 2, x // 4, ...` (above 0), costing `1, 2, ...`.

Then it is a **grouped 0/1 knapsack**: each number picks one option or none, with `dp[s]` = the fewest operations for a subset summing to exactly `s`.

## My Solution

```python
class Solution:
    def minOperations(self, nums: List[int], sum: int) -> int:
        INF = float("inf")
        dp = [0] + [INF] * sum                     # dp[s]: fewest operations for subset sum s
        for x in nums:
            options = []
            v, cost = x, 0
            while v <= sum:                        # multiply only
                options.append((v, cost))
                v, cost = v * 2, cost + 1
            v, cost = x // 2, 1
            while v > 0:                           # divide only
                if v <= sum:
                    options.append((v, cost))
                v, cost = v // 2, cost + 1

            for s in range(sum, -1, -1):           # backwards: each number used at most once
                if dp[s] == INF:
                    continue
                for v, cost in options:
                    if s + v <= sum:
                        dp[s + v] = min(dp[s + v], dp[s] + cost)
        return dp[sum] if dp[sum] < INF else -1
```

This pushes from `dp[s]` into `dp[s + v]`; with `s` running backwards, `dp[s]` always still holds the previous number's value.

## Complexity

Time `O(n · sum · log(sum))`, space `O(sum)`.

## Mistakes to Avoid

- Enumerating every mix of multiplications and divisions: no multiply-then-divide mix beats pure multiplying or pure dividing.
- Values divided down to 0 are useless; leave them out of the options.

## Interview Explanation

With multiplications before divisions they cancel, so the best is always multiply-only or divide-only. I list each number's reachable values with their costs; each number picks at most one, giving a grouped 0/1 knapsack where `dp[s]` is the fewest operations for subset sum `s`, with capacity running backwards. Time `O(n · sum · log(sum))`.
