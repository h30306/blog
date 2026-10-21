---
title: "LeetCode 73: Set Matrix Zeroes"
summary: "LeetCode 73 解題筆記：先記下哪些列、哪些欄有 0，掃完之後再一起改；進階用第一列、第一欄當標記"
description: "2022-10-25 的 LeetCode 73 解題紀錄"
date: 2022-10-25
tags: ["medium", "array", "hash-table", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-25
- 提交紀錄：Wrong Answer → Accepted → Runtime Error ×2 → Accepted ×2

## 解題思路

**不能邊掃邊改**：一改成 0，後面掃到時會以為那裡原本就是 0，結果整列整欄都被擴散。所以先掃一次，記下有 0 的列和欄，第二次再設成 0，`O(m + n)` 空間。`O(1)` 空間的版本是把標記存在第一列和第一欄，另外用一個變數記第一欄本身要不要清零（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板二）。

## 我的嘗試

第一版掃到 0 的時候**馬上把整列改成 0**，同一列後面的格子再被掃到時都變成 0，那些欄也被加進要清零的集合：`[[3, 1], [0, 2]]` 回傳全部是 0，答案 `[[0, 1], [0, 0]]`。改成整列掃完才清零就 AC 了。

## 正確解法

```python
class Solution:
    def setZeroes(self, matrix: List[List[int]]) -> None:
        m, n = len(matrix), len(matrix[0])
        rows = {i for i in range(m) for j in range(n) if matrix[i][j] == 0}
        cols = {j for i in range(m) for j in range(n) if matrix[i][j] == 0}
        for i in range(m):
            for j in range(n):
                if i in rows or j in cols:
                    matrix[i][j] = 0
```

## 複雜度

時間 `O(mn)`，空間 `O(m + n)`。

## 要特別避免的錯誤

- 先全部記錄再修改，邊掃邊改會讓新的 0 被當成原本的 0。

## 面試口說整理

我先掃一次，把有 0 的列和欄記下來，第二次再把這些列和欄設成 0，避免新寫的 0 被誤認成原本的 0。空間 `O(m + n)`；要 `O(1)` 的話可以把標記放在第一列和第一欄。
