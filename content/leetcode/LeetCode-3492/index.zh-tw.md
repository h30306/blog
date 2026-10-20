---
title: "LeetCode 3492: Maximum Containers on a Ship"
summary: "LeetCode 3492 解題筆記：最多 n² 個格子，重量最多放 maxWeight // w 個，取兩者較小值；用整數除法"
description: "2025-03-23 的 LeetCode 3492 解題紀錄"
date: 2025-03-23
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-03-23
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

兩個上限取較小的：

- 格子數：`n × n`。
- 重量：每個貨櫃 `w`，最多 `maxWeight // w` 個（無條件捨去）。

## 我的嘗試

第一版用 `maxWeight / w`，回傳的是浮點數。例如 `n = 2`、`w = 3`、`maxWeight = 7`：答案是 2，回傳 `2.333...`。改成 `int(...)` 就 AC 了；直接用 `//` 更清楚。

## 正確解法

```python
class Solution:
    def maxContainers(self, n: int, w: int, maxWeight: int) -> int:
        return min(n * n, maxWeight // w)
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- Python 3 的 `/` 是浮點除法，數量要用 `//`。

## 面試口說整理

能放的數量同時受格子數 `n²` 和重量限制 `maxWeight // w` 限制，取兩者較小的。時間 `O(1)`。
