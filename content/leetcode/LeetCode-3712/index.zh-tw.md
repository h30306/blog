---
title: "LeetCode 3712: Sum of Elements With Frequency Divisible by K"
summary: "LeetCode 3712 解題筆記：先數每個值的次數，次數能被 k 整除的就加上「值 × 次數」"
description: "2025-10-12 的 LeetCode 3712 解題紀錄"
date: 2025-10-12
tags: ["easy", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-10-12
- 提交紀錄：Accepted（一次通過）

## 解題思路

先用 `Counter` 數每個值出現幾次（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。次數能被 `k` 整除的值，每一次出現都要加，所以加上 `值 × 次數`。

## 我的解法

```python
class Solution:
    def sumDivisibleByK(self, nums: List[int], k: int) -> int:
        return sum(x * c for x, c in Counter(nums).items() if c % k == 0)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 要加的是每一次出現，不是只加一次值。

## 面試口說整理

我數每個值的次數，次數能被 `k` 整除的就把值乘上次數加進答案。時間 `O(n)`。
