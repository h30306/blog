---
title: "LeetCode 3120: Count the Number of Special Characters I"
summary: "LeetCode 3120 解題筆記：分別收集出現過的小寫和大寫字母，兩個集合的交集大小就是答案"
description: "2024-04-21 的 LeetCode 3120 解題紀錄"
date: 2024-04-21
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-04-21
- 提交紀錄：Accepted（一次通過）

## 解題思路

把出現過的字母分成兩個集合：小寫出現過的、大寫出現過的（都轉成同一種大小寫存），兩邊都有的字母就是 special，答案是交集的大小（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。

## 我的解法

```python
class Solution:
    def numberOfSpecialChars(self, word: str) -> int:
        lower = {c for c in word if c.islower()}
        upper = {c.lower() for c in word if c.isupper()}
        return len(lower & upper)
```

## 複雜度

時間 `O(n)`，空間 `O(26)`。

## 要特別避免的錯誤

- 兩個集合要轉成同一種大小寫才能取交集。

## 面試口說整理

我把小寫出現過的字母和大寫出現過的字母各放一個集合，轉成同樣的大小寫後取交集，大小就是答案。時間 `O(n)`。
