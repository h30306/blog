---
title: "LeetCode 561: Array Partition"
summary: "LeetCode 561 解題筆記：排序後相鄰兩個一組，每組的最小值就是偶數位置的數，加總"
description: "2022-08-27 的 LeetCode 561 解題紀錄"
date: 2022-08-27
tags: ["easy", "array", "greedy", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Accepted ×3 → Internal Error → Accepted ×3

## 解題思路

每組貢獻比較小的那個，所以比較大的數要盡量跟另一個大的數一組，才不會浪費（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）。排序後相鄰兩兩配對，答案是 `sorted(nums)[::2]` 的總和。值的範圍小（`-10^4..10^4`），也可以用計數排序。

## 我的嘗試

第一次就 AC 了，同樣的程式碼後來再交一次遇到 LeetCode 的 Internal Error。

## 正確解法

```python
class Solution:
    def arrayPairSum(self, nums: List[int]) -> int:
        return sum(sorted(nums)[::2])
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 取的是排序後**偶數 index** 的元素。

## 面試口說整理

每組只貢獻比較小的那個，所以大的數要跟大的數一組才不浪費。我排序後相鄰兩兩一組，加總每組的第一個，也就是偶數位置的數。時間 `O(n log n)`。
