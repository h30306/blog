---
title: "LeetCode 3805: Count Caesar Cipher Pairs"
summary: "LeetCode 3805 解題筆記：把每個字串整串平移到第一個字母是 a，凱薩等價的字串會變成一樣；再數每種正規化結果的配對數"
description: "2026-01-11 的 LeetCode 3805 解題紀錄"
date: 2026-01-11
tags: ["medium", "math", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個字串可以透過整串平移變成一樣 ⇔ **每個位置跟第一個字母的差（mod 26）都一樣**。

所以把每個字串**正規化**：整串平移到第一個字母是 `a`，也就是每個字母記成 `(c - word[0]) mod 26`。等價的字串會得到一樣的結果，用雜湊表數每種結果有幾個，配對數是 `c × (c - 1) / 2`。

## 我的解法

```python
class Solution:
    def countPairs(self, words: List[str]) -> int:
        cnt = Counter()
        pairs = 0
        for w in words:
            key = tuple((ord(c) - ord(w[0])) % 26 for c in w)   # 平移到第一個字母是 a
            pairs += cnt[key]                      # 跟前面每個等價的配一對
            cnt[key] += 1
        return pairs
```

我原本是真的組出平移後的字串，用 `chr` 和條件判斷處理繞回來的情況，最後用 `v * (v - 1) / 2` 算（浮點除法，再轉回整數）。用 `% 26` 的 tuple 當 key 比較乾淨，也不會碰到浮點數。

## 複雜度

時間 `O(n · m)`，空間 `O(n · m)`。

## 要特別避免的錯誤

- 平移要繞回來：`z` 的下一個是 `a`，用 `% 26`。
- 配對數用整數運算。

## 面試口說整理

兩個字串凱薩等價，就是每個字母跟第一個字母的差（mod 26）都一樣。所以我把每個字串正規化成這個差的序列當 key，邊掃邊數前面有幾個同樣的 key，加起來就是配對數。時間 `O(n · m)`。
