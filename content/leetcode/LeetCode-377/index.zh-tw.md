---
title: "LeetCode 377: Combination Sum IV"
summary: "LeetCode 解題筆記：Combination Sum IV"
description: "2026-05-03 的 LeetCode 學習紀錄"
date: 2026-05-03
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-03
來源筆記：`notes/day18-week4-day4-request-path.md`

## 解題思路

這篇整理 Combination Sum IV 的解題筆記，重點放在 Unbounded counting DP for ordered sequences、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Unbounded counting DP for ordered sequences.

## Why DP Fits
For each target sum `i`, we can pick any `num` as the last element of the sequence.

That means:
```text
number of sequences for i depends on number of sequences for i - num
```

It is unbounded because each number can be reused many times.

Important nuance:
```text
order matters
```

So:
```text
1 + 2 and 2 + 1 are different answers
```

## State
```text
dp[i] = number of ordered sequences that sum to i
```

## Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0: choose nothing
```

## Transition
For each total `i` from `1` to `target`:
```text
for num in nums:
    if i >= num:
        dp[i] += dp[i - num]
```

## Why Loop Order Matters
Use:
```text
outer loop on total, inner loop on nums
```

Why:
```text
for each target sum i, we try every num as the last element of the sequence
```

That counts permutations separately.

Example with `nums = [1, 2]`, `target = 3`:
- `[1, 1, 1]`
- `[1, 2]`
- `[2, 1]`

If you use coin-first loop order, you undercount by collapsing different permutations into one combination.

## Complexity
```text
Time: O(target * len(nums))
Space: O(target)
```

## Common Mistakes
- saying `dp[i]` is number of combinations instead of ordered sequences
- setting `dp[0] = 0` instead of `1`
- using coin-first loop order and counting combinations instead of permutations
- using min-count transition like `+ 1` instead of counting transition `+=`

## Interview-Ready Explanation
This is an unbounded counting DP problem where order matters. I define `dp[i]` as the number of ordered sequences that sum to `i`. The base case is `dp[0] = 1`, because there is exactly one way to make sum `0`, which is choosing nothing. Then for each total `i` from `1` to `target`, I iterate through `nums`, and if `i >= num`, I do `dp[i] += dp[i - num]`. The important nuance is that looping total first and nums second counts permutations, so `[1, 2]` and `[2, 1]` are different answers. The time complexity is `O(target * len(nums))` and the space complexity is `O(target)`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
