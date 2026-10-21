---
title: "LeetCode 1732: Find the Highest Altitude"
summary: "LeetCode 1732 解題筆記：海拔就是 gain 的前綴和，起點是 0，取最大值"
description: "2022-11-23 的 LeetCode 1732 解題紀錄"
date: 2022-11-23
tags: ["easy", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

第 `i` 個點的海拔是 `gain[0] + ... + gain[i - 1]`，也就是前綴和（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})）。起點海拔 0 也要算進去，所以答案至少是 0。

## 我的解法

```python
class Solution:
    def largestAltitude(self, gain: List[int]) -> int:
        best = cur = 0
        for g in gain:
            cur += g
            best = max(best, cur)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 起點 0 也是一個海拔，全部都往下時答案是 0。

## 面試口說整理

海拔就是 gain 的前綴和，我一邊累加一邊記錄最大值，起點 0 也算。時間 `O(n)`、空間 `O(1)`。
