---
title: "LeetCode 892: Surface Area of 3D Shapes"
summary: "LeetCode 892 解題筆記：每疊 v 個方塊有 4v + 2 個面，再扣掉跟上方和左方相鄰的疊重疊的 2 × min 面"
description: "2022-09-24 的 LeetCode 892 解題紀錄"
date: 2022-09-24
tags: ["easy", "array", "math", "geometry", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-24
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

單獨一疊 `v > 0` 個方塊，表面積是上下各 1 加四周 `4v`。相鄰的兩疊會互相遮住 `min(a, b)` 個面，兩邊各少一個，所以減掉 `2 × min(a, b)`（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板三）。每格只跟上方、左方比，就不會重複扣。

## 我的嘗試

- 第一版用「三個方向的投影面積乘以 2」，**凹進去的面沒算到**：`[[1, 3, 2], [3, 1, 0], [2, 1, 2]]` 回傳 48，答案 54。
- 改成沿著每一列、每一欄累加「比前一個高出多少」之後，欄的方向加的是前一個的高度 `std`，不是差值：`[[3]]` 回傳 8，答案 14。改成加 `row[i] - std` 就 AC 了。

## 正確解法

```python
class Solution:
    def surfaceArea(self, grid: List[List[int]]) -> int:
        n = len(grid)
        area = 0
        for i in range(n):
            for j in range(n):
                v = grid[i][j]
                if v:
                    area += 4 * v + 2
                if i:
                    area -= 2 * min(v, grid[i - 1][j])
                if j:
                    area -= 2 * min(v, grid[i][j - 1])
        return area
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 表面積不是投影面積的兩倍，凹進去的面也算。
- 每對相鄰的疊只扣一次，只看上方和左方。

## 面試口說整理

每疊 v 個方塊本身有 4v + 2 個面，相鄰兩疊會互相遮住較矮那疊的高度，兩邊都少，所以減掉兩倍。我每格只跟上方和左方比，避免重複扣。時間 `O(n²)`。
