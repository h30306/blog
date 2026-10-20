---
title: "LeetCode 312: Burst Balloons"
summary: "LeetCode 312 note: choose the last balloon k burst in the range (i, j); at that moment its neighbors are i and j, and the two sides are independent subproblems"
description: "LeetCode 312 record from 2026-06-26"
date: 2026-06-26
tags: ["hard", "dynamic-programming", "interval-dp", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-26
- Submissions: Runtime Error → Accepted ×2

## Approach

Choosing the **first** balloon to burst makes its two sides neighbors afterwards, so the subproblems stop being independent.

**Choose the last one instead**: pad both ends with 1, `val = [1] + nums + [1]`, and let `dp[i][j]` = the best score for bursting every balloon in the **open range** `(i, j)`. If `k` is the last one burst in `(i, j)`:

- When `k` bursts, `(i, k)` and `(k, j)` are already empty, so its neighbors are `i` and `j`, scoring `val[i] × val[k] × val[j]`.
- While `(i, k)` and `(k, j)` are being burst, `k` is still there, so the two sides do not affect each other.

```text
dp[i][j] = max over k in (i, j) of dp[i][k] + dp[k][j] + val[i] × val[k] × val[j]
```

The answer is `dp[0][n + 1]`.

## My Attempts

Attempt 1 misspelled a variable: it declared `max_coin` but the loop wrote `max_coins = max(max_coins, coins)`, raising UnboundLocalError. Making the names match passed.

## Solution

```python
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        val = [1] + nums + [1]
        n = len(val)
        dp = [[0] * n for _ in range(n)]           # dp[i][j]: open range (i, j)
        for length in range(2, n):
            for i in range(n - length):
                j = i + length
                dp[i][j] = max(dp[i][k] + dp[k][j] + val[i] * val[k] * val[j]
                               for k in range(i + 1, j))
        return dp[0][n - 1]
```

My accepted version was a memoized recursion `dfs(i, j)` that took 3.5 seconds; the bottom-up loop by length is somewhat faster.

## Complexity

Time `O(n^3)`, space `O(n^2)`.

## Mistakes to Avoid

- Choosing the first balloon burst: the subproblems are not independent.
- Using closed ranges: neighbors get awkward; open ranges with 1s padded at the ends are cleanest.

## Interview Explanation

I choose the last balloon burst in a range, because by then both sides are empty, its neighbors are the range's ends, and the two sides are independent. With 1s padded at the ends, `dp[i][j]` is the best for the open range: left plus right plus `val[i] × val[k] × val[j]`. Filling by increasing length gives `O(n^3)`.
