---
title: "LeetCode 3839: Number of Prefix Connected Groups"
summary: "LeetCode 3839 解題筆記：前 k 個字元相同的字互相連通，用 word[:k] 當 key 計數；長度不到 k 的字要排除"
description: "2026-02-14 的 LeetCode 3839 解題紀錄"
date: 2026-02-14
tags: ["medium", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-14
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

「前 `k` 個字元相同」是等價關係，所以同一個前綴的字自成一組，不用 Union-Find。用 `word[:k]` 當 key 計數，至少兩個字的 key 就是一組（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。

## 我的嘗試

第一版沒有排除**長度不到 `k`** 的字：Python 的 `word[:k]` 不會報錯，只會回傳整個字。例如 `["b", "b"]`、`k = 2`：兩個字都太短，答案是 0，這版把兩個 `"b"` 算成一組，回傳 1。加上 `len(g) == k` 就 AC 了。

## 正確解法

```python
class Solution:
    def prefixConnected(self, words: List[str], k: int) -> int:
        cnt = Counter(w[:k] for w in words if len(w) >= k)
        return sum(v >= 2 for v in cnt.values())
```

## 複雜度

時間 `O(n · k)`，空間 `O(n · k)`。

## 要特別避免的錯誤

- 切片超過長度不會報錯，太短的字要自己排除。

## 面試口說整理

前 `k` 個字元相同就連通，而且這是等價關係，所以每個前綴就是一組。我用 `word[:k]` 計數，排除太短的字，最後數有幾個前綴至少出現兩次。時間 `O(nk)`。
