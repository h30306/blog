---
title: "LeetCode 1431: Kids With the Greatest Number of Candies"
summary: "LeetCode 1431 解題筆記：先算一次最大值，每個人加上額外的糖果後 >= 最大值就是 True；平手也算最多"
description: "2025-03-18 的 LeetCode 1431 解題紀錄"
date: 2025-03-18
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
第一次嘗試：2025-03-18
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

把額外的糖果全部給一個小孩，他要跟原本的最大值一樣多或更多，才會是最多的（[Array]({{< relref "/algorithm/Array" >}}) 模板三）。題目說可以有多個小孩同時最多，所以**平手也算**。

## 我的嘗試

第一版用 `>`，**平手沒有算進去**。例如 `candies = [3]`、`extraCandies = 0`：唯一的小孩本來就是最多的，答案 `[True]`，這版回傳 `[False]`。改成 `>=` 就 AC 了；第三次提交把 `max(candies)` 移到迴圈外面。

## 正確解法

```python
class Solution:
    def kidsWithCandies(self, candies: List[int], extraCandies: int) -> List[bool]:
        top = max(candies)
        return [c + extraCandies >= top for c in candies]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 用 `>=`，平手也算最多。
- 最大值先算好，不要在 list comprehension 裡每次重算（那會變成 `O(n²)`）。

## 面試口說整理

我先算出最大值，每個小孩加上額外的糖果之後只要不少於最大值就是 True，平手也算。時間 `O(n)`。
