---
title: "LeetCode 3074: Apple Redistribution into Boxes"
summary: "LeetCode 3074 解題筆記：箱子可以隨便分，所以從容量最大的箱子開始拿，總容量夠裝所有蘋果就停"
description: "2024-03-10 的 LeetCode 3074 解題紀錄"
date: 2024-03-10
tags: ["easy", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-03-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

同一包蘋果可以分到不同箱子，所以只要總容量夠就好。要箱子最少，就從容量最大的開始拿（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一），累積容量 `>=` 蘋果總數時停下。

## 我的嘗試

2024 年比賽時一次 AC，就是排序後由大到小累加。

## 正確解法

```python
class Solution:
    def minimumBoxes(self, apple: List[int], capacity: List[int]) -> int:
        need = sum(apple)
        for i, c in enumerate(sorted(capacity, reverse=True), 1):
            need -= c
            if need <= 0:
                return i
        return len(capacity)
```

## 複雜度

時間 `O(m log m)`，空間 `O(m)`。

## 要特別避免的錯誤

- 蘋果可以拆開放，只看總量。

## 面試口說整理

蘋果可以拆開放，只看總容量，所以我把箱子由大到小排序，一個一個拿，累積容量夠裝所有蘋果就停下來。時間 `O(m log m)`。
