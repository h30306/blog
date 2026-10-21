---
title: "LeetCode 1920: Build Array from Permutation"
summary: "LeetCode 1920 解題筆記：照定義 ans[i] = nums[nums[i]]；要 O(1) 額外空間時，把新值乘 n 疊在原本的值上"
description: "2025-05-06 的 LeetCode 1920 解題紀錄"
date: 2025-05-06
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-06
- 提交紀錄：Accepted（一次通過）

## 解題思路

照定義建新陣列（[Array]({{< relref "/algorithm/Array" >}}) 模板五）。進階要求 `O(1)` 額外空間時，因為值都在 `0..n-1`，可以在原陣列上存兩個值：`nums[i] += n * (nums[nums[i]] % n)`，`% n` 拿到舊值、`// n` 拿到新值。

## 我的解法

```python
class Solution:
    def buildArray(self, nums: List[int]) -> List[int]:
        return [nums[x] for x in nums]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 原地做的時候，讀舊值一定要 `% n`，因為前面的位置可能已經被改過。

## 面試口說整理

照定義 `ans[i] = nums[nums[i]]` 建新陣列就好。如果要原地做，因為值都小於 `n`，可以把新值乘 `n` 加在原本的值上，最後再除以 `n`。時間 `O(n)`。
