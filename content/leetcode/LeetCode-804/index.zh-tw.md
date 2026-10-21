---
title: "LeetCode 804: Unique Morse Code Words"
summary: "LeetCode 804 解題筆記：把每個單字轉成摩斯碼字串，放進集合後算有幾種"
description: "2022-09-07 的 LeetCode 804 解題紀錄"
date: 2022-09-07
tags: ["easy", "array", "hash-table", "string"]
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
- 提交紀錄：Accepted（一次通過）

## 解題思路

照表把每個字母換成摩斯碼、接成一個字串，放進集合，答案是集合的大小（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。字母 `c` 的編碼是 `table[ord(c) - ord("a")]`。

## 我的解法

```python
class Solution:
    def uniqueMorseRepresentations(self, words: List[str]) -> int:
        table = [".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---",
                 "-.-", ".-..", "--", "-.", "---", ".--.", "--.-", ".-.", "...", "-",
                 "..-", "...-", ".--", "-..-", "-.--", "--.."]
        return len({"".join(table[ord(c) - ord("a")] for c in w) for w in words})
```

## 複雜度

時間 `O(總字元數)`，空間 `O(總字元數)`。

## 要特別避免的錯誤

- 不同單字可能有相同的摩斯碼，這正是題目要數的。

## 面試口說整理

我把每個單字照表轉成摩斯碼字串，放進集合，集合的大小就是答案。時間是總字元數。
