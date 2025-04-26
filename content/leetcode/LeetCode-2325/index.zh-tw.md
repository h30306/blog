---
title: "LeetCode 2325: Decode the Message"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-22
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-22
- 總花費時間：10:00.00

## 解題思路

我們可以從 `key` 字串建立一個對應表，把每個字母依序對應到從 `'a'` 開始的字母。  
建立好替換表後，只要遍歷 `message`，根據對應表將每個字元轉換並串接起來即可。  
這是一個 `O(n)` 的解法，只需要遍歷一次陣列。

## 解法

```python
class Solution:
    def decodeMessage(self, key: str, message: str) -> str:
        idx_map = {}
        first_ord = 97  # 'a' 的 ASCII 編碼
        for s in key:
            if s != " " and s not in idx_map:
                idx_map[s] = chr(first_ord)
                first_ord += 1
        return "".join(idx_map[s] if s != " " else s for s in message)
```

## 收穫

NA

## 遇到的問題

NA