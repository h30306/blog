---
title: "LeetCode 1991: Find the Middle Index in Array"
summary: "LeetCode 1991 解題筆記：先算總和，掃描時維護左邊的和，右邊的和是 total - left - nums[i]"
description: "2022-11-23 的 LeetCode 1991 解題紀錄"
date: 2022-11-23
tags: ["easy", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

先算總和 `total`，從左往右維護 `left`（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})），右邊的和就是 `total - left - nums[i]`。第一個 `left == right` 的位置就是答案（要最左邊的）。跟 LC 724 是同一題。

## 我的解法

```python
class Solution:
    def findMiddleIndex(self, nums: List[int]) -> int:
        total, left = sum(nums), 0
        for i, x in enumerate(nums):
            if left == total - left - x:
                return i
            left += x
        return -1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 比較之後再把 `nums[i]` 加進 `left`，它本身不屬於任何一邊。

## 面試口說整理

我先算總和，掃描時維護左邊的和，右邊就是總和減掉左邊和目前的數，第一個相等的位置就是答案。時間 `O(n)`、空間 `O(1)`。
