---
title: "LeetCode 152: Maximum Product Subarray"
summary: "LeetCode 解題筆記：Maximum Product Subarray"
description: "2026-05-01 的 LeetCode 學習紀錄"
date: 2026-05-01
tags: ["leetcode", "medium", "dynamic-programming"]

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

這篇整理 Maximum Product Subarray 的解題筆記，重點放在 Rolling DP with max/min state、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Rolling DP with max/min state.

## Why DP Fits
Product behaves differently from sum because a negative number can flip:
- a very small negative product into the new maximum
- a previous maximum into the new minimum

So one rolling state is not enough.

## State
```text
cur_max = maximum product of a subarray ending at current index
cur_min = minimum product of a subarray ending at current index
```

Important nuance:
```text
"max" and "min" are value-based, not sign-based labels
```

## Base Case
```text
cur_max = cur_min = nums[0]
answer = nums[0]
```

## Transition
For current number `x`, compute from:
- `x`
- previous `cur_max * x`
- previous `cur_min * x`

So:
```text
new_max = max(x, cur_max * x, cur_min * x)
new_min = min(x, cur_max * x, cur_min * x)
```

Then:
```text
cur_max = new_max
cur_min = new_min
answer = max(answer, cur_max)
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- tracking only one running product
- forgetting that the DP boundary is "ending at i"
- returning the final `cur_max` instead of a global answer

## Interview-Ready Explanation
I track both the maximum and minimum product ending at each index, because multiplying by a negative can swap their roles. At each number, I either start a new subarray or extend the previous max/min product. I keep a separate global answer because the best subarray may end before the last index.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough.
