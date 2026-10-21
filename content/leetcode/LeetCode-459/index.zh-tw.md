---
title: "LeetCode 459: Repeated Substring Pattern"
summary: "LeetCode 459 解題筆記：s 由某個子字串重複組成，等價於 s 出現在 (s + s) 去掉頭尾字元之後的字串裡"
description: "2022-08-24 的 LeetCode 459 解題紀錄"
date: 2022-08-24
tags: ["easy", "string", "string-matching", "z-algorithm", "knuth-morris-pratt-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

直接做法：枚舉能整除 `n` 的長度 `L`，檢查 `s[:L] * (n // L) == s`。更短的寫法：把 `s + s` 去掉第一個和最後一個字元，如果 `s` 還在裡面，代表 `s` 旋轉一個不是 0、也不是 `n` 的距離之後跟自己相同，也就是有重複的週期（[String]({{< relref "/algorithm/String" >}}) 模板二）。

## 我的嘗試

一次 AC，當時寫的是 `s in s[1:] + s[:-1]`，跟 `(s + s)[1:-1]` 是同一個字串。

## 正確解法

```python
class Solution:
    def repeatedSubstringPattern(self, s: str) -> bool:
        return s in (s + s)[1:-1]
```

## 複雜度

時間 `O(n²)`（內建搜尋最壞情況），空間 `O(n)`。

## 要特別避免的錯誤

- 頭尾都要去掉，不然 `s` 一定會在 `s + s` 的開頭或結尾找到。

## 面試口說整理

如果 s 是由子字串重複組成的，它旋轉某個週期之後會跟自己一樣，所以我檢查 s 是否出現在 s + s 去掉頭尾字元的字串裡。面試時也可以講枚舉能整除長度的週期，再逐一驗證。
