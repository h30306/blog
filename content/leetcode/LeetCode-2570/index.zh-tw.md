---
title: "LeetCode 2570: Merge Two 2D Arrays by Summing Values"
summary: "LeetCode 2570 解題筆記：兩個依 id 排序的陣列，用合併兩個有序序列的雙指針，id 相同就相加"
description: "2026-01-31 的 LeetCode 2570 解題紀錄"
date: 2026-01-31
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-31
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個陣列都已經依 id 排好序，而且各自的 id 不重複。就是合併兩個有序序列（跟 LC 88 一樣），只是 id 相同時要把值相加：

- id 相同：輸出 `[id, 兩邊的值相加]`，兩個指針都往前。
- 不同：輸出 id 比較小的那個，那個指針往前。
- 其中一邊用完後，另一邊剩下的直接接上。

## 我的解法

```python
class Solution:
    def mergeArrays(self, nums1: List[List[int]], nums2: List[List[int]]) -> List[List[int]]:
        i = j = 0
        res = []
        while i < len(nums1) and j < len(nums2):
            if nums1[i][0] == nums2[j][0]:
                res.append([nums1[i][0], nums1[i][1] + nums2[j][1]])
                i += 1
                j += 1
            elif nums1[i][0] < nums2[j][0]:
                res.append(nums1[i])
                i += 1
            else:
                res.append(nums2[j])
                j += 1
        return res + nums1[i:] + nums2[j:]
```

原本的版本把「其中一邊用完」的情況也寫在同一個 `while` 裡（`while i < n or j < m`，裡面再分三種情況）。改成兩邊都有剩才進迴圈，結束後直接接上剩下的部分，比較短。

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 用 dict 收集再排序：可以，但沒用到「已經排好序」的條件，多了 `O(k log k)`。
- 迴圈結束後忘記接上剩下的部分。

## 面試口說整理

兩個陣列都依 id 排序，所以我用兩個指針合併：id 相同就把值相加、兩邊都前進；不同就輸出比較小的那個並前進。其中一邊用完後，另一邊剩下的直接接上。時間 `O(n + m)`。
