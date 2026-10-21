---
title: "LeetCode 3898: Find the Degree of Each Vertex"
summary: "LeetCode 3898 解題筆記：鄰接矩陣第 i 列的 1 的個數就是頂點 i 的度數"
description: "2026-04-12 的 LeetCode 3898 解題紀錄"
date: 2026-04-12
tags: ["easy", "graph", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

鄰接矩陣裡 `matrix[i][j] = 1` 代表 `i` 和 `j` 之間有邊，所以頂點 `i` 的度數就是第 `i` 列的總和。無向圖的矩陣是對稱的，我當時加的是每一欄，結果一樣。

## 我的解法

```python
class Solution:
    def findDegrees(self, matrix: List[List[int]]) -> List[int]:
        return [sum(row) for row in matrix]
```

## 複雜度

時間 `O(n²)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 如果是有向圖，列的總和是出度、欄的總和是入度，就不能混用。

## 面試口說整理

鄰接矩陣的第 `i` 列記錄 `i` 跟誰相連，所以把每一列加總就是度數。時間 `O(n²)`。
