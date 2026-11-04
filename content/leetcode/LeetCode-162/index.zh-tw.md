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
- 2026-11-03 重寫：Accepted

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

## 2026-11 重寫

2026-11-03 一次 AC，用左閉右閉找第一個 True，條件 `valid(mid)` 是：`mid` 是最後一個，或 `nums[mid] > nums[mid + 1]`（往右是下坡）。

這個條件**不是單調的**，例如 `[1, 3, 2, 4, 1]` 是 F T F T T，但二分還是會回傳山峰（這個例子回傳 3）。因為迴圈一直維持兩件事：
- `left - 1` 往右是上坡，或 `left == 0`。
- `right + 1` 往右是下坡，或它是最後一個。

結束時 `left == right + 1`：`left` 的左邊是上坡，自己往右是下坡，所以是山峰。找到的不一定是第一個 True，但一定是山峰。上面的 `while l < r` 寫法講的是同一件事。

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用 `while l < r`，`mid + 1` 一定在範圍內。

## 面試口說整理

我比較中間和它右邊那個：往右是上坡就代表右邊一定有山峰，否則中間或左邊一定有。區間縮到一個位置就是山峰。時間 `O(log n)`。
