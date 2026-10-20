---
title: "LeetCode 3775: Reverse Words With Same Vowel Count"
summary: "LeetCode 3775 解題筆記：先數第一個字的母音數，後面母音數一樣的字就反轉"
description: "2026-01-24 的 LeetCode 3775 解題紀錄"
date: 2026-01-24
tags: ["medium", "string", "simulation", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

1. 用空白切開字串。
2. 數第一個字的母音數 `target`。
3. 第一個字不動，後面每個字如果母音數等於 `target` 就反轉，否則不動。

反轉一個字可以用切片 `word[::-1]`，或用對撞指針交換。

## 我的解法

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        def vowels(word: str) -> int:
            return sum(ch in "aeiou" for ch in word)

        words = s.split(" ")
        target = vowels(words[0])
        return " ".join([words[0]] + [w[::-1] if vowels(w) == target else w for w in words[1:]])
```

原本的版本數母音時，對每個母音呼叫一次 `word.count(v)`，掃了五遍字串；這裡改成掃一遍。另外原本用「`res` 是不是空的」判斷是不是第一個字，這裡直接把第一個字分開處理。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 把第一個字也反轉：題目只處理第一個字之後的字。

## 面試口說整理

我先用空白切開，數出第一個字的母音數，後面的字母音數一樣就反轉、不一樣就保留，最後再用空白接回去。每個字元只看常數次，時間 `O(n)`。
