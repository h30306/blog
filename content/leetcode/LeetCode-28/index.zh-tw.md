---
title: "LeetCode 28: Find the Index of the First Occurrence in a String"
summary: "LeetCode 28 解題筆記：在每個起點比對 needle，或直接用 str.find；index 找不到會丟例外"
description: "2022-05-11 的 LeetCode 28 解題紀錄"
date: 2022-05-11
tags: ["easy", "two-pointers", "string", "string-matching", "z-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-05-11
- 提交紀錄：Accepted ×3 → Runtime Error → Accepted ×2

## 解題思路

在 `haystack` 的每個起點 `i` 比對 `haystack[i:i + m] == needle`（[String]({{< relref "/algorithm/String" >}}) 模板二），起點只到 `n - m`。面試時通常先講這個 `O(nm)` 的作法，有需要再提 KMP 的 `O(n + m)`。Python 內建的 `str.find` 找不到回傳 `-1`，剛好是題目要的；`str.index` 找不到會丟 `ValueError`。

## 我的嘗試

之前幾次都是用內建的 `in` 加 `index`。2022-10 有一次只寫 `haystack.index(needle)`，找不到時丟 `ValueError`。

## 正確解法

```python
class Solution:
    def strStr(self, haystack: str, needle: str) -> int:
        n, m = len(haystack), len(needle)
        for i in range(n - m + 1):
            if haystack[i:i + m] == needle:
                return i
        return -1
```

## 複雜度

時間 `O(nm)`，空間 `O(m)`（切片）。

## 要特別避免的錯誤

- 起點的範圍是 `n - m + 1` 個。
- 用內建函式時，`index` 找不到會丟例外，要用 `find`。

## 面試口說整理

我在每個可能的起點比對 needle，第一個對上的就回傳，找不到回傳 -1，時間 `O(nm)`；如果要更快可以用 KMP 先算 needle 的失敗函數，做到 `O(n + m)`。
