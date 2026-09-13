---
title: "LeetCode 300: Longest Increasing Subsequence"
summary: "LeetCode 解題筆記：Longest Increasing Subsequence"
description: "2026-05-01 的 LeetCode 學習紀錄"
date: 2026-05-01
tags: ["medium", "dynamic-programming", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-01
來源筆記：`notes/day17-week4-day3-max-product-lis-pagination.md`

## 解題思路

這篇整理 Longest Increasing Subsequence 的解題筆記，重點放在 Sequence DP, plus greedy + binary search optimization、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Sequence DP, plus greedy + binary search optimization.

## O(n^2) DP

### Why DP Fits
For each index `i`, the LIS ending at `i` depends on earlier indices `j < i` whose values are smaller than `nums[i]`.

### State
```text
dp[i] = length of the longest increasing subsequence ending at index i
```

### Base Case
```text
dp[i] = 1 for every i
```

Reason:
```text
each element alone is an increasing subsequence of length 1
```

### Transition
```text
for each j < i:
    if nums[j] < nums[i]:
        dp[i] = max(dp[i], dp[j] + 1)
```

### Answer
```text
max(dp)
```

### Complexity
```text
Time: O(n^2)
Space: O(n)
```

### Common Mistakes
- saying "choose index i as one of the elements" instead of "ending at i"
- forgetting the answer is global max, not just `dp[-1]`

## O(n log n) Follow-Up

### Core Idea
Keep:
```text
tails[len - 1] = the smallest possible tail value of an increasing subsequence of length len
```

Why smaller tail is better:
```text
for the same subsequence length, a smaller tail gives more future extension options
```

### Update Rule
For each number:
- if it is larger than all tails, append it
- otherwise replace the first tail `>= num`

### Important Nuance
```text
tails is not always the actual LIS sequence
```

But:
```text
len(tails) is the correct LIS length
```

### Complexity
```text
Time: O(n log n)
Space: O(n)
```

## Interview-Ready Explanation
The O(n^2) DP uses `dp[i]` as the LIS ending at `i`. The O(n log n)` follow-up keeps the smallest possible tail for each subsequence length and uses binary search to replace tails. A smaller tail is better because it leaves more room for future extension.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough for both `O(n^2)` DP and `O(n log n)` follow-up.
