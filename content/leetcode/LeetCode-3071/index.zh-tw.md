---
title: "LeetCode 3071: Minimum Operations to Write the Letter Y on a Grid"
summary: "LeetCode 3071 解題筆記：分別數 Y 上和 Y 外每個值的次數，枚舉 Y 的值 a 和背景的值 b（a != b），取最少要改的格子數"
description: "2024-03-03 的 LeetCode 3071 解題紀錄"
date: 2024-03-03
tags: ["medium", "array", "hash-table", "matrix", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-03-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

Y 由三段組成：左上到中心、右上到中心、中心到最下面（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板三）。先數 Y 上和 Y 外 0、1、2 各有幾個（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），再枚舉 9 種 `(a, b)` 中 `a != b` 的 6 種，要改的格子數是 `Y 的總數 - Y 上值為 a 的個數 + 背景總數 - 背景值為 b 的個數`。

## 我的嘗試

一次 AC。

## 正確解法

```python
class Solution:
    def minimumOperationsToWriteY(self, grid: List[List[int]]) -> int:
        n = len(grid)
        mid = n // 2
        on, off = [0] * 3, [0] * 3
        for i in range(n):
            for j in range(n):
                in_y = (i <= mid and (j == i or j == n - 1 - i)) or (i >= mid and j == mid)
                (on if in_y else off)[grid[i][j]] += 1
        total_on, total_off = sum(on), sum(off)
        return min(total_on - on[a] + total_off - off[b]
                   for a in range(3) for b in range(3) if a != b)
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 中心點屬於三段，只能算一次。
- Y 和背景的值必須不同。

## 面試口說整理

我先分別數 Y 上和 Y 外每個值的次數，再枚舉 Y 的值和背景的值兩兩不同的六種組合，要改的就是兩邊不等於目標值的格子數，取最小。時間 `O(n²)`。
