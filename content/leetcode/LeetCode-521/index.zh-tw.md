---
title: "LeetCode 521: Longest Uncommon Subsequence I"
summary: "LeetCode 521 解題筆記：兩個字串相同時答案是 -1，否則比較長的那個整個就是答案"
description: "2022-08-25 的 LeetCode 521 解題紀錄"
date: 2022-08-25
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
第一次嘗試：2022-08-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

如果 `a == b`，`a` 的任何子序列也都是 `b` 的子序列，答案 `-1`。否則比較長的那個字串整個就不會是另一個的子序列（比它長，或一樣長但不相同），答案是 `max(len(a), len(b))`。

## 我的解法

```python
class Solution:
    def findLUSlength(self, a: str, b: str) -> int:
        return -1 if a == b else max(len(a), len(b))
```

## 複雜度

時間 `O(n)`（比較字串），空間 `O(1)`。

## 要特別避免的錯誤

- 一樣長但內容不同時，任一個字串整個都是答案。

## 面試口說整理

兩個字串相同時沒有答案，回傳 -1；不同時比較長的那個字串整個不可能是另一個的子序列，所以答案就是比較長的長度。
