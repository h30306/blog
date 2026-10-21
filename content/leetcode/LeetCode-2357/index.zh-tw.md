---
title: "LeetCode 2357: Make Array Zero by Subtracting Equal Amounts"
summary: "LeetCode 2357 解題筆記：每次操作會讓最小的正數那一群變成 0，所以次數就是不同的正數有幾種"
description: "2022-11-21 的 LeetCode 2357 解題紀錄"
date: 2022-11-21
tags: ["easy", "array", "hash-table", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-21
- 提交紀錄：Runtime Error → Accepted

## 解題思路

每次減去目前最小的正數 `x`：所有等於 `x` 的都變成 0，比 `x` 大的數之間的差不變，所以不同的值不會合併。每種不同的正數需要剛好一次操作，答案是 `len(set(nums) - {0})`（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。

## 我的嘗試

第一版寫成 `len(set(nums)) - {0}`，**括號位置錯了**，整數減集合（TypeError）。改成 `len(set(nums) - {0})` 就 AC 了。

## 正確解法

```python
class Solution:
    def minimumOperations(self, nums: List[int]) -> int:
        return len(set(nums) - {0})
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 0 不需要操作，要從集合裡拿掉。
- 括號要包住整個集合運算：`len(set(nums) - {0})`。

## 面試口說整理

每次減去最小的正數，等於它的都變成 0，其他數之間的差不變，所以每種不同的正數剛好需要一次操作，答案就是不同的正數有幾種。時間 `O(n)`。
