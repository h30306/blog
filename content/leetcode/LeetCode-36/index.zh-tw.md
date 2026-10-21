---
title: "LeetCode 36: Valid Sudoku"
summary: "LeetCode 36 解題筆記：每個數字在列、欄、3 × 3 宮格各只能出現一次；用 (數字, 列)、(數字, 欄)、(數字, 宮格) 當 key 放進同一個集合"
description: "2022-10-21 的 LeetCode 36 解題紀錄"
date: 2022-10-21
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
第一次嘗試：2022-10-21
- 提交紀錄：Runtime Error ×5 → Accepted → Wrong Answer ×3 → Accepted → Runtime Error ×3 → Accepted ×3

## 解題思路

只檢查已經填的格子，不用判斷有沒有解。每個數字產生三個 key：`(d, 'r', i)`、`(d, 'c', j)`、`(d, 'b', i // 3, j // 3)`，任何一個重複出現就不合法（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。宮格的編號是 `(i // 3, j // 3)`。

## 我的嘗試

這題 2022-10 和 2022-11 寫了兩次，錯了 11 次：

- 一開始寫成檢查列、欄、宮格三個 helper，幾次 RE 之後 AC。
- 接著想改成「把 key 放進同一個集合」的寫法，但**只放了列和欄，忘了 3 × 3 宮格**：同一個宮格裡兩個相同的數字（不同列也不同欄）沒被抓到，回傳 `True`。
- 2022-11 重寫時加上 `(數字, (i // 3, j // 3))` 這個 key 才 AC。

## 正確解法

```python
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        seen = set()
        for i in range(9):
            for j in range(9):
                d = board[i][j]
                if d == ".":
                    continue
                for key in ((d, "r", i), (d, "c", j), (d, "b", i // 3, j // 3)):
                    if key in seen:
                        return False
                    seen.add(key)
        return True
```

## 複雜度

時間 `O(81)`，空間 `O(81)`。

## 要特別避免的錯誤

- 3 × 3 宮格也要檢查。
- 列和欄的 key 要能區分，`(d, i)` 和 `(i, d)` 這種位置互換的寫法可以，但加上標籤比較清楚。

## 面試口說整理

每個已填的數字在列、欄和三乘三的宮格各只能出現一次，我把數字和它所在的列、欄、宮格編號組成三個 key 放進同一個集合，重複就不合法。宮格編號是 i // 3、j // 3。
