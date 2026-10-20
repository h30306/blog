---
title: "LeetCode 3643: Flip Square Submatrix Vertically"
summary: "LeetCode 3643 解題筆記：只翻轉子矩陣的上下列，第 x + i 列和第 x + k - 1 - i 列的那一段互換"
description: "2025-08-10 的 LeetCode 3643 解題紀錄"
date: 2025-08-10
tags: ["easy", "two-pointers", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-08-10
- 提交紀錄：Wrong Answer → Accepted → Accepted（2026-01-24 重打）

## 解題思路

子矩陣的左上角是 `(x, y)`、邊長 `k`。上下翻轉就是：子矩陣的第 `i` 列和倒數第 `i` 列互換，但**只換 `y` 到 `y + k - 1` 這一段**，矩陣其他部分不動。

用對撞指針：上面的列從 `x` 往下、下面的列從 `x + k - 1` 往上，交換 `k // 2` 次。

## 我的嘗試：用整個矩陣的最後一列

```python
for i in range(x, x + (len(grid) - x) // 2):
    grid[i][y:y + k], grid[-1][y:y + k] = grid[-1][y:y + k], grid[i][y:y + k]
```

兩個錯誤：

1. 下面那列寫成 `grid[-1]`，是**整個矩陣**的最後一列，而且每一次都是同一列，不會隨 `i` 往上移。
2. 次數用整個矩陣剩下的列數算，而不是子矩陣的邊長 `k`。

例如 4 列的矩陣，`x = 2`、`k = 1`：子矩陣只有一格，應該完全不變；這一版卻把第 2 列的那一格跟最後一列交換了。

## 正確解法

```python
class Solution:
    def reverseSubmatrix(self, grid: List[List[int]], x: int, y: int, k: int) -> List[List[int]]:
        top, bottom = x, x + k - 1
        while top < bottom:
            grid[top][y:y + k], grid[bottom][y:y + k] = grid[bottom][y:y + k], grid[top][y:y + k]
            top += 1
            bottom -= 1
        return grid
```

切片賦值 `grid[top][y:y + k] = ...` 只換掉這一列的那一段，其他欄不受影響。

## 複雜度

時間 `O(k^2)`，空間 `O(k)`（切片會複製一段）。

## 要特別避免的錯誤

- 用 `grid[-1]` 當子矩陣的最後一列。
- 交換整列而不是只換 `y` 到 `y + k - 1` 這一段。

## 面試口說整理

我用兩個指針指向子矩陣的第一列和最後一列，也就是 `x` 和 `x + k - 1`，交換這兩列在 `y` 到 `y + k - 1` 的那一段，再往中間靠，總共交換 `k // 2` 次。時間 `O(k^2)`。
