---
title: "LeetCode 2218: Maximum Value of K Coins From Piles"
summary: "LeetCode 2218 note: piles are taken from the top, so taking x coins is worth a prefix sum; a grouped knapsack with dp[j] = the best value taking j coins so far, enumerating how many from each pile"
description: "LeetCode 2218 record from 2026-09-14"
date: 2026-09-14
tags: ["hard", "dynamic-programming", "knapsack", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-14
- Submissions: Accepted ×5 (2D → 1D, refined step by step)

## Approach

Coins come off the top of each pile, so taking `x` coins from a pile always means **its top `x`**, worth the pile's prefix sum `prefix[x]`.

Each pile is a group whose options are "take `0..len(pile)` coins": a **grouped knapsack**:

```text
dp_i[j] = max over x of dp_{i-1}[j - x] + prefix_i[x]
```

`dp[j]` = the best value taking `j` coins from the first `i` piles. Start with `dp[0] = 0` and negative infinity elsewhere (exactly `j` coins is not yet possible).

## My Solution

```python
class Solution:
    def maxValueOfCoins(self, piles: List[List[int]], k: int) -> int:
        NEG = float("-inf")
        dp = [0] + [NEG] * k                       # dp[j]: j coins taken so far
        for pile in piles:
            prefix = [0]
            for v in pile[:k]:                     # at most k coins from one pile
                prefix.append(prefix[-1] + v)
            ndp = [NEG] * (k + 1)
            for j in range(k + 1):
                for x, val in enumerate(prefix):   # take x coins from this pile
                    if x > j:
                        break
                    ndp[j] = max(ndp[j], dp[j - x] + val)
            dp = ndp
        return dp[k]
```

I started from a 2D `dp[i][j]` and refined it to 1D with per-pile prefix sums; the fresh `ndp` keeps one pile from being used twice (running `j` backwards in place also works).

## Complexity

Time `O(k · Σ min(len(pile), k))`, space `O(k)`.

## Mistakes to Avoid

- Assuming coins can come from anywhere: only from the top, so values are prefix sums.
- A pile's options are mutually exclusive: use a new array or run capacity backwards.

## Interview Explanation

Coins come from the top of each pile, so taking `x` is worth the pile's prefix sum; each pile is a group whose option is how many to take, a grouped knapsack. `dp[j]` is the best value with `j` coins taken so far, and each pile updates a new array by trying every count. Time `O(k · total coins)`.
