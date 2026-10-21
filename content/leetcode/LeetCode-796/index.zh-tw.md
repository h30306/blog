---
title: "LeetCode 796: Rotate String"
summary: "LeetCode 796 解題筆記：goal 是 s 的旋轉，等價於兩者長度相同而且 goal 出現在 s + s 裡"
description: "2022-09-07 的 LeetCode 796 解題紀錄"
date: 2022-09-07
tags: ["easy", "string", "string-matching"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-07
- 提交紀錄：Runtime Error ×2 → Wrong Answer → Accepted ×5

## 解題思路

`s + s` 包含了 `s` 所有的旋轉（每個起點往後取 `len(s)` 個字元）。所以長度相同而且 `goal in s + s` 就成立（[String]({{< relref "/algorithm/String" >}}) 模板二）。**長度檢查不能省**：`"aa"` 也在 `"a" + "a"` 裡。

## 我的嘗試

這題有兩個「AC 但其實是錯的」版本：

- 前兩版用 `s.index` 找字元的位置比下一個字元，`i + 1` 超出範圍（IndexError）。
- 接著改成「`s` 的每兩個相鄰字元都要出現在 `goal` 裡，最多允許一個例外」，第一版 WA 之後加上長度檢查就 **AC 了，但這個想法本身是錯的**：`s = "b"`、`goal = "a"` 只有一組片段 `"b"` 不在裡面，還在允許範圍內，回傳 `True`。
- 之後改成 `goal in s + s`，但長度只檢查了 `len(goal) < len(s)`，**也 AC 了**：`s = "a"`、`goal = "aa"` 會回傳 `True`。下一版補上 `len(goal) == len(s)` 才是正確的。

## 正確解法

```python
class Solution:
    def rotateString(self, s: str, goal: str) -> bool:
        return len(s) == len(goal) and goal in s + s
```

## 複雜度

時間 `O(n²)`（內建搜尋最壞情況），用 KMP 可以 `O(n)`；空間 `O(n)`。

## 要特別避免的錯誤

- 長度要相等，只檢查 `len(goal) < len(s)` 不夠。
- 「相鄰兩個字元都出現在 goal 裡」不代表是旋轉。

## 面試口說整理

s 自己接自己會包含所有的旋轉，所以我檢查兩個字串長度相同，而且 goal 是 s + s 的子字串。內建搜尋最壞 `O(n²)`，用 KMP 可以 `O(n)`。
