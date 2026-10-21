---
title: "LeetCode 1030: Matrix Cells in Distance Order"
summary: "LeetCode 1030 解題筆記：列出所有座標，按到中心的曼哈頓距離排序；回傳的是座標，不是距離"
description: "2022-09-30 的 LeetCode 1030 解題紀錄"
date: 2022-09-30
tags: ["easy", "array", "math", "geometry", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-30
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×5 → Accepted ×3 → Runtime Error → Accepted

## 解題思路

所有格子最多 `100 × 100` 個，直接列出座標，用 `abs(i - r0) + abs(j - c0)` 當 key 排序。距離最多 `rows + cols`，也可以用計數排序或從中心 BFS 做到 `O(rows × cols)`（[Sorting]({{< relref "/algorithm/Sorting" >}})）。

## 我的嘗試

這題提交了 12 次，主要是**回傳了距離而不是座標**：把每格換成 `[|r0 - i|, |c0 - j|]` 之後再排序，排序的 key 也試了 `len`（每個都是 2，等於沒排）和 `sum` 加 `reverse=True`（方向反了）。最後改成座標本身、用距離當 key 才 AC。

## 正確解法

```python
class Solution:
    def allCellsDistOrder(self, rows: int, cols: int, rCenter: int, cCenter: int) -> List[List[int]]:
        cells = [[i, j] for i in range(rows) for j in range(cols)]
        cells.sort(key=lambda p: abs(p[0] - rCenter) + abs(p[1] - cCenter))
        return cells
```

## 複雜度

時間 `O(RC log(RC))`，空間 `O(RC)`。

## 要特別避免的錯誤

- 回傳座標，排序的 key 才是距離。
- 距離是兩個差的絕對值相加，`key=len` 或 `key=sum` 都不是。

## 面試口說整理

我列出所有格子的座標，用到中心的曼哈頓距離當 key 排序。格子最多一萬個，排序就夠快；也可以用計數排序或從中心 BFS 做到線性。
