---
title: "LeetCode 290: Word Pattern"
summary: "LeetCode 290 解題筆記：pattern 的字元和單字要一對一對應，用兩個方向的 dict 或比較 set 大小"
description: "2022-08-23 的 LeetCode 290 解題紀錄"
date: 2022-08-23
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 LC 205 一樣是雙射：每個字元只對應一個單字，每個單字也只對應一個字元。長度要相同，而且 `pattern` 字元種類數、單字種類數、`(字元, 單字)` 配對種類數三者相等（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五）。

## 我的嘗試

一次 AC，當時的寫法是分別記錄每個字元、每個單字出現的位置 list，再比較兩邊的位置集合是否相同。

## 正確解法

```python
class Solution:
    def wordPattern(self, pattern: str, s: str) -> bool:
        words = s.split()
        if len(pattern) != len(words):
            return False
        return len(set(pattern)) == len(set(words)) == len(set(zip(pattern, words)))
```

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 長度不同要先排除，`zip` 會默默截斷。
- 兩個方向都要一對一：`"ab"` 對 `"dog dog"` 不成立。

## 面試口說整理

這是雙射，我先確認長度一樣，再比較字元種類數、單字種類數和配對種類數三者相等。時間 `O(n + m)`。
