---
title: "LeetCode 3895: Count Digit Appearances"
summary: "LeetCode 3895 解題筆記：把每個數字轉成字串，數 digit 出現的次數加總"
description: "2026-08-24 的 LeetCode 3895 解題紀錄"
date: 2026-08-24
tags: ["medium", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-08-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

雖然標成 Medium，做法就是每個數字轉成字串、用 `count` 數出現次數、加總。也可以用 `% 10` 一位一位比對。

## 我的解法

```python
class Solution:
    def countDigitOccurrences(self, nums: List[int], digit: int) -> int:
        target = str(digit)
        return sum(str(x).count(target) for x in nums)
```

## 複雜度

時間 `O(n · d)`，空間 `O(d)`。

## 要特別避免的錯誤

- `digit` 是整數，要轉成字串才能用 `str.count`。

## 面試口說整理

我把每個數字轉成字串，數 `digit` 出現幾次再加總。如果不想轉字串，就用 `% 10` 拿每一位比對。時間 `O(n · d)`。
