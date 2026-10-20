---
title: "LeetCode 986: Interval List Intersections"
summary: "LeetCode 986 解題筆記：兩個指針各指一個區間，交集是 [max(起點), min(終點)]；結束得比較早的那個區間不會再跟別人相交，把它的指針往前"
description: "2026-02-01 的 LeetCode 986 解題紀錄"
date: 2026-02-01
tags: ["medium", "two-pointers", "sweep-line", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個列表各自排好序、互不重疊，跟合併兩個排序陣列一樣用兩個指針。

- 交集是 `[max(start1, start2), min(end1, end2)]`，`lo <= hi` 才是非空的交集（閉區間，端點相同也算）。
- **結束得比較早的那個區間**，不可能再跟另一個列表後面的區間相交（後面的都更晚開始），所以把它的指針往前。

## 我的解法

```python
class Solution:
    def intervalIntersection(self, firstList: List[List[int]], secondList: List[List[int]]) -> List[List[int]]:
        i = j = 0
        res = []
        while i < len(firstList) and j < len(secondList):
            start1, end1 = firstList[i]
            start2, end2 = secondList[j]
            lo, hi = max(start1, start2), min(end1, end2)
            if lo <= hi:
                res.append([lo, hi])
            if end1 < end2:
                i += 1                             # firstList[i] 先結束
            else:
                j += 1
        return res
```

## 複雜度

時間 `O(n + m)`，空間 `O(1)`（不算輸出）。

## 要特別避免的錯誤

- 用 `lo < hi` 判斷：閉區間 `[5, 5]` 也是合法的交集。
- 移動開始得比較早的指針：要移動的是**結束**得比較早的。

## 面試口說整理

兩個列表都排好序，所以我用兩個指針各指一個區間，交集是較大的起點到較小的終點，起點不超過終點就加進答案。結束比較早的那個區間不會再跟後面的區間相交，所以移動它的指針。時間 `O(n + m)`。
