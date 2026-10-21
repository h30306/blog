---
title: "LeetCode 3803: Count Residue Prefixes"
summary: "LeetCode 3803 解題筆記：邊掃邊把字元加進集合，前綴的不同字元數等於長度 % 3 就算一個"
description: "2026-01-11 的 LeetCode 3803 解題紀錄"
date: 2026-01-11
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
第一次嘗試：2026-01-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

前綴一個字一個字變長，不同字元數用集合邊掃邊維護（[String]({{< relref "/algorithm/String" >}}) 模板四）。長度是 `i + 1`，比較 `len(seen) == (i + 1) % 3`。

## 我的解法

```python
class Solution:
    def residuePrefixes(self, s: str) -> int:
        seen, res = set(), 0
        for i, ch in enumerate(s):
            seen.add(ch)
            res += len(seen) == (i + 1) % 3
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（最多 26 種字元）。

## 要特別避免的錯誤

- 長度是 `i + 1`，不是 `i`。

## 面試口說整理

我由左到右掃，用集合記前綴裡出現過的字元，每一步比較集合大小和前綴長度 mod 3。時間 `O(n)`。因為長度 mod 3 最多是 2，不同字元數超過 2 之後就不可能再成立，可以提早結束。
