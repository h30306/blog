---
title: "LeetCode 244: Shortest Word Distance II"
summary: "LeetCode 244 解題筆記：預處理每個字的出現位置（天然排序），查詢時對兩個位置列表做雙指針合併，每次移動比較小的那個"
description: "2026-02-02 的 LeetCode 244 解題紀錄"
date: 2026-02-02
tags: ["medium", "two-pointers", "design", "hash-table", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-02
- 提交紀錄：Accepted（一次通過）

## 解題思路

查詢會很多次，所以初始化時先用雜湊表記下每個字出現的所有位置。依序掃過陣列建表，**每個列表天然是排序好的**。

查詢 `word1`、`word2` 時，問題變成：兩個排序列表 `a`、`b`，找 `|a[i] - b[j]|` 的最小值。用雙指針：

- 比較 `a[i]`、`b[j]`，更新答案。
- **移動比較小的那個**：比較小的那個跟 `b`（或 `a`）後面的元素只會更遠，不用再看。

## 我的嘗試

我 AC 的版本是對兩個位置列表做雙層迴圈，每次查詢 `O(|a| · |b|)`。如果某個字出現很多次、查詢又很多，會很慢。改成雙指針後每次查詢是 `O(|a| + |b|)`。

## 正確解法

```python
class WordDistance:
    def __init__(self, wordsDict: List[str]):
        self.pos = defaultdict(list)
        for i, word in enumerate(wordsDict):
            self.pos[word].append(i)               # 依序加入，天然排序

    def shortest(self, word1: str, word2: str) -> int:
        a, b = self.pos[word1], self.pos[word2]
        i = j = 0
        best = float("inf")
        while i < len(a) and j < len(b):
            best = min(best, abs(a[i] - b[j]))
            if a[i] < b[j]:
                i += 1                             # a[i] 跟 b 後面的只會更遠
            else:
                j += 1
        return best
```

## 複雜度

初始化 `O(n)`，每次查詢 `O(|a| + |b|)`，空間 `O(n)`。

## 要特別避免的錯誤

- 每次查詢都重新掃整個陣列：沒用到「查詢很多次」這個條件。
- 雙層迴圈比較所有位置配對：`O(|a| · |b|)`。

## 面試口說整理

我在初始化時用雜湊表記下每個字的所有位置，因為是依序加入，列表本身就是排序的。查詢時對兩個列表做雙指針，更新差的最小值後，移動數值比較小的那個指針，因為它跟另一個列表後面的元素只會更遠。每次查詢 `O(|a| + |b|)`。
