---
title: "LeetCode 3634: Minimum Removals to Balance Array"
summary: "LeetCode 3634 解題筆記：排序後留下來的一定是連續一段；對每個最小值 nums[left]，用只往右走的指針找能留到哪裡，刪掉兩邊剩下的"
description: "2026-01-10 的 LeetCode 3634 解題紀錄"
date: 2026-01-10
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-10
- 提交紀錄：Accepted ×3（2026-01-10、02-06、02-10 各寫一次）

## 解題思路

只看最大值和最小值，跟順序無關，先排序。

排序後，**留下來的元素一定是連續的一段**：如果留下了 `a` 和 `c`，中間的 `b` 介於兩者之間，留著也不會讓條件變差。

對每個當作最小值的 `nums[left]`，往右找最遠的 `right` 使 `nums[right] <= nums[left] * k`。`left` 變大時門檻只會變大，`right` 不用回頭。刪掉的數量是 `left + (n - right)`。

## 我的解法

```python
class Solution:
    def minRemoval(self, nums: List[int], k: int) -> int:
        nums.sort()
        n = len(nums)
        best = n
        right = 0
        for left in range(n):
            while right < n and nums[right] <= nums[left] * k:
                right += 1                         # [left, right) 都能留下
            best = min(best, left + (n - right))
        return best
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 沒排序就找連續一段：題目是「刪掉任意元素」，不是刪連續的。

## 面試口說整理

條件只看最大和最小，所以先排序，排序後留下的一定是連續的一段。我枚舉留下的最小值 `nums[left]`，用一個只往右走的指針找最遠能留到的位置，刪掉左邊和右邊剩下的，取最小值。時間由排序決定，`O(n log n)`。
