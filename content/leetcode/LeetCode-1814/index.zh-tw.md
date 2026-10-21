---
title: "LeetCode 1814: Count Nice Pairs in an Array"
summary: "LeetCode 1814 解題筆記：把條件移項成 nums[i] - rev(nums[i]) == nums[j] - rev(nums[j])，按這個值分組數 pair，記得取模"
description: "2024-04-17 的 LeetCode 1814 解題紀錄"
date: 2024-04-17
tags: ["medium", "array", "hash-table", "math", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-04-17
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

條件 `nums[i] + rev(nums[j]) == nums[j] + rev(nums[i])` 移項後是 `nums[i] - rev(nums[i]) == nums[j] - rev(nums[j])`：**兩邊各自只跟自己有關**。所以把每個數換成 `x - rev(x)`，同一個值有 `c` 個就有 `c(c - 1) / 2` 對（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一，也是 [Math]({{< relref "/algorithm/Math" >}}) 模板一的配對數）。答案要對 `10^9 + 7` 取模。

## 我的嘗試

第一版的作法就對了，但**忘了取模**，答案很大時 WA；加上 `% 1000000007` 就 AC 了。

## 正確解法

```python
class Solution:
    def countNicePairs(self, nums: List[int]) -> int:
        cnt = Counter(x - int(str(x)[::-1]) for x in nums)
        return sum(c * (c - 1) // 2 for c in cnt.values()) % (10**9 + 7)
```

## 複雜度

時間 `O(n log M)`，空間 `O(n)`。

## 要特別避免的錯誤

- 題目要求取模。
- 兩兩比較是 `O(n²)`，要先移項讓每一邊只跟一個 index 有關。

## 面試口說整理

我把條件移項成 nums[i] - rev(nums[i]) 等於 nums[j] - rev(nums[j])，這樣每個數可以各自算出一個 key，同一個 key 有 c 個就有 c 取 2 對，最後取模。時間 `O(n log M)`。
