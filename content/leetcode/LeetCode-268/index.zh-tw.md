---
title: "LeetCode 268: Missing Number"
summary: "LeetCode 268 解題筆記：0 到 n 的總和減掉陣列總和就是缺的那個；缺的可能是 0"
description: "2022-08-23 的 LeetCode 268 解題紀錄"
date: 2022-08-23
tags: ["easy", "array", "hash-table", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted → Wrong Answer → Accepted

## 解題思路

`0..n` 總共 `n + 1` 個數，陣列少了一個。完整的總和是 `n(n + 1) / 2`，減掉陣列的總和就是缺的那個。也可以用 XOR：`0..n` 和陣列的每個數全部 XOR，成對的抵銷，剩下的就是缺的。

## 我的嘗試

第一次就 AC 了。11 月重寫時一版排序後只檢查相鄰兩個數差距大於 1 的地方，**缺的是 0 時找不到**，例如 `[1]`：答案 0，回傳 1。

## 正確解法

```python
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        n = len(nums)
        return n * (n + 1) // 2 - sum(nums)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 缺的可能是 0 或 `n`，排序後只看相鄰差距會漏掉這兩種。

## 面試口說整理

`0` 到 `n` 的總和是 `n(n+1)/2`，減掉陣列的總和就是缺的數字。時間 `O(n)`、空間 `O(1)`。
