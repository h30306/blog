---
title: "LeetCode 2145: Count the Hidden Sequences"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-21
tags: ["LeetCode", "blog", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-04-21
- 總花費時間：20:00.00

## 解題思路

隱藏的序列必須落在 `minK` 和 `maxK` 的範圍內。  
因此，我們可以遍歷 `differences` 陣列，記錄累加結果 (`now`) 的最小值和最大值。  
最終可以透過移動這個範圍到 `[lower, upper]` 中來計算可能的隱藏序列數量。

## 解法

```python
class Solution:
    def numberOfArrays(self, differences: List[int], lower: int, upper: int) -> int:
        min_, max_ = 0, 0
        now = 0
        for diff in differences:
            now += diff
            min_ = min(now, min_)
            max_ = max(now, max_)
            if max_ - min_ > upper - lower:
                return 0

        bound = max_ - min_

        return upper - lower - bound + 1
```

## 收穫

NA

## 遇到的問題

一開始，我將 `min_` 和 `max_` 初始化為 `float("inf")` 和 `float("-inf")`。  
我以為遍歷完 `differences` 後就能正確得到最小值和最大值。  
但我忽略了只有一個元素的邊界情況。  
例如，當 `differences = [-40]` 時，`min_` 和 `max_` 都會是 `-40`，  
但這其實是一個差分陣列，真正的範圍應該是從 `0` 到 `-40`。  
所以我將初始化改為 `min_ = max_ = 0`，以正確處理這種測資。