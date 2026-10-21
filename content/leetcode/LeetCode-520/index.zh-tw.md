---
title: "LeetCode 520: Detect Capital"
summary: "LeetCode 520 解題筆記：合法的只有三種：全大寫、全小寫、只有第一個字母大寫"
description: "2022-08-25 的 LeetCode 520 解題紀錄"
date: 2022-08-25
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

直接檢查三種合法的情況（[String]({{< relref "/algorithm/String" >}}) 模板四）：`word.isupper()`、`word.islower()`、`word[0].isupper() and word[1:].islower()`。單一字元時 `word[1:]` 是空字串、`"".islower()` 是 `False`，不過單一字母已經被前兩種涵蓋了；第三種也可以寫成 `word.istitle()`（只有一個單字時等價）。

## 我的解法

```python
class Solution:
    def detectCapitalUse(self, word: str) -> bool:
        return word.isupper() or word.islower() or word.istitle()
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 第三種情況是「第一個大寫、**其他全部**小寫」。

## 面試口說整理

合法的只有全大寫、全小寫、首字母大寫三種，我直接用 isupper、islower、istitle 檢查。時間 `O(n)`。
