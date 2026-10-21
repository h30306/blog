---
title: "LeetCode 3838: Weighted Word Mapping"
summary: "LeetCode 3838 解題筆記：每個字的權重加總取 mod 26，再反向對應字母：0 -> z，也就是 chr(ord('z') - r)"
description: "2026-02-14 的 LeetCode 3838 解題紀錄"
date: 2026-02-14
tags: ["easy", "array", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-02-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個字算出權重總和 `w`，取 `r = w % 26`。反向字母順序是 `0 -> 'z'`、`1 -> 'y'`…，所以對應的字母是 `chr(ord('z') - r)`（[Array]({{< relref "/algorithm/Array" >}}) 模板五）。

## 我的解法

```python
class Solution:
    def mapWordWeights(self, words: List[str], weights: List[int]) -> str:
        return "".join(
            chr(ord("z") - sum(weights[ord(c) - ord("a")] for c in w) % 26)
            for w in words
        )
```

## 複雜度

時間 `O(總字元數)`，空間 `O(字數)`。

## 要特別避免的錯誤

- 是反向對應，`0` 對到 `z`，不是 `a`。

## 面試口說整理

我對每個字加總字母的權重再 mod 26，用 `ord('z')` 減掉餘數得到反向對應的字母，最後串起來。時間 `O(總字元數)`。
