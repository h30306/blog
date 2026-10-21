---
title: "LeetCode 151: Reverse Words in a String"
summary: "LeetCode 151 解題筆記：split() 不帶參數會把連續空白當成一個分隔，也會去掉頭尾空白；反轉後用一個空白接起來"
description: "2022-11-12 的 LeetCode 151 解題紀錄"
date: 2022-11-12
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-12
- 提交紀錄：Accepted ×3 → Runtime Error → Wrong Answer ×5 → Accepted

## 解題思路

`str.split()` **不帶參數**時，會把任意長度的空白當成一個分隔，頭尾的空白也會被丟掉，剛好就是題目要的單字列表。反轉後用一個空白 `join` 起來。如果要求 `O(1)` 額外空間（字元陣列），可以先整個反轉、再逐字反轉（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。

## 我的嘗試

2022 年就 AC 了。2026 年重寫時用了 `split(" ")`，**連續空白會產生空字串**，例如 `"b  b"` 回傳 `"b  b"`（中間還是兩個空白），`"b "` 回傳 `" b"`；也有一版忘了中間要加空白，`"a b"` 回傳 `"ba"`。

## 正確解法

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return " ".join(reversed(s.split()))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `split(" ")` 遇到連續空白會產生空字串，`split()` 不會。

## 面試口說整理

我用不帶參數的 `split()` 拿到所有單字（連續空白和頭尾空白都處理好了），反轉後用一個空白接起來。時間 `O(n)`。
