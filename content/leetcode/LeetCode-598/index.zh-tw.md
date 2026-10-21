---
title: "LeetCode 598: Range Addition II"
summary: "LeetCode 598 解題筆記：每次操作都包含左上角，被加最多次的是所有操作的交集：min(a) × min(b)"
description: "2022-08-28 的 LeetCode 598 解題紀錄"
date: 2022-08-28
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-28
- 提交紀錄：Wrong Answer → Accepted ×3 → Runtime Error ×2 → Accepted ×2

## 解題思路

每次操作都是從 `(0, 0)` 開始的矩形，所以被**所有**操作都加到的格子就是最大值，也就是所有矩形的交集：列數取 `min(a)`、行數取 `min(b)`，兩者**分開**取最小值再相乘（[Math]({{< relref "/algorithm/Math" >}}) 模板四）。沒有操作時整個矩陣都是 0，答案是 `m × n`。

## 我的嘗試

第一版在列和行的最小值不同時回傳 `min(min_row, min_column) ** 2`，**把交集當成正方形**：`m = 4`、`n = 1`、`ops = [[2, 1]]` 答案 2，回傳 1。之後兩版 RE（變數名稱錯誤、型別錯誤），改成兩者相乘就 AC 了。

## 正確解法

```python
class Solution:
    def maxCount(self, m: int, n: int, ops: List[List[int]]) -> int:
        for a, b in ops:
            m, n = min(m, a), min(n, b)
        return m * n
```

## 複雜度

時間 `O(k)`（`k` 是操作數），空間 `O(1)`。

## 要特別避免的錯誤

- 交集不一定是正方形，列和行各自取最小值。
- 沒有操作時答案是 `m × n`。

## 面試口說整理

每次操作都包含左上角，所以被加最多次的格子是所有操作的交集，我分別取列數和行數的最小值相乘；沒有操作時把 m、n 當成初始值就自然是 m × n。時間 `O(k)`。
