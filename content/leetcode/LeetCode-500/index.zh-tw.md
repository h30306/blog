---
title: "LeetCode 500: Keyboard Row"
summary: "LeetCode 500 解題筆記：鍵盤的三列各做成集合，單字轉小寫後的字元集合是某一列的子集就保留"
description: "2022-08-25 的 LeetCode 500 解題紀錄"
date: 2022-08-25
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
第一次嘗試：2022-08-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

三列鍵盤各做成集合（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})），單字轉小寫後的字元集合是其中一列的**子集**（`<=`）就能只用那一列打出來。大小寫都算同一個鍵。

## 我的解法

```python
class Solution:
    def findWords(self, words: List[str]) -> List[str]:
        rows = [set("qwertyuiop"), set("asdfghjkl"), set("zxcvbnm")]
        return [w for w in words if any(set(w.lower()) <= r for r in rows)]
```

## 複雜度

時間 `O(總字元數)`，空間 `O(1)`。

## 要特別避免的錯誤

- 要先轉小寫再比對。
- 輸出要保留原本的大小寫和順序。

## 面試口說整理

我把三列鍵盤各做成集合，單字轉小寫後的字元集合如果是某一列的子集就保留，時間是總字元數。
