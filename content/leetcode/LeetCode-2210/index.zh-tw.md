---
title: "LeetCode 2210: Count Hills and Valleys in an Array"
summary: "LeetCode 2210 解題筆記：相等的鄰居當成同一點，只記上一個不同的方向；方向從上變下是山峰、從下變上是山谷"
description: "2025-07-27 的 LeetCode 2210 解題紀錄"
date: 2025-07-27
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-07-27
- 提交紀錄：Accepted（一次通過）

## 解題思路

相等的相鄰元素屬於同一個山峰或山谷，所以只看「方向」：每一對相鄰元素是上、下或平（[Array]({{< relref "/algorithm/Array" >}}) 模板一）。平的跳過，記住上一個不平的方向；方向從上變成下就是一個山峰，從下變成上就是一個山谷。

## 我的解法

```python
class Solution:
    def countHillValley(self, nums: List[int]) -> int:
        res, prev = 0, 0                       # prev：上一個不平的方向，1 上、-1 下
        for a, b in zip(nums, nums[1:]):
            d = (b > a) - (b < a)
            if d == 0:
                continue
            if prev and d != prev:
                res += 1
            prev = d
        return res
```

我當時先把方向存成 `"U"`、`"D"`、`"T"` 的陣列再掃一次，邏輯一樣。

## 複雜度

時間 `O(n)`，空間 `O(n)`（`nums[1:]` 的複製）。

## 要特別避免的錯誤

- 相等的鄰居不能算成新的山峰或山谷，要跳過。

## 面試口說整理

我看每一對相鄰元素的方向，跳過相等的，記住上一個不平的方向；方向改變一次就多一個山峰或山谷。時間 `O(n)`。
