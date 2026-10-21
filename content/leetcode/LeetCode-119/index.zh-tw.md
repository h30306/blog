---
title: "LeetCode 119: Pascal's Triangle II"
summary: "LeetCode 119 解題筆記：只要第 rowIndex 列，用一維陣列從右往左更新，空間 O(k)"
description: "2022-08-16 的 LeetCode 119 解題紀錄"
date: 2022-08-16
tags: ["easy", "array", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-16
- 提交紀錄：Wrong Answer ×2 → Accepted ×2 → Runtime Error → Wrong Answer → Runtime Error → Accepted ×7

## 解題思路

只要一列的話不用存整個三角形：用一個陣列 `row`，每往下一列就在尾端補 1，然後**從右往左**做 `row[j] += row[j - 1]`（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。從右往左是因為 `row[j - 1]` 還是上一列的值；從左往右會用到這一列已經更新過的值。注意 `rowIndex` 從 0 開始，第 `k` 列有 `k + 1` 個數。

## 我的嘗試

- 第一版照 LC 118 建三角形，但只建了 `rowIndex` 列，**`rowIndex` 是從 0 開始的**，回傳的是上一列：`rowIndex = 5` 回傳 `[1, 4, 6, 4, 1]`。
- 之後試了組合數公式 `ans[i] = ans[i - 1] * up / down`：參數名稱用錯（NameError）、`/` 得到浮點數被判 WA、`map(ans, int)` 參數順序寫反（TypeError），改成 `//` 就 AC 了。

## 正確解法

```python
class Solution:
    def getRow(self, rowIndex: int) -> List[int]:
        row = [1]
        for _ in range(rowIndex):
            row.append(1)
            for j in range(len(row) - 2, 0, -1):
                row[j] += row[j - 1]
        return row
```

## 複雜度

時間 `O(k²)`，空間 `O(k)`。

## 要特別避免的錯誤

- `rowIndex` 從 0 開始，要建 `rowIndex + 1` 列。
- 一維更新要從右往左。
- 用組合數公式 `C(k, i)` 時要用整數除法，`/` 會變成浮點數。

## 面試口說整理

我只用一個陣列，每往下一列就在尾端補 1，再從右往左把每一格加上左邊那格，這樣用到的都是上一列的值，空間 `O(k)`。也可以用組合數 C(k, i) 逐項推。
