---
title: "LeetCode 2416: Sum of Prefix Scores of Strings"
summary: "LeetCode 2416 解題筆記：Trie 每個節點記錄經過的單字數，單字的答案就是沿路計數的總和"
description: "2026-09-13 的 LeetCode 2416 解題紀錄"
date: 2026-09-13
tags: ["hard", "trie", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-13
- 提交紀錄：Accepted（一次通過）

## 解題思路

一個前綴的分數 = 有幾個單字以它開頭。每個單字的答案 = 它所有前綴的分數總和。

在 Trie 上，**一個節點代表一個前綴**，「有幾個單字以它開頭」就是「有幾個單字經過這個節點」。所以：

1. 建 Trie 時，每經過一個節點就把它的計數加 1。
2. 每個單字再走一次 Trie，把沿路的計數加起來。

## 我的解法

```python
class Solution:
    def sumPrefixScores(self, words: List[str]) -> List[int]:
        trie = {}                          # char -> [經過次數, 子節點]
        for word in words:
            node = trie
            for ch in word:
                if ch not in node:
                    node[ch] = [0, {}]
                node[ch][0] += 1
                node = node[ch][1]

        res = []
        for word in words:
            total, node = 0, trie
            for ch in word:
                total += node[ch][0]
                node = node[ch][1]
            res.append(total)
        return res
```

## 複雜度

時間 `O(總長度)`，建 Trie 和查詢各走一次。空間 `O(總長度)`。

我交的時候用了 293MB 記憶體：每個節點是 `[count, dict]`，Python 的小 dict 本身就有固定成本。用 class 搭配 `__slots__` 可以省一些。

## 要特別避免的錯誤

- 對每個前綴重新掃所有單字：`O(n · L^2)` 以上，太慢。
- 計數加在子節點建立的時候而不是每次經過的時候：重複出現的前綴會少算。

## 面試口說整理

Trie 的每個節點代表一個前綴，以這個前綴開頭的單字數，就是經過這個節點的單字數。所以我建 Trie 時在每個經過的節點上計數加 1，之後每個單字再走一次 Trie，把沿路的計數加總就是答案。建立和查詢都是總長度的線性時間。
