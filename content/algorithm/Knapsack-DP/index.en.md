---
title: "Knapsack DP"
summary: "0/1, unbounded, reachability, counting, and optimization states"
description: "Algorithm Learning"
date: 2026-09-13
tags: ["dynamic-programming", "knapsack", "subset-sum"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Knapsack DP problems look similar on the surface, but the correct solution depends on three questions:

1. Can each item be used once or reused many times?
2. Does `dp[...]` mean reachable, number of ways, minimum cost, or maximum value?
3. In 1D compression, should the capacity loop go backward or forward?

Most mistakes come from answering one of these questions incorrectly.

## 0/1 Knapsack

Each item can be used at most once, so the compressed capacity loop goes backward.

```python
from typing import List

def subset_sum(nums: List[int], target: int) -> bool:
    dp = [False] * (target + 1)
    dp[0] = True

    for num in nums:
        for s in range(target, num - 1, -1):
            dp[s] = dp[s] or dp[s - num]

    return dp[target]
```

Backward iteration prevents the current item from being reused in the same item round.

## Unbounded Knapsack

Each item can be reused, so the capacity loop often goes forward.

```python
from typing import List

def coin_change_min(coins: List[int], amount: int) -> int:
    inf = amount + 1
    dp = [inf] * (amount + 1)
    dp[0] = 0

    for coin in coins:
        for a in range(coin, amount + 1):
            dp[a] = min(dp[a], dp[a - coin] + 1)

    return -1 if dp[amount] == inf else dp[amount]
```

## Counting Combinations vs Permutations

For combinations, put items outside:

```text
for coin in coins:
    for amount forward:
        dp[amount] += dp[amount - coin]
```

For ordered sequences, put target outside:

```text
for total in range(target + 1):
    for num in nums:
        dp[total] += dp[total - num]
```

This is the key difference between `LC 518` and `LC 377`.

## Common Mistakes

- Treating every coin problem as the same recurrence.
- Using forward iteration for `0/1` items and accidentally reusing them.
- Using backward iteration for unbounded counting and losing reuse.
- Confusing `dp[0] = 0` for min-count with `dp[0] = 1` for counting.
- Solving exact target only when the answer is closest half, as in partition problems.

## Related LeetCode

- `LC 416` Partition Equal Subset Sum
- `LC 474` Ones and Zeroes
- `LC 494` Target Sum
- `LC 518` Coin Change 2
- `LC 879` Profitable Schemes
- `LC 1049` Last Stone Weight II
- `LC 1449` Form Largest Integer With Digits That Add Up To Target
