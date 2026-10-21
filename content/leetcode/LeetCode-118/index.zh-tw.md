---
title: "LeetCode 118: Pascal's Triangle"
summary: "LeetCode 118 解題筆記：每一列頭尾是 1，中間每一格是上一列左上和正上方的和"
description: "2022-08-16 的 LeetCode 118 解題紀錄"
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
- 提交紀錄：Accepted ×6

## 解題思路

第 `i` 列有 `i + 1` 個數，頭尾是 1，中間的 `row[j] = prev[j - 1] + prev[j]`（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一）。先開好全部是 1 的列，再填中間。

## 我的解法

```python
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        rows = [[1] * (i + 1) for i in range(numRows)]
        for i in range(2, numRows):
            for j in range(1, i):
                rows[i][j] = rows[i - 1][j - 1] + rows[i - 1][j]
        return rows
```

## 複雜度

時間 `O(n²)`，空間 `O(n²)`（輸出）。

## 要特別避免的錯誤

- 第 `i` 列有 `i + 1` 個數，index 從 0 開始。

## 面試口說整理

每一列頭尾是 1，中間每一格是上一列左上和正上方的和，我先開好全部是 1 的列再填中間。時間 `O(n²)`。
