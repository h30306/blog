---
title: "LeetCode 240: Search a 2D Matrix II"
summary: "LeetCode 240 解題筆記：從右上角開始，比目標大就往左、比目標小就往下，每一步排除一整列或一整欄"
description: "2022-11-12 的 LeetCode 240 解題紀錄"
date: 2022-11-12
tags: ["medium", "array", "binary-search", "divide-and-conquer", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-12
- 提交紀錄：Accepted ×2 → Runtime Error ×2 → Accepted → Runtime Error → Accepted → Wrong Answer ×2 → Accepted

## 解題思路

每列由左到右遞增、每欄由上到下遞增，但列和列之間沒有接續，不能攤平。從**右上角**開始（[Binary Search]({{< relref "/algorithm/Binary-Search" >}})）：

- 目前的值比目標大：這一欄下面都更大，往左。
- 比目標小：這一列左邊都更小，往下。

每一步排除一欄或一列，最多走 `m + n` 步。

## 我的嘗試

2022 年第一次 AC 的版本開頭寫了 `if not matrix or not target: return False`，`target` 是 0 時會直接回傳 `False`，只是測資沒測到。2026 年重寫時想先往右走到底、再往下走到底，但一路走下去會錯過答案，例如 `[[1, 1, 3], [4, 7, 8]]`、`target = 7`：答案 `True`，回傳 `False`。

## 正確解法

```python
class Solution:
    def searchMatrix(self, matrix: List[List[int]], target: int) -> bool:
        i, j = 0, len(matrix[0]) - 1
        while i < len(matrix) and j >= 0:
            v = matrix[i][j]
            if v == target:
                return True
            if v > target:
                j -= 1
            else:
                i += 1
        return False
```

## 複雜度

時間 `O(m + n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 要從右上角（或左下角）開始，這兩個角的兩個方向一個變大、一個變小。
- `target` 可能是 0，不能用 `not target` 判斷參數。

## 面試口說整理

我從右上角開始，比目標大就往左、比目標小就往下，每一步排除一欄或一列，走出邊界還沒找到就是不存在。時間 `O(m + n)`。
