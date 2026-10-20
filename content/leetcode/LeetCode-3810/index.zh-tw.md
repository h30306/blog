---
title: "LeetCode 3810: Minimum Operations to Reach Target Array"
summary: "LeetCode 3810 解題筆記：一次操作會把某個值的所有位置都改對，所以答案是不相等的位置上有幾種不同的值"
description: "2026-01-17 的 LeetCode 3810 解題紀錄"
date: 2026-01-17
tags: ["medium", "greedy", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

選 `x` 時，所有值等於 `x` 的位置都會被改成 `target`，不管它們是不是連在一起。

- **上界**：對每個「不相等的位置上出現的值」各做一次，所有不相等的位置都會被改對。已經相等的位置被改到也沒關係（改成 `target` 還是一樣）。
- **下界**：一個不相等的位置，只有在選到它**目前的值**時才會改變。它的值一開始就是 `nums[i]`，在它被改之前都不會變，所以每一種不相等位置上的值都至少要被選一次。

兩者相等，答案就是不同值的個數（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板四）。

## 我的解法

```python
class Solution:
    def minOperations(self, nums: List[int], target: List[int]) -> int:
        return len({a for a, b in zip(nums, target) if a != b})
```

我當時寫成 `len(diff) - (len(diff) - len(set(diff)))`，化簡就是 `len(set(diff))`。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 題目的「連續段」只是在描述哪些位置會改；同一個值的所有段是一次一起改的，不用分段計算。

## 面試口說整理

選一個值就會把所有那個值的位置改成目標，所以每一種不相等位置上的值做一次就夠。而且不相等的位置只有選到它目前的值才會變，所以每一種都至少要做一次。答案是不相等位置上有幾種不同的值。時間 `O(n)`。
