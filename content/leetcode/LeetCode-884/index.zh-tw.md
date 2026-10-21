---
title: "LeetCode 884: Uncommon Words from Two Sentences"
summary: "LeetCode 884 解題筆記：把兩個句子合起來數每個單字的次數，只出現一次的就是答案"
description: "2022-09-21 的 LeetCode 884 解題紀錄"
date: 2022-09-21
tags: ["easy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-21
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

「在一個句子出現剛好一次、另一個句子沒出現」等於「兩個句子合起來只出現一次」。把兩句接起來 `split()`，計數後取次數為 1 的（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。

## 我的嘗試

第一版忘了 `split`，直接對字串跑迴圈，數的是**字元**：`"b"`、`"b"` 回傳了中間的空白 `[" "]`。

## 正確解法

```python
class Solution:
    def uncommonFromSentences(self, s1: str, s2: str) -> List[str]:
        cnt = Counter((s1 + " " + s2).split())
        return [w for w, c in cnt.items() if c == 1]
```

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 要先 `split()` 成單字；直接 `for s in 字串` 拿到的是字元。

## 面試口說整理

我把兩個句子接起來切成單字並計數，合起來只出現一次的單字就是答案。時間 `O(n + m)`。
