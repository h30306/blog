---
title: "LeetCode 33: Search in Rotated Sorted Array"
summary: "LeetCode 33 解題筆記：旋轉後 mid 的左右一定有一邊是排序好的，判斷目標在不在那一邊，在就往那邊找，不在就去另一邊"
description: "2022-10-21 的 LeetCode 33 解題紀錄"
date: 2022-10-21
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
第一次嘗試：2022-10-21
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer ×4 → Accepted → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted → Runtime Error → Accepted ×4
- 2026-11-03 重寫：Accepted ×2

## 解題思路

切在 `mid`，左半 `[l, mid]` 和右半 `[mid, r]` 至少有一邊是排序好的（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）：

- `nums[l] <= nums[mid]`：左半有序。目標在 `[nums[l], nums[mid])` 之間就往左，否則往右。
- 否則右半有序。目標在 `(nums[mid], nums[r]]` 之間就往右，否則往左。

只能用**有序的那一半**判斷目標在不在裡面。

## 我的嘗試

2022 年第一次 AC 的其實是線性掃描（`O(n)`）。之後練二分搜尋的 10 幾次 WA 都是方向判斷錯：

- 一版先用 `nums[mid] >= target` 決定，再檢查範圍，但用來檢查的那一半不一定有序。例如 `[8, 9, 10, 3]`、`target = 10`：答案 2，回傳 -1。
- 一版只看 `nums[r] >= target` 就往左縮，方向反了。例如 `[1, 5]`、`target = 5` 回傳 -1。

## 正確解法

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return mid
            if nums[l] <= nums[mid]:                     # 左半有序
                if nums[l] <= target < nums[mid]:
                    r = mid - 1
                else:
                    l = mid + 1
            else:                                        # 右半有序
                if nums[mid] < target <= nums[r]:
                    l = mid + 1
                else:
                    r = mid - 1
        return -1
```

## 2026-11 重寫

2026-11-03 換了一種寫法，一次 AC（下午又交了一次一樣的程式碼）。這次不判斷「哪一半有序」，而是定義一個單調的條件 `valid(mid)`，用二分找第一個 True：

- 用 `nums[-1]` 把陣列分成兩段：`> nums[-1]` 的是左段，`<= nums[-1]` 的是右段。
- `mid` 和 `target` 在不同段：`mid` 在右段就回傳 True（這時 target 在左段，答案在 `mid` 左邊），否則回傳 False。
- 在同一段：那段是排序好的，回傳 `nums[mid] >= target`。

這樣 `valid` 從左到右會是 False…False True…True，第一個 True 就是 target 應該在的位置，最後再檢查 `nums[left] == target`。

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        def valid(mid):
            mid_right = nums[mid] <= nums[-1]
            target_right = target <= nums[-1]
            if mid_right != target_right:
                return mid_right
            return nums[mid] >= target

        left, right = 0, len(nums) - 1
        while left <= right:
            mid = (left + right) // 2
            if valid(mid):
                right = mid - 1
            else:
                left = mid + 1
        return left if left < len(nums) and nums[left] == target else -1
```

好處是二分的部分完全照模板，只要把條件想清楚。2022 年十幾次 WA 都錯在分兩半時的方向判斷，這個寫法沒有那些分支。沒有旋轉時，所有元素都在右段，條件就變成一般的 lower bound。

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 先判斷哪一半有序，再看目標在不在那一半；不能直接拿 `nums[mid]` 跟目標比大小決定方向。
- `nums[l] <= nums[mid]` 要包含等於（`l == mid` 時）。

## 面試口說整理

旋轉後 `mid` 的左右一定有一邊是排序好的。我先判斷哪一邊有序，再看目標在不在那一邊的範圍內，在就往那邊找，不在就去另一邊。時間 `O(log n)`。
