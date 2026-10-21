---
title: "LeetCode 387: First Unique Character in a String"
summary: "LeetCode 387 解題筆記：先計數，再從左到右找第一個次數是 1 的字元"
description: "2022-08-23 的 LeetCode 387 解題紀錄"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "queue", "counting"]
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
- 提交紀錄：Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

兩次掃描（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）：第一次用 `Counter` 數每個字元出現幾次，第二次從左到右找第一個次數是 1 的 index。字母只有 26 個，空間 `O(1)`。

## 我的嘗試

第一版語法錯誤，之後用「只出現一次的字元」建一個 dict，再從左到右找第一個在 dict 裡的就 AC 了。後來試著用 `OrderedDict(Counter(s))` 一行寫完，中間一次 WA 才寫對。

## 正確解法

```python
class Solution:
    def firstUniqChar(self, s: str) -> int:
        cnt = Counter(s)
        for i, c in enumerate(s):
            if cnt[c] == 1:
                return i
        return -1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（最多 26 種字元）。

## 要特別避免的錯誤

- 找不到時回傳 -1。

## 面試口說整理

我先計數，再從左到右找第一個只出現一次的字元，回傳它的 index，找不到就回傳 -1。時間 `O(n)`，空間是字母的種類數。
