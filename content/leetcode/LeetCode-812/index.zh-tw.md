---
title: "LeetCode 812: Largest Triangle Area"
summary: "LeetCode 812 解題筆記：點最多 50 個，枚舉所有三點組合，用鞋帶公式算面積取最大"
description: "2022-09-07 的 LeetCode 812 解題紀錄"
date: 2022-09-07
tags: ["easy", "array", "math", "geometry", "polygons"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-07
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

點最多 50 個，三點組合約 2 萬組，直接枚舉（[Math]({{< relref "/algorithm/Math" >}}) 模板三）。三角形面積用鞋帶公式（外積）：`|(x2 - x1)(y3 - y1) - (x3 - x1)(y2 - y1)| / 2`。

## 我的嘗試

前兩版想用「外接矩形面積的一半」直接算：

- 第一版取 y 的最大最小值時還拿成了 `[0]`（x 座標），算出負數 `-0.5`。
- 第二版改正座標，但**最大的三角形不一定是外接矩形的一半**：`[[1, 5], [2, 0], [2, 2]]` 的外接矩形一半是 2.5，三角形實際面積只有 1.0。

一週後改成枚舉三點、用鞋帶公式才 AC。

## 正確解法

```python
class Solution:
    def largestTriangleArea(self, points: List[List[int]]) -> float:
        best = 0
        for (x1, y1), (x2, y2), (x3, y3) in combinations(points, 3):
            area = abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)) / 2
            best = max(best, area)
        return best
```

## 複雜度

時間 `O(n³)`，空間 `O(1)`。

## 要特別避免的錯誤

- 最大的三角形不一定是外接矩形的一半，要真的枚舉三個點。
- 外積可能是負的，要取絕對值。

## 面試口說整理

點數很少，我枚舉所有三點組合，用外積算三角形面積，取最大值。時間 `O(n³)`，n 最多 50。
