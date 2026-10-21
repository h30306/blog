---
title: "LeetCode 48: Rotate Image"
summary: "LeetCode 48 解題筆記：順時針轉 90 度 = 先轉置再把每一列左右反轉，兩步都可以原地做"
description: "2022-10-31 的 LeetCode 48 解題紀錄"
date: 2022-10-31
tags: ["medium", "array", "math", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-31
- 提交紀錄：Runtime Error ×2 → Accepted ×3

## 解題思路

順時針旋轉 90 度後，原本的 `(i, j)` 跑到 `(j, n - 1 - i)`。拆成兩步（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板一）：

1. 轉置：交換 `matrix[i][j]` 和 `matrix[j][i]`（只交換 `j > i` 的那一半）。
2. 每一列左右反轉。

兩步都只用交換，額外空間 `O(1)`。逆時針則是轉置後上下反轉。

## 我的嘗試

前兩次是參數名稱用錯（`A`，NameError），之後的 AC 都是 `matrix[:] = zip(*matrix[::-1])`：先上下反轉再轉置，一行就好，**但這其實建了一份新的矩陣**，不是題目要的原地旋轉。上面的寫法才是真的 `O(1)` 空間。

## 正確解法

```python
class Solution:
    def rotate(self, matrix: List[List[int]]) -> None:
        n = len(matrix)
        for i in range(n):
            for j in range(i + 1, n):
                matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
        for row in matrix:
            row.reverse()
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 轉置時只交換一半（`j > i`），全部交換會換回原樣。
- `matrix[:] = zip(*matrix[::-1])` 雖然能過，但會建新的列（而且每一列是 tuple），不算真正的原地。

## 面試口說整理

順時針轉 90 度等於先轉置再把每一列反轉。轉置時我只交換對角線一邊的元素，接著每一列原地反轉，額外空間 `O(1)`。
