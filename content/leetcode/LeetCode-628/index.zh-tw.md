---
title: "LeetCode 628: Maximum Product of Three Numbers"
summary: "LeetCode 628 解題筆記：排序後答案只有兩種可能：最大的三個相乘，或最小的兩個（負數）乘最大的一個"
description: "2022-08-29 的 LeetCode 628 解題紀錄"
date: 2022-08-29
tags: ["easy", "array", "math", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

三個數的乘積最大，只有兩種情況（[Math]({{< relref "/algorithm/Math" >}}) 模板四）：最大的三個相乘；或兩個最小的數（可能是絕對值很大的負數，負負得正）乘上最大的數。排序後取兩者較大值，不用分「有沒有正數」的情況。

## 我的嘗試

第一版的 index 打錯，寫成 `nums[-1] * nums[-1] * nums[-2]`，**最大的數乘了兩次**：`[6, 5, 7]` 回傳 294，答案 210。另外還多寫了「有沒有正數」的分支，其實不需要。

## 正確解法

```python
class Solution:
    def maximumProduct(self, nums: List[int]) -> int:
        nums.sort()
        return max(nums[-1] * nums[-2] * nums[-3], nums[0] * nums[1] * nums[-1])
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`；只找最大三個和最小兩個可以做到 `O(n)`。

## 要特別避免的錯誤

- 兩個負數相乘是正的，最小的兩個數也是候選。
- index 要寫對：`nums[-1] * nums[-2] * nums[-3]`。

## 面試口說整理

排序後答案只有兩種：最大的三個相乘，或最小的兩個負數乘最大的數，取比較大的那個。時間 `O(n log n)`；只掃一次記錄最大三個和最小兩個可以做到 `O(n)`。
