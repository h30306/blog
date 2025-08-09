---
title: "LeetCode 1695: Maximum Erasure Value (Sliding Window)"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "sliding-window", "two-pointers", "array", "hashset"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: Medium
第一次嘗試： 2025-08-09
- 總花費時間：00:00.00

## 解題思路

這題是典型的滑動視窗（Sliding Window）配合雙指標。維持「當前視窗內沒有重複數字」的約束：右指標往右擴張；若 `nums[right]` 已存在於視窗，就從左邊不斷收縮，移除數值並從目前總和中扣除，直到沒有重複為止。接著把 `nums[right]` 加入視窗並更新答案。

## 解法

```python
class Solution:
    def maximumUniqueSubarray(self, nums: List[int]) -> int:
        left = max_score = score_now = 0
        occur = set()

        for right in range(len(nums)):
            while nums[right] in occur:
                occur.remove(nums[left])
                score_now -= nums[left]
                left += 1

            occur.add(nums[right])
            score_now += nums[right]
            max_score = max(max_score, score_now)

        return max_score
```

## 複雜度

- 時間複雜度：O(n)
- 空間複雜度：O(n)

## 收穫

- 維持「目前總和」可避免每次重新計算視窗總和。
- 使用 `set` 做存在性檢查可達到 O(1)，確保視窗內元素唯一。
- 標準雙指標範式，可套用到許多「最長/最大子陣列且需滿足某約束」的題目。

## 遇到的問題