---
title: "LeetCode 74: Search a 2D Matrix"
summary: "LeetCode 74 解題筆記：每列接上一列是完整排序的，把矩陣當成長度 m × n 的一維陣列二分，mid 換成 (mid // n, mid % n)"
description: "2022-10-25 的 LeetCode 74 解題紀錄"
date: 2022-10-25
tags: ["medium", "array", "binary-search", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-25
- 提交紀錄：Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×3 → Runtime Error ×4 → Wrong Answer → Runtime Error ×3 → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted ×2 → Runtime Error → Time Limit Exceeded → Runtime Error → Accepted → Runtime Error → Accepted ×3

## 解題思路

每一列由小到大，而且每列的開頭比上一列的結尾大，所以整個矩陣攤平就是一個排序好的陣列（[Binary Search]({{< relref "/algorithm/Binary-Search" >}}) 模板一）。在 `[0, m·n - 1]` 上二分，index `mid` 對應到 `matrix[mid // n][mid % n]`。

## 我的嘗試

這題 2022 年提交了 34 次，是這批裡最多的：

- 一開始先找列再找欄，條件用了嚴格的 `>`，目標剛好是某一列的第一個時找不到。例如 `[[1], [15]]`、`target = 1` 回傳 `False`。
- 改成攤平二分之後，好幾版 `mid = (low + high) / 2` 得到浮點數（TypeError）；也有幾版變數沒定義、index 超出範圍。

## 正確解法

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        m, n = len(matrix), len(matrix[0])
        l, r = 0, m * n - 1
        while l <= r:
            mid = (l + r) // 2
            v = matrix[mid // n][mid % n]
            if v == target:
                return True
            if v < target:
                l = mid + 1
            else:
                r = mid - 1
        return False
```

## 複雜度

時間 `O(log(m · n))`，空間 `O(1)`。

## 要特別避免的錯誤

- 換算座標除以的是**欄數** `n`。
- `mid` 要用整數除法。

## 面試口說整理

矩陣攤平後是排序好的，所以我直接在 `0` 到 `m·n - 1` 之間二分，把 `mid` 換成列 `mid // n`、欄 `mid % n`。時間 `O(log(mn))`。
