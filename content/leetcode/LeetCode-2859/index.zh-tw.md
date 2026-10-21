---
title: "LeetCode 2859: Sum of Values at Indices With K Set Bits"
summary: "LeetCode 2859 解題筆記：看的是 index 的二進位有幾個 1，不是值"
description: "2023-09-17 的 LeetCode 2859 解題紀錄"
date: 2023-09-17
tags: ["easy", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2023-09-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

對每個 index `i` 數 `bin(i)` 裡 1 的個數（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})），剛好是 `k` 就把 `nums[i]` 加進答案。

## 我的解法

```python
class Solution:
    def sumIndicesWithKSetBits(self, nums: List[int], k: int) -> int:
        return sum(x for i, x in enumerate(nums) if bin(i).count("1") == k)
```

## 複雜度

時間 `O(n log n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 判斷的是 index，不是 `nums[i]`。

## 面試口說整理

我對每個 index 數它二進位裡 1 的個數，剛好是 k 就把那個位置的值加起來。時間 `O(n log n)`。
