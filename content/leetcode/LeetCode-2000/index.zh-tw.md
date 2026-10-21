---
title: "LeetCode 2000: Reverse Prefix of Word"
summary: "LeetCode 2000 解題筆記：找到 ch 第一次出現的位置 i，把 word[:i + 1] 反轉接上後面；找不到就原樣回傳"
description: "2024-05-01 的 LeetCode 2000 解題紀錄"
date: 2024-05-01
tags: ["easy", "two-pointers", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-05-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

`i = word.find(ch)`，找不到是 -1，這時 `word[:0]` 是空的，反轉後接上整個 `word`，剛好原樣回傳，不用特別判斷。手寫的話就是對 `[0, i]` 做左右指針交換（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）。

## 我的解法

```python
class Solution:
    def reversePrefix(self, word: str, ch: str) -> str:
        i = word.find(ch)
        return word[:i + 1][::-1] + word[i + 1:]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用 `index` 找不到時會丟例外，`find` 回傳 -1。

## 面試口說整理

我用 find 找到 ch 第一次出現的位置，把到那裡為止的前綴反轉再接上後面；找不到時 find 回傳 -1，前綴是空的，結果剛好是原字串。時間 `O(n)`。
