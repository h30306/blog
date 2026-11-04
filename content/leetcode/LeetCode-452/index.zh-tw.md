---
title: "LeetCode 452: Minimum Number of Arrows to Burst Balloons"
summary: "LeetCode 452 解題筆記：按右端點排序，箭射在右端點，左端點大於箭的位置才需要新的一支；端點相接算重疊"
description: "2026-11-03 的 LeetCode 452 解題紀錄"
date: 2026-11-03
tags: ["medium", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

按右端點排序（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板二）。第一支箭射在第一個氣球的**右端點**：越往右射，越有機會同時射到後面的氣球，但不能超過這個氣球的右端點。

接著往後看，氣球的左端點 `<=` 箭的位置就會被這支箭射到；左端點 `>` 箭的位置，就需要新的一支箭，射在這個氣球的右端點。

跟 LC 435 幾乎一樣，差別只在邊界：氣球是閉區間，`[1,2]` 和 `[2,3]` 一支箭射在 2 就能同時射破，所以**端點相接算重疊**，條件是 `>`；LC 435 的端點相接不算重疊，條件是 `>=`。

## 我的嘗試

一次通過。前一題剛寫完 LC 435，把條件從 `>=` 改成 `>` 就好。

## 正確解法

```python
class Solution:
    def findMinArrowShots(self, points: List[List[int]]) -> int:
        points.sort(key=lambda x: x[1])
        arrows, pos = 0, float("-inf")
        for start, end in points:
            if start > pos:           # 目前的箭射不到，射一支新的在右端點
                arrows += 1
                pos = end
        return arrows
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 照抄 LC 435 的 `>=`：`[[1,2],[2,3]]` 會回傳 2，答案是 1。
- 按左端點排序時，遇到重疊要把箭的位置縮成 `min(pos, end)`，否則會射不到右端點比較小的氣球。按右端點排序就不用處理這件事。

## 面試口說整理

我按右端點排序，每支箭都射在目前氣球的右端點，這樣能射到最多後面的氣球。往後掃，左端點不超過箭的位置就會被射到；超過的話就再射一支，射在那個氣球的右端點。端點相接算重疊，所以條件用大於，不是大於等於。時間 `O(n log n)`。
