---
title: "LeetCode 162: Find Peak Element"
summary: "LeetCode 162 解題筆記：nums[mid] < nums[mid + 1] 代表右邊一定有山峰（一路上升最後也會碰到邊界），否則左邊（含 mid）一定有"
description: "2022-11-11 的 LeetCode 162 解題紀錄"
date: 2022-11-11
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-11
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

陣列兩端外面都當成負無限大（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）。看 `mid` 和 `mid + 1`：

- `nums[mid] < nums[mid + 1]`：往右是上坡，右邊一定有山峰（就算一路上升，最後一個也是山峰），`l = mid + 1`。
- 否則 `mid` 往右是下坡，`mid` 或它左邊一定有山峰，`r = mid`。

相鄰的值不相等，所以不會有平的地方。

## 我的嘗試

前幾版同時比較 `mid - 1` 和 `mid + 1`，邊界一直超出範圍（IndexError）；一版把 `nums` 打成 `num`；最後一版 WA 回傳的位置不是山峰，例如 `[0, 2, 4]` 沒有回傳 2。

## 正確解法

```python
class Solution:
    def findPeakElement(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] < nums[mid + 1]:
                l = mid + 1
            else:
                r = mid
        return l
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用 `while l < r`，`mid + 1` 一定在範圍內。

## 面試口說整理

我比較中間和它右邊那個：往右是上坡就代表右邊一定有山峰，否則中間或左邊一定有。區間縮到一個位置就是山峰。時間 `O(log n)`。
