---
title: "LeetCode 1051: Height Checker"
summary: "LeetCode 1051 解題筆記：排序後跟原本的陣列逐一比較，數有幾個位置不同"
description: "2022-09-30 的 LeetCode 1051 解題紀錄"
date: 2022-09-30
tags: ["easy", "array", "sorting", "counting-sort", "bubble-sort"]
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

期望的順序就是排序後的陣列，比較兩個陣列有幾個位置不同。高度只有 `1..100`，也可以用計數排序做到 `O(n + 100)`（[Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})）。

## 我的解法

```python
class Solution:
    def heightChecker(self, heights: List[int]) -> int:
        return sum(a != b for a, b in zip(heights, sorted(heights)))
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用 `sorted` 產生新的陣列，不要原地排序原本的。

## 面試口說整理

期望的順序就是排序後的結果，我把排序後的陣列跟原本的逐一比較，數不同的位置。時間 `O(n log n)`，用計數排序可以到線性。
