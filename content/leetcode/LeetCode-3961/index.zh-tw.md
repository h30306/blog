---
title: "LeetCode 3961: Maximize Sum of Device Ratings"
summary: "LeetCode 3961 解題筆記：除了一台以外，每台把最小的單位捐給同一台；那台的評分變成全域最小值，挑第二小值最小的那台當接收者"
description: "2026-06-18 的 LeetCode 3961 解題紀錄"
date: 2026-06-18
tags: ["medium", "greedy", "sorting", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-18
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

一台設備的評分是最小的單位。把最小的單位捐出去，評分就變成第二小的值，只會變大。

- 每台都只能捐一次，所以最多從最小值升到第二小值。
- 收到的單位會拉低接收者的評分。把所有捐出來的單位**都丟給同一台**，只犧牲那一台：它的評分變成全部最小值裡最小的那個（全域最小值）。
- 犧牲哪一台？其他台都拿到第二小值，所以犧牲的那台要選第二小值最小的。

答案是 `所有第二小值的和 - 最小的第二小值 + 全域最小值`。每台只有一個單位時，捐出去就變成空的（評分 0），不如不動，答案是所有單位的和。這是 [Greedy]({{< relref "/algorithm/Greedy" >}}) 模板四的配對想法。

## 我的嘗試

第一版直接拿 `unit[0]` 當最小值、`unit[1]` 當第二小值，**以為每一列已經排序**。例如 `[[4, 3]]`：只有一台不能捐，答案是 3，這版回傳 4。

改成先找出每列的最小值、移除它，再找第二小值，就 AC 了。

## 正確解法

```python
class Solution:
    def maxRatings(self, units: List[List[int]]) -> int:
        if len(units[0]) == 1:
            return sum(u[0] for u in units)
        global_min, total, min_second = inf, 0, inf
        for u in units:
            a, b = heapq.nsmallest(2, u)
            global_min = min(global_min, a)
            total += b
            min_second = min(min_second, b)
        return total - min_second + global_min
```

只有一台設備時，這個式子會得到 `b - b + a = a`，剛好就是不動的答案。

## 複雜度

時間 `O(m · n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 輸入的每一列沒有排序，要自己找最小和第二小。
- 每台只有一個單位時要特判。

## 面試口說整理

捐出最小的單位會讓評分升到第二小值，所以除了一台以外都捐，而且全部捐給同一台，只犧牲它。被犧牲的那台評分變成全域最小值，要選第二小值最小的那台。答案是第二小值總和減掉最小的第二小值，再加上全域最小值。時間 `O(m · n)`。
