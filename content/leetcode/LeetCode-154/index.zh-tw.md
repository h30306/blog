---
title: "LeetCode 154: Find Minimum in Rotated Sorted Array II"
summary: "LeetCode 154 解題筆記：跟 LC 153 一樣跟右端比，相等時分不出斷點在哪一邊，只能 r -= 1；最壞 O(n)"
description: "2022-11-28 的 LeetCode 154 解題紀錄"
date: 2022-11-28
tags: ["hard", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2022-11-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

在 LC 153 的基礎上多了重複值（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）。`nums[mid] == nums[r]` 時，例如 `[3, 3, 1, 3]` 和 `[3, 1, 3, 3]`，斷點可能在任一邊，但可以確定拿掉 `nums[r]` 不會丟掉最小值（`nums[mid]` 跟它一樣），所以 `r -= 1`。

## 我的解法

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] > nums[r]:
                l = mid + 1
            elif nums[mid] < nums[r]:
                r = mid
            else:
                r -= 1                               # 相等時只能縮一格
        return nums[l]
```

## 複雜度

平均 `O(log n)`，最壞 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 相等時不能用 `r = mid`，最小值可能在 `mid` 和 `r` 之間。

## 面試口說整理

跟沒有重複時一樣拿中間跟右端比，但相等時分不出斷點在哪一邊；因為右端跟中間一樣，拿掉它不會丟掉最小值，所以右界減一。最壞 `O(n)`。
