---
title: "LeetCode 1727: Largest Submatrix With Rearrangements"
summary: "LeetCode 1727 解題筆記：每列算出往上連續 1 的高度，欄可以重排，所以把高度由大到小排序，第 j 高乘上 j + 1"
description: "2026-06-23 的 LeetCode 1727 解題紀錄"
date: 2026-06-23
tags: ["medium", "greedy", "sorting", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

固定子矩陣的**底邊**在第 `i` 列。每一欄往上連續的 1 有 `h[j]` 個（跟「直方圖最大矩形」一樣的高度）。

欄可以任意重排，所以把高的欄排在一起：高度由大到小排序後，取前 `j + 1` 欄，高度受限於第 `j + 1` 高的那欄，面積是 `sorted_h[j] × (j + 1)`。每一列、每個 `j` 取最大。

重排之後不用再管欄的位置，所以不需要單調堆疊，排序就好（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）。

## 我的解法

```python
class Solution:
    def largestSubmatrix(self, matrix: List[List[int]]) -> int:
        n = len(matrix[0])
        h = [0] * n
        best = 0
        for row in matrix:
            for j in range(n):
                h[j] = h[j] + 1 if row[j] else 0
            for j, height in enumerate(sorted(h, reverse=True)):
                best = max(best, height * (j + 1))
        return best
```

我當時直接把高度累加在 `matrix` 裡，這裡改用一個 `h` 陣列，不修改輸入。

## 複雜度

時間 `O(m · n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 遇到 0 時高度要歸零，不是保留。
- 排序的是複製出來的高度，不能打亂 `h` 本身（下一列還要用原本每欄的高度）。

## 面試口說整理

我固定子矩陣的底邊，算出每一欄往上有幾個連續的 1。欄可以重排，所以把高度由大到小排，取前 `j + 1` 欄時高度是第 `j + 1` 高的值，面積是它乘上 `j + 1`。每一列都算一次取最大。時間 `O(m · n log n)`。
