---
title: "LeetCode 2335: Minimum Amount of Time to Fill Cups"
summary: "LeetCode 2335 解題筆記：答案是 max(最多的那種, ceil(總數 / 2))；模擬的話每秒從最多的兩種各裝一杯"
description: "2022-11-22 的 LeetCode 2335 解題紀錄"
date: 2022-11-22
tags: ["easy", "array", "greedy", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

每秒最多裝兩杯而且必須不同種類，所以兩個下限：至少 `ceil(總數 / 2)` 秒；而最多的那種一秒只能裝一杯，至少 `max(amount)` 秒。貪心地每次從最多的兩種各裝一杯（用 max-heap 模擬，[Greedy]({{< relref "/algorithm/Greedy" >}})），能剛好達到兩個下限中比較大的那個。

## 我的嘗試

一次 AC，就是上面這個公式。

## 正確解法

```python
class Solution:
    def fillCups(self, amount: List[int]) -> int:
        return max(max(amount), (sum(amount) + 1) // 2)
```

## 複雜度

時間 `O(1)`，空間 `O(1)`。

## 要特別避免的錯誤

- 兩個下限都要考慮，取比較大的。

## 面試口說整理

每秒最多兩杯而且要不同種，所以至少要總數除以二向上取整秒；最多的那種一秒只能裝一杯，所以也至少要它的數量那麼多秒。每次從最多的兩種各裝一杯可以達到這個下限，答案是兩者的較大值。
