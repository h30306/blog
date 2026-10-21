---
title: "LeetCode 54: Spiral Matrix"
summary: "LeetCode 54 解題筆記：維護上下左右四個邊界，依序走右、下、左、上，每走完一邊就把那個邊界往內縮"
description: "2022-10-22 的 LeetCode 54 解題紀錄"
date: 2022-10-22
tags: ["medium", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-22
- 提交紀錄：Wrong Answer ×3 → Runtime Error → Accepted ×3

## 解題思路

維護 `top`、`bottom`、`left`、`right`（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板四）：走完上面一列 `top += 1`，右邊一欄 `right -= 1`，下面一列 `bottom -= 1`，左邊一欄 `left += 1`。走下面和左邊之前要**再檢查一次邊界**，只剩一列或一欄時才不會重複走。

## 我的嘗試

2022-10-22 用「第 `c` 圈」的 index 切片寫，錯了四次：

- **只剩一欄時同一個元素被走了兩次**：`[[3], [6], [1]]` 回傳 `[3, 6, 1, 6]`。
- 第二圈之後的下面一列寫成 `matrix[c]`，**拿到的是上面那一列**反過來，不是 `matrix[-c - 1]`：`[[5, 2], [2, 4], [1, 2], [2, 8]]` 的順序錯了。

一週後改成「拿掉第一列、剩下的逆時針轉 90 度」的寫法（`zip(*matrix)[::-1]`）才 AC。

## 正確解法

```python
class Solution:
    def spiralOrder(self, matrix: List[List[int]]) -> List[int]:
        top, bottom, left, right = 0, len(matrix) - 1, 0, len(matrix[0]) - 1
        res = []
        while top <= bottom and left <= right:
            res += [matrix[top][j] for j in range(left, right + 1)]
            top += 1
            res += [matrix[i][right] for i in range(top, bottom + 1)]
            right -= 1
            if top <= bottom:
                res += [matrix[bottom][j] for j in range(right, left - 1, -1)]
                bottom -= 1
            if left <= right:
                res += [matrix[i][left] for i in range(bottom, top - 1, -1)]
                left += 1
        return res
```

## 複雜度

時間 `O(mn)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 只剩一列或一欄時，下面和左邊不能再走一次。
- 下面那一列是 `bottom`，不是 `top` 那一列反過來。

## 面試口說整理

我維護上下左右四個邊界，依序走上面一列、右邊一欄、下面一列、左邊一欄，每走完一邊就把邊界往內縮，走下面和左邊之前再檢查一次，避免只剩一列時重複。時間 `O(mn)`。
