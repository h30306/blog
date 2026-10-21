---
title: "LeetCode 3701: Compute Alternating Sum"
summary: "LeetCode 3701 解題筆記：偶數 index 加、奇數 index 減；用切片就是 sum(nums[::2]) - sum(nums[1::2])"
description: "2025-10-05 的 LeetCode 3701 解題紀錄"
date: 2025-10-05
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
第一次嘗試：2025-10-05
- 提交紀錄：Accepted（一次通過）

## 解題思路

偶數位置的加起來、奇數位置的加起來，相減就是交錯和（[Array]({{< relref "/algorithm/Array" >}}) 模板五）。

## 我的解法

```python
class Solution:
    def alternatingSum(self, nums: List[int]) -> int:
        return sum(nums[::2]) - sum(nums[1::2])
```

我當時用迴圈依 `i % 2` 決定加或減，結果一樣。

## 複雜度

時間 `O(n)`，空間 `O(n)`（切片）。

## 要特別避免的錯誤

- index 從 0 開始，第一個是加。

## 面試口說整理

偶數位置相加、奇數位置相加，兩者相減就是答案。時間 `O(n)`。
