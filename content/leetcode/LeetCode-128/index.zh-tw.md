---
title: "LeetCode 128: Longest Consecutive Sequence"
summary: "LeetCode 128 解題筆記：放進 set，只從「x - 1 不在 set 裡」的數開始往上數，每個數最多被看兩次，O(n)"
description: "2022-10-27 的 LeetCode 128 解題紀錄"
date: 2022-10-27
tags: ["medium", "array", "hash-table", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-27
- 提交紀錄：Wrong Answer ×11 → Accepted ×3

## 解題思路

題目要求 `O(n)`，不能排序。把所有數放進集合（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），一個數 `x` 只有在 `x - 1` 不在集合裡時才是一段連續數字的**起點**，從它往上數 `x + 1, x + 2, ...`。每個數只會被當成起點一次、被往上數到一次，總共 `O(n)`。集合也順便去掉了重複。

## 我的嘗試

這題提交了 14 次，都是「排序後找連續」的版本（不符合 `O(n)` 的要求）：

- 一開始判斷連續的公式和起始值有錯，`[7]` 回傳 0。
- 修好之後，長度直接寫成 `max_length = end - start + 1`，**後面比較短的一段會覆蓋前面比較長的**：`[4, 5, 7, 8, 3, 0]` 排序後 `3, 4, 5` 長度 3，但回傳 2。
- **重複的數**沒有處理：`[4, 3, 3]` 回傳 3，答案 2。最後用一個 `dup` 計數器扣掉重複、長度取 `max` 才 AC。

## 正確解法

```python
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        s = set(nums)
        best = 0
        for x in s:
            if x - 1 not in s:
                y = x
                while y + 1 in s:
                    y += 1
                best = max(best, y - x + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只從起點往上數，否則每個數都往上數會變成 `O(n²)`。
- 要在集合上跑迴圈，重複的數只算一次。
- 排序是 `O(n log n)`，不符合題目要求；排序版本還要處理重複的數，而且長度要取 `max`，不能直接覆蓋。

## 面試口說整理

我把所有數放進集合，只有 x - 1 不在集合裡的數才是一段連續數字的起點，從起點往上數到斷掉為止，記錄最長的長度。每個數最多被看兩次，時間 `O(n)`。
