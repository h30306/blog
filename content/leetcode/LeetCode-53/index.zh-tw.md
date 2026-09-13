---
title: "LeetCode 53: Maximum Subarray"
summary: "LeetCode 解題筆記：Maximum Subarray"
description: "2026-05-10 的 LeetCode 學習紀錄"
date: 2026-05-10
tags: ["medium", "dynamic-programming", "kadane"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-10
來源筆記：`notes/day21-week4-weekend-day2-api-recall-speed-round.md`

## 解題思路

這篇整理 Maximum Subarray 的解題筆記，重點放在 1D DP with rolling state / Kadane's algorithm、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** 1D DP with rolling state / Kadane's algorithm.

## Correct State
```text
curr = maximum subarray sum ending at the current index
best = maximum subarray sum seen so far
```

## Why This State Fits
For any index `i`, the best subarray ending at `i` has only 2 possibilities:
- start fresh at `nums[i]`
- extend the best subarray ending at `i - 1`

That gives the recurrence:
```text
curr = max(nums[i], curr + nums[i])
best = max(best, curr)
```

## Initialization
```text
curr = best = nums[0]
```

Why:
```text
all-negative arrays are valid, so initializing to 0 would be wrong
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- saying `curr` is just "current subarray sum" instead of the exact ending-here invariant
- initializing to `0`, which breaks all-negative arrays
- returning `curr` instead of `best`

## Interview-Ready Explanation
This is 1D DP with rolling state, also known as Kadane's algorithm. I define `curr` as the maximum subarray sum ending at the current index, and `best` as the maximum subarray sum seen so far. For each element, the best subarray ending here either starts fresh at this element or extends the previous ending-here subarray, so `curr = max(nums[i], curr + nums[i])`. Then I update `best = max(best, curr)`. I initialize both to `nums[0]` so all-negative arrays are handled correctly. The time complexity is `O(n)` and the space complexity is `O(1)`.

## Code
```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]

        for i in range(1, len(nums)):
            curr = max(nums[i], curr + nums[i])
            best = max(best, curr)

        return best
```

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Pass.
