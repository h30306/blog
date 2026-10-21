---
title: "LeetCode 3541: Find Most Frequent Vowel and Consonant"
summary: "LeetCode 3541 解題筆記：數每個字元的次數，母音取最大、子音取最大再相加；沒有的那一類算 0"
description: "2025-05-10 的 LeetCode 3541 解題紀錄"
date: 2025-05-10
tags: ["easy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-05-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

用 `Counter` 數每個字元，再分成母音和子音兩類各取最大值（[String]({{< relref "/algorithm/String" >}}) 模板四）。某一類完全沒有時算 0，用 `max(..., default=0)`。

## 我的解法

我當時先把 `Counter` 依次數排序再掃一遍；排序是多餘的，直接取最大就好：

```python
class Solution:
    def maxFreqSum(self, s: str) -> int:
        vowels = set("aeiou")
        cnt = Counter(s)
        best_v = max((v for c, v in cnt.items() if c in vowels), default=0)
        best_c = max((v for c, v in cnt.items() if c not in vowels), default=0)
        return best_v + best_c
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（最多 26 種字元）。

## 要特別避免的錯誤

- 某一類沒有字元時，`max` 對空序列會報錯，要給 `default=0`。

## 面試口說整理

我數每個字元的次數，母音裡取最大、子音裡取最大，相加回傳；沒有的那一類算 0。時間 `O(n)`。
