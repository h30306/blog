---
title: "LeetCode 1160: Find Words That Can Be Formed by Characters"
summary: "LeetCode 1160 解題筆記：每個單字的字元次數都不超過 chars 的次數才算能組成，加總這些單字的長度"
description: "2022-10-18 的 LeetCode 1160 解題紀錄"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Accepted ×3

## 解題思路

先數一次 `chars`（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），每個單字也數一次，`Counter(w) - C` 是空的代表每個字元都夠用（跟 LC 383 一樣），就把長度加進答案。

## 我的解法

```python
class Solution:
    def countCharacters(self, words: List[str], chars: str) -> int:
        have = Counter(chars)
        return sum(len(w) for w in words if not (Counter(w) - have))
```

## 複雜度

時間 `O(總字元數)`，空間 `O(k)`。

## 要特別避免的錯誤

- `chars` 的次數在迴圈外算一次就好，每個單字可以重複使用全部的 `chars`。

## 面試口說整理

我先數 chars 每個字元有幾個，再對每個單字檢查它需要的次數都沒有超過，可以組成的就加上長度。時間是所有單字的總長度。
