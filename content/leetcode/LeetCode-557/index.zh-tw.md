---
title: "LeetCode 557: Reverse Words in a String III"
summary: "LeetCode 557 解題筆記：用空白切開，每個單字各自反轉，再用空白接回去"
description: "2022-08-27 的 LeetCode 557 解題紀錄"
date: 2022-08-27
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Accepted ×2

## 解題思路

題目保證單字之間只有一個空白、頭尾沒有空白，所以 `split(" ")` 切開後每個單字各自反轉，再用空白接起來（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一的反轉，在 Python 用切片）。

## 我的解法

```python
class Solution:
    def reverseWords(self, s: str) -> str:
        return " ".join(w[::-1] for w in s.split(" "))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 反轉的是每個單字，不是單字的順序。

## 面試口說整理

我用空白把字串切成單字，每個單字反轉後再用空白接起來。時間 `O(n)`。
