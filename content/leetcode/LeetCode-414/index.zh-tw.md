---
title: "LeetCode 414: Third Maximum Number"
summary: "LeetCode 414 解題筆記：記錄三個不同的最大值，重複的數跳過；不到三個不同的數就回傳最大值"
description: "2022-08-24 的 LeetCode 414 解題紀錄"
date: 2022-08-24
tags: ["easy", "array", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

題目要的是**不同的**第三大。掃一次維護 `first > second > third`，遇到已經在裡面的值就跳過，比 `first` 大就整個往下推一格（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）。不到三個不同的值時回傳最大值。`O(n)`，不用排序。

## 我的嘗試

一次 AC，當時是 `sorted(set(nums))[-3]`，不到三個時用 `try/except` 回傳 `max(nums)`，`O(n log n)`。

## 正確解法

```python
class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        top = []
        for x in nums:
            if x in top:
                continue
            top.append(x)
            top.sort(reverse=True)
            if len(top) > 3:
                top.pop()
        return top[2] if len(top) == 3 else top[0]
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（`top` 最多 4 個）。

## 要特別避免的錯誤

- 是不同的數的第三大，重複的不算。

## 面試口說整理

我維護最多三個不同的最大值，重複的跳過，每次加入後排序並保留最大的三個，最後有三個就回傳第三個，否則回傳最大值。時間 `O(n)`。
