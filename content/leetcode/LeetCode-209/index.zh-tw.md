---
title: "LeetCode 209: Minimum Size Subarray Sum"
summary: "滑動視窗與雙指針，最小化子陣列長度（總和 ≥ target）。"
description: "以滑動視窗解最小長度連續子陣列（總和 ≥ target），包含複雜度與重點心得。"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "array", "sliding-window", "two-pointers", "prefix-sum", "binary-search"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度：中等
第一次嘗試：2025-08-09
- 總花費時間：00:00.00

## 解題思路

這題屬於滑動視窗。用右指針累加視窗總和，當總和大於等於 `target` 時，開始從左邊縮小視窗，試著在仍符合條件的前提下把長度壓到最短。

## 解法

- 維護區間 `[left, right]` 與 `window_sum`。
- 每次右移 `right` 就把 `nums[right]` 加進 `window_sum`。
- 只要 `window_sum ≥ target`，就更新答案，並持續右移 `left` 同時扣除 `nums[left]`，以取得更短的合法視窗。

```python
from typing import List

class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        left = 0
        window_sum = 0
        min_length = float("inf")

        for right, value in enumerate(nums):
            window_sum += value
            while window_sum >= target:
                min_length = min(min_length, right - left + 1)
                window_sum -= nums[left]
                left += 1

        return 0 if min_length == float("inf") else min_length
```

### 複雜度

- 時間：O(n)
- 空間：O(1)

## 收穫

- 所有數字為正時，滑動視窗才能單調縮小並保證不會漏解。
- 不變量：一旦 `window_sum ≥ target`，就嘗試移動 `left` 以縮短視窗。
- 另一種作法是前綴和 + 二分搜尋，時間 O(n log n)，但本題滑動視窗已是最佳。 

## 遇到的問題