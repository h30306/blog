---
title: "LeetCode 389: Find the Difference"
summary: "LeetCode 389 解題筆記：t 比 s 多一個字元，把兩個字串的所有字元 XOR 起來，成對的抵消，剩下的就是多的那個"
description: "2022-08-23 的 LeetCode 389 解題紀錄"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "bit-manipulation", "sorting"]
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
- 提交紀錄：Accepted → Runtime Error → Accepted

## 解題思路

跟 LC 136 一樣（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）：`s` 和 `t` 合起來，除了多的那個字元以外每個字元都出現偶數次，全部 XOR 起來就剩下它。也可以用 `sum(ord(t)) - sum(ord(s))`。

## 我的嘗試

第一次是排序後逐一比較，AC 了；之後試著改寫時有一版語法錯誤，最後改成用字元編碼的總和相減。

## 正確解法

```python
class Solution:
    def findTheDifference(self, s: str, t: str) -> str:
        x = 0
        for c in s + t:
            x ^= ord(c)
        return chr(x)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- XOR 要對 `ord` 做，最後再 `chr` 轉回字元。

## 面試口說整理

兩個字串合起來，除了多的那個字元以外都出現偶數次，所以我把所有字元的編碼 XOR 起來，剩下的就是答案。時間 `O(n)`、空間 `O(1)`。
