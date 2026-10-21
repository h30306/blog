---
title: "LeetCode 766: Toeplitz Matrix"
summary: "LeetCode 766 解題筆記：同一條對角線的元素都相同，等價於每一格都等於左上角那格"
description: "2022-09-06 的 LeetCode 766 解題紀錄"
date: 2022-09-06
tags: ["easy", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-06
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

同一條左上到右下的對角線上，`i - j` 相同（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板三）。所有對角線都是常數，等價於每個 `i, j >= 1` 都有 `matrix[i][j] == matrix[i - 1][j - 1]`，一次掃描就好，也只需要記住上一列，適合進階題「一次只能讀一列」。

## 我的嘗試

前兩版在每一列前面補 `None`，讓對角線變成直的再用 `zip` 取出來，**但每一列補完長度不同，`zip` 會截斷到最短的那一列，有些對角線根本沒比到**；判斷 `None` 的條件也寫錯了，有 `None` 而且只有一種數字時落到了 `elif`：`[[1], [1]]` 回傳 `False`、`[[0, 1], [0, 1], [1, 0]]` 回傳 `True`。改成逐列比對才 AC。

## 正確解法

```python
class Solution:
    def isToeplitzMatrix(self, matrix: List[List[int]]) -> bool:
        return all(matrix[i][j] == matrix[i - 1][j - 1]
                   for i in range(1, len(matrix)) for j in range(1, len(matrix[0])))
```

## 複雜度

時間 `O(mn)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只要比較相鄰的左上角，不需要把對角線整條取出來。

## 面試口說整理

每條對角線都相同，等價於每一格都等於它左上角的那格，所以我掃一次比較就好，只需要上一列。時間 `O(mn)`、空間 `O(1)`。
