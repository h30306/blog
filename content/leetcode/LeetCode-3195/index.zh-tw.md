---
title: "LeetCode 3195: Find the Minimum Area to Cover All Ones I"
summary: "LeetCode 3195 解題筆記：記錄 1 出現的最上、最下、最左、最右位置，矩形面積就是高乘寬"
description: "2025-08-22 的 LeetCode 3195 解題紀錄"
date: 2025-08-22
tags: ["medium", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

矩形的邊要平行格線，要包住所有的 1，最小的就是剛好貼著最外圍的 1（[Array]({{< relref "/algorithm/Array" >}}) 模板五）：上邊是最上面那個 1 的列，下邊是最下面的列，左右同理。面積是 `(max_r - min_r + 1) × (max_c - min_c + 1)`。

## 我的解法

```python
class Solution:
    def minimumArea(self, grid: List[List[int]]) -> int:
        rows = [i for i, row in enumerate(grid) if 1 in row]
        cols = [j for j in range(len(grid[0])) if any(row[j] for row in grid)]
        return (rows[-1] - rows[0] + 1) * (cols[-1] - cols[0] + 1)
```

我當時用兩層迴圈逐格更新四個邊界，跑了將近 3 秒；這裡改成先找有 1 的列、再找有 1 的欄，`1 in row` 是內建的掃描，比較快。

## 複雜度

時間 `O(m · n)`，空間 `O(m + n)`。

## 要特別避免的錯誤

- 邊界是包含的，高和寬都要加 1。

## 面試口說整理

最小的矩形剛好貼著最外圍的 1，所以我找出有 1 的最上、最下列和最左、最右欄，相減加 1 再相乘。時間 `O(mn)`。
