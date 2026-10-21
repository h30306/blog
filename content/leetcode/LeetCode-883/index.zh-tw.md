---
title: "LeetCode 883: Projection Area of 3D Shapes"
summary: "LeetCode 883 解題筆記：俯視是非 0 的格子數，正視和側視分別是每一列、每一欄的最大值總和"
description: "2022-09-21 的 LeetCode 883 解題紀錄"
date: 2022-09-21
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
第一次嘗試：2022-09-21
- 提交紀錄：Runtime Error ×4 → Wrong Answer ×2 → Accepted

## 解題思路

三個方向的投影面積（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板三）：

- 從上面看：每個 `grid[i][j] > 0` 的格子貢獻 1。
- 從前面看：每一欄最高的那個。
- 從側面看：每一列最高的那個。

## 我的嘗試

前幾次是變數和型別的 RE。接著兩版把所有數字接成字串、**數字元 `'0'` 的個數**來扣掉空的格子，但只要有空格，`10`、`20` 這種數裡的 `'0'` 也會被數進去：`[[0, 10]]` 答案 21，回傳 20。改成 `grid[i][j] > 0` 才 AC。

## 正確解法

```python
class Solution:
    def projectionArea(self, grid: List[List[int]]) -> int:
        top = sum(v > 0 for row in grid for v in row)
        side = sum(max(row) for row in grid)
        front = sum(max(col) for col in zip(*grid))
        return top + side + front
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 俯視要數**非 0 的格子**，不能用字串數字元 `'0'`。

## 面試口說整理

俯視面積是非 0 的格子數，正視和側視分別是每一欄和每一列的最大值加總，三個加起來。時間 `O(n²)`。
