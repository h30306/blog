---
title: "LeetCode 2176: Count Equal and Divisible Pairs in an Array"
summary: "LeetCode 2176 解題筆記：n 只有 100，枚舉所有配對；條件是值相等而且 index 的乘積 i * j 能被 k 整除"
description: "2025-04-17 的 LeetCode 2176 解題紀錄"
date: 2025-04-17
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
第一次嘗試：2025-04-17
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

`n <= 100`，直接枚舉所有 `i < j` 的配對（[Array]({{< relref "/algorithm/Array" >}}) 模板四）。兩個條件：`nums[i] == nums[j]`，而且 **index** 的乘積 `i * j` 能被 `k` 整除。

## 我的嘗試

第一版寫成 `(nums[i] * nums[j]) // 2`，**用了值、而且用整數除以 2 當條件**。例如 `nums = [1, 1]`、`k = 4`：`0 × 1 = 0` 能被 4 整除，答案 1；這版算 `1 × 1 // 2 = 0`，是 False，回傳 0。改成 `not (i * j) % k` 就 AC 了。

## 正確解法

```python
class Solution:
    def countPairs(self, nums: List[int], k: int) -> int:
        n = len(nums)
        return sum(nums[i] == nums[j] and i * j % k == 0
                   for i in range(n) for j in range(i + 1, n))
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- 乘積用的是 index，不是值。
- 「能被 `k` 整除」是 `% k == 0`。

## 面試口說整理

`n` 很小，我枚舉所有配對，檢查值相等而且 index 的乘積能被 `k` 整除。時間 `O(n²)`。
