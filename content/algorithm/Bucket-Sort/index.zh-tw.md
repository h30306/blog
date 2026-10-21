---
title: "Bucket Sort 桶子與鴿籠原理"
summary: "把值域切成 n - 1 個桶子，最大間距一定不會落在同一個桶子裡，所以每個桶子只要記最小值和最大值，就能線性時間找出排序後的最大相鄰差"
description: "演算法學習"
date: 2026-10-21
tags: ["bucket-sort", "pigeonhole-principle", "sorting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

比較排序最快是 `O(n log n)`。如果只需要排序結果的**某個性質**，不一定要真的排序。桶子的想法是：把值域切成幾段，同一段的放在一起，只保留需要的資訊（例如每段的最小值和最大值）。

開一個跟值域一樣大的陣列（計數排序）在值域很大時會用掉太多記憶體，桶子的數量則只跟 `n` 有關。

## 模板：最大相鄰差（鴿籠原理）

`n` 個數、範圍 `[lo, hi]`，排序後有 `n - 1` 個相鄰差，總和是 `hi - lo`，所以**最大的差至少是 `ceil((hi - lo) / (n - 1))`**。把桶子寬度設成這個值以下，同一個桶子裡的差就一定比最大差小，最大差一定出現在**相鄰兩個非空桶子之間**：

```python
lo, hi = min(nums), max(nums)
if lo == hi:
    return 0
n = len(nums)
size = max(1, (hi - lo) // (n - 1))      # 桶子寬度不超過平均間距
count = (hi - lo) // size + 1
bmin = [None] * count
bmax = [None] * count
for x in nums:
    b = (x - lo) // size
    bmin[b] = x if bmin[b] is None else min(bmin[b], x)
    bmax[b] = x if bmax[b] is None else max(bmax[b], x)
best, prev = 0, lo
for b in range(count):
    if bmin[b] is not None:
        best = max(best, bmin[b] - prev)  # 這個桶子的最小值 - 前一個非空桶子的最大值
        prev = bmax[b]
return best
```

- **最大間距**（LC 164）：上面的程式，`O(n)`。

## 主要參數說明

- `size` 要 `<= (hi - lo) / (n - 1)`，同一桶子裡的差才會小於最大差；用整數除法再跟 1 取最大值。
- 第一個桶子一定有 `lo`、最後一個一定有 `hi`。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **開一個跟值域一樣大的陣列**：值可以到 `10^9`，Memory Limit Exceeded（LC 164）。
- **直接排序**：可以過，但題目要求線性時間（LC 164）。

## 相關 LeetCode

- `LC 164` Maximum Gap
