---
title: "LeetCode 494: Target Sum"
summary: "LeetCode 解題筆記：Target Sum"
description: "2026-08-23 的 LeetCode 學習紀錄"
date: 2026-08-23
tags: ["leetcode", "medium", "dynamic-programming", "knapsack", "subset-sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-23
來源筆記：`notes/day44-week8-day2-target-sum-dice-rolls-shard-key-hot-shard.md`

## 解題思路

這篇整理 Target Sum 的解題筆記，重點放在 `0/1` subset-sum counting after algebra reduction、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** `0/1` subset-sum counting after algebra reduction.

## Why This Fits
Each number is used exactly once, but can land in either:
- the `+` set
- the `-` set

Let:
```text
P = sum of plus-assigned numbers
N = sum of minus-assigned numbers
```

Then:
```text
P - N = target
P + N = total
=> N = (total - target) / 2
```

So the real question is:
```text
how many subsets sum to (total - target) / 2?
```

## Core State / Invariant
```text
dp[s] = number of ways to form sum s using the numbers processed so far
```

## Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 before using any numbers:
choose nothing
```

## Transition
For each `num`, iterate sum backward:
```text
dp[s] += dp[s - num]
```

## Why Backward
Backward iteration preserves the `0/1` rule:
```text
the current number must not be reused again in the same iteration
```

## Immediate Zero Cases
```text
abs(target) > total
```

or:
```text
(total - target) is odd
```

## Complexity
```text
Time: O(len(nums) * reduced_target)
Space: O(reduced_target)
```

## Common Mistakes
- getting the algebra reduction sign wrong
- forgetting the `abs(target) > total` rejection
- saying `dp[s]` is only `possible or not` instead of `number of ways`
- iterating the sum forward and accidentally reusing one number multiple times

## Strong Spoken Explanation
I convert the sign-assignment problem into subset-sum counting. If `P` is the plus set and `N` is the minus set, then `P - N = target` and `P + N = total`, so `N = (total - target) / 2`. That means I just need to count how many subsets sum to that reduced target. If the reduced target is negative or not an integer, the answer is `0`. Then I use `0/1` counting DP where `dp[s]` is the number of ways to form sum `s` using the numbers processed so far. I initialize `dp[0] = 1`, iterate each number once, and update sums backward with `dp[s] += dp[s - num]`.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

原始筆記沒有另外紀錄失誤點。
