---
title: "LeetCode 35: Search Insert Position"
summary: "LeetCode 35 解題筆記：找第一個 >= target 的位置（lower bound）；半開區間 [l, r) 要配 r = mid，不能寫 r = mid - 1"
description: "2022-05-11 的 LeetCode 35 解題紀錄"
date: 2022-05-11
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-11
- 提交紀錄：Wrong Answer → Accepted → Runtime Error ×2 → Accepted → Wrong Answer → Time Limit Exceeded → Wrong Answer ×2 → Runtime Error → Accepted ×2

## 解題思路

插入的位置就是「第一個 `>= target` 的 index」，也就是 lower bound（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。用半開區間 `[l, r)`：`nums[mid] < target` 時答案在右邊 `l = mid + 1`，否則 `mid` 可能就是答案，`r = mid`。

## 我的嘗試

這題提交了 12 次，主要是區間寫法混在一起：

- 一開始忘了寫回傳值、用 `/` 算 `mid`（TypeError）。
- 2022 年 11 月重寫時用了半開區間 `right = len(nums)`，卻寫 `right = mid - 1`，把可能的答案跳過了。例如 `[0, 7]`、`target = 5`：答案 1，回傳 0。

## 正確解法

```python
class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums)
        while l < r:
            mid = (l + r) // 2
            if nums[mid] < target:
                l = mid + 1
            else:
                r = mid
        return l
```

## 複雜度

時間 `O(log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 區間寫法不能混用：`r = len(nums)` 的半開區間要配 `while l < r` 和 `r = mid`。

## 面試口說整理

答案是第一個不小於目標的位置，所以我用半開區間做 lower bound：中間比目標小就往右，否則把右界縮到中間。最後的 `l` 就是答案。時間 `O(log n)`。
