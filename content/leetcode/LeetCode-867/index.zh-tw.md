---
title: "LeetCode 867: Transpose Matrix"
summary: "LeetCode 867 解題筆記：轉置後的大小是 n × m，res[j][i] = matrix[i][j]；Python 可以用 zip(*matrix)"
description: "2022-09-17 的 LeetCode 867 解題紀錄"
date: 2022-09-17
tags: ["easy", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-17
- 提交紀錄：Runtime Error ×2 → Accepted ×3

## 解題思路

轉置就是行列互換（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板一）：`m × n` 的矩陣變成 `n × m`，`res[j][i] = matrix[i][j]`。外層跑新的列數（原本的欄數），內層跑新的欄數（原本的列數）。Python 的 `zip(*matrix)` 剛好是轉置，但每一列是 tuple。

## 我的嘗試

前兩版的兩層迴圈**範圍寫反了**：第一版還把 `matrix[0]`（一個 list）放進 `range`，第二版改成 `len(matrix[0])` 但內外層對調，非正方形時 `[[5, 0]]` 超出範圍。最後用 `zip(*matrix)` 一行 AC。

## 正確解法

```python
class Solution:
    def transpose(self, matrix: List[List[int]]) -> List[List[int]]:
        m, n = len(matrix), len(matrix[0])
        return [[matrix[i][j] for i in range(m)] for j in range(n)]
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`（輸出）。

## 要特別避免的錯誤

- 矩陣不一定是正方形，兩層迴圈的範圍要對應到新的大小。

## 面試口說整理

轉置就是行列互換，我建一個 n × m 的新矩陣，新的第 j 列第 i 欄放原本的第 i 列第 j 欄。時間 `O(mn)`。
