---
title: "LeetCode 566: Reshape the Matrix"
summary: "LeetCode 566 解題筆記：元素總數不同就回傳原矩陣；否則第 k 個元素放到 (k // c, k % c)"
description: "2022-08-27 的 LeetCode 566 解題紀錄"
date: 2022-08-27
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
第一次嘗試：2022-08-27
- 提交紀錄：Runtime Error ×3 → Wrong Answer → Runtime Error ×3 → Accepted ×2

## 解題思路

把矩陣想成一條按列展開的序列（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板二）：第 `k` 個元素在原矩陣是 `(k // n, k % n)`，在新矩陣是 `(k // c, k % c)`。`m × n != r × c` 時不能重塑，照題目回傳原矩陣。

## 我的嘗試

這題提交了 9 次：

- 前三版語法錯誤；第四版不能重塑時回傳 `False`（題目要回傳原矩陣），而且每 `r` 個切一段、還多包了一層 list。
- 改成回傳原矩陣之後，每一列的長度寫成 `c // r`，`r > c` 時是 0（ValueError）；接著寫成 `mat // r`，list 不能除（TypeError）。最後改成 `len(mat) // r`，也就是 `c`，才 AC。

## 正確解法

```python
class Solution:
    def matrixReshape(self, mat: List[List[int]], r: int, c: int) -> List[List[int]]:
        m, n = len(mat), len(mat[0])
        if m * n != r * c:
            return mat
        res = [[0] * c for _ in range(r)]
        for k in range(m * n):
            res[k // c][k % c] = mat[k // n][k % n]
        return res
```

## 複雜度

時間 `O(mn)`，空間 `O(mn)`（輸出）。

## 要特別避免的錯誤

- 不能重塑時回傳原矩陣，不是 `False`。
- 每一列有 `c` 個元素，切片的長度是 `c`，不是 `r`。

## 面試口說整理

我把矩陣看成按列展開的一條序列，第 k 個元素在原矩陣是 k // n、k % n，在新矩陣是 k // c、k % c；元素總數不同就回傳原矩陣。時間 `O(mn)`。
