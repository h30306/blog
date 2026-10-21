---
title: "LeetCode 3798: Largest Even Number"
summary: "LeetCode 3798 解題筆記：偶數只看最後一位，把結尾的 1 刪掉就好；保留越多位數越大"
description: "2026-01-04 的 LeetCode 3798 解題紀錄"
date: 2026-01-04
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-04
- 提交紀錄：Accepted（一次通過）

## 解題思路

字串只有 `1` 和 `2`，偶數只要最後一位是 `2`。位數越多數字越大，所以只刪必要的：把結尾連續的 `1` 刪掉，剩下的就是最大的偶數。全部都是 `1` 就是空字串。

## 我的解法

```python
class Solution:
    def largestEven(self, s: str) -> str:
        return s.rstrip("1")
```

我當時用 while 迴圈一個一個刪，`rstrip` 是同一件事。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 刪中間的字只會讓數字變短變小，只需要處理結尾。

## 面試口說整理

偶數只看最後一位，而保留越多位數越大，所以我只把結尾的 1 刪掉。時間 `O(n)`。
