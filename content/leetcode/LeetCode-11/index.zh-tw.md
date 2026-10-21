---
title: "LeetCode 11: Container With Most Water"
summary: "LeetCode 11 解題筆記：左右指針從兩端開始，每次移動比較矮的那一邊；移動高的那邊只會讓寬度變小、高度不會變高"
description: "2022-10-20 的 LeetCode 11 解題紀錄"
date: 2022-10-20
tags: ["medium", "array", "two-pointers", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-20
- 提交紀錄：Runtime Error → Time Limit Exceeded → Accepted ×6 → Wrong Answer ×2 → Accepted

## 解題思路

面積是 `寬度 × 兩邊較矮的高度`（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。從兩端開始，寬度最大。每次要移動一邊：

- 移動**比較高**的那邊：寬度變小，高度還是被矮的那邊限制，面積不可能變大。
- 所以移動**比較矮**的那邊，才有機會找到更高的。

## 我的嘗試

2022 年 11 月重寫時一版把條件寫成 `if r > l: l += 1`，看的是位置而不是高度，等於每次都移左邊，例如 `[3, 5, 1]`：答案 3（3 和 5 之間），回傳 2。

## 正確解法

```python
class Solution:
    def maxArea(self, height: List[int]) -> int:
        l, r, best = 0, len(height) - 1, 0
        while l < r:
            best = max(best, (r - l) * min(height[l], height[r]))
            if height[l] < height[r]:
                l += 1
            else:
                r -= 1
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 移動哪一邊要看**高度**，不是看位置。

## 面試口說整理

我從兩端開始，每次算面積後移動比較矮的那一邊，因為移動高的那邊只會讓寬度變小、高度不會增加。每個位置只看一次，時間 `O(n)`。
