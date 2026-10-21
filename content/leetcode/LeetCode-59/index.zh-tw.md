---
title: "LeetCode 59: Spiral Matrix II"
summary: "LeetCode 59 解題筆記：跟 LC 54 一樣維護四個邊界，只是把讀取換成依序填入 1 到 n²"
description: "2022-10-22 的 LeetCode 59 解題紀錄"
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
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error → Accepted ×2

## 解題思路

跟 LC 54 同樣的四個邊界（[Matrix]({{< relref "/algorithm/Matrix" >}}) 模板四），沿著右、下、左、上的順序，把 `1, 2, ..., n²` 填進去。正方形每一圈都是完整的，但中間剩一格（`n` 是奇數）時一樣要靠邊界檢查處理。

## 我的嘗試

當時用了一個從最大的數往回建的技巧：每次在最上面加一列新的 `range`，再把已經建好的部分順時針轉 90 度。前幾次是起始值算錯（第二版只回傳了 `[[1]]`）和型別錯誤，改對起點才 AC。這個寫法很短但不直覺，上面的邊界模擬比較好解釋。

## 正確解法

```python
class Solution:
    def generateMatrix(self, n: int) -> List[List[int]]:
        res = [[0] * n for _ in range(n)]
        top, bottom, left, right = 0, n - 1, 0, n - 1
        k = 1
        while top <= bottom and left <= right:
            for j in range(left, right + 1):
                res[top][j] = k; k += 1
            top += 1
            for i in range(top, bottom + 1):
                res[i][right] = k; k += 1
            right -= 1
            if top <= bottom:
                for j in range(right, left - 1, -1):
                    res[bottom][j] = k; k += 1
                bottom -= 1
            if left <= right:
                for i in range(bottom, top - 1, -1):
                    res[i][left] = k; k += 1
                left += 1
        return res
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 用 `[[0] * n] * n` 會讓每一列都是同一個 list。

## 面試口說整理

跟 Spiral Matrix 一樣，我維護上下左右四個邊界，依序往右、下、左、上填數字，每填完一邊就把邊界往內縮。時間 `O(n²)`。
