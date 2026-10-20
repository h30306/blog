---
title: "LeetCode 3684: Maximize Sum of At Most K Distinct Elements"
summary: "LeetCode 3684 解題筆記：全是正數，去重後由大到小取前 k 個"
description: "2026-01-29 的 LeetCode 3684 解題紀錄"
date: 2026-01-29
tags: ["easy", "greedy", "sorting", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-29
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

數字都是正的，拿越多越大，所以盡量拿滿 `k` 個；要不重複，就去重之後由大到小取前 `k` 個。不同的值不到 `k` 個時就全拿。

## 我的嘗試

第一版照著範例寫死「前 3 大」，維護 `biggest, second, third`，**完全沒用到 `k`**。例如 `nums = [5, 3]`、`k = 1`：答案是 `[5]`，這版回傳 `[5, 3]`。

改成排序後由大到小，跳過重複，拿到 `k` 個就停，就 AC 了。

## 正確解法

```python
class Solution:
    def maxKDistinct(self, nums: List[int], k: int) -> List[int]:
        return sorted(set(nums), reverse=True)[:k]
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 不要照範例的 `k` 寫死，參數要用上。

## 面試口說整理

全是正數，所以拿越多越好。我去重之後由大到小排序，取前 `k` 個。時間 `O(n log n)`。
