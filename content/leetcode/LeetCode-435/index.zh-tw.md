---
title: "LeetCode 435: Non-overlapping Intervals"
summary: "LeetCode 435 解題筆記：最少刪幾個 = 總數減掉最多能保留幾個；按右端點排序，貪心保留結束最早的"
description: "2022-11-16 的 LeetCode 435 解題紀錄"
date: 2022-11-16
tags: ["medium", "array", "dynamic-programming", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-16
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted

## 解題思路

要刪最少，就是保留最多互不重疊的區間（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板二）。按右端點排序，從左到右，左端點 `>=` 上一個保留的右端點就保留，否則刪掉。保留結束最早的，給後面留最多空間。

按左端點排序也可以：遇到重疊時刪掉其中一個，**保留右端點比較小的**（`end = min(end, b)`）。

## 我的嘗試

這題用「按左端點排序」寫：

- 2022-11-16 第一版遇到重疊時保留了右端點比較**大**的（`max`），應該留比較小的，才能讓後面的區間少撞到。改成 `min` 就 AC 了。
- 2022-11-27 重寫時，重疊後沒有更新右端點，而且初始值設成 `[0, 0]`，左端點是負數時會出錯；錯了四次才改回正確的寫法。

## 正確解法

```python
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: x[1])
        end, kept = float("-inf"), 0
        for a, b in intervals:
            if a >= end:
                kept += 1
                end = b
        return len(intervals) - kept
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 只碰到端點不算重疊，用 `>=`。
- 按左端點排序時，重疊後要保留比較短的那個（右端點取 `min`），不是 `max`。

## 面試口說整理

刪最少等於保留最多不重疊的區間，我按右端點排序，左端點不小於上一個保留的右端點就保留，最後用總數減掉保留數。保留結束最早的，給後面最多空間。時間 `O(n log n)`。
