---
title: "LeetCode 3813: Vowel-Consonant Score"
summary: "LeetCode 3813 解題筆記：只數字母，分成母音和子音；子音是 0 時分數是 0，否則用整數除法"
description: "2026-01-18 的 LeetCode 3813 解題紀錄"
date: 2026-01-18
tags: ["easy", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

字串裡還有空白和數字，只有字母要算（[String]({{< relref "/algorithm/String" >}}) 模板四）。母音數 `v`、子音數 `c`，`c > 0` 時分數是 `v // c`，否則是 0。

## 我的解法

我當時用 `97 <= ord(c) <= 97 + 26` 判斷字母（上界其實多了一個 `{`，但輸入不會出現），再用 `floor(v / c)`。這裡改用 `isalpha` 和整數除法：

```python
class Solution:
    def vowelConsonantScore(self, s: str) -> int:
        v = sum(ch in "aeiou" for ch in s)
        c = sum(ch.isalpha() and ch not in "aeiou" for ch in s)
        return v // c if c else 0
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 空白和數字不是子音。
- 子音數是 0 時不能除。

## 面試口說整理

我只數字母，母音和子音分開算。子音是 0 就回傳 0，否則回傳整數除法的結果。時間 `O(n)`。
