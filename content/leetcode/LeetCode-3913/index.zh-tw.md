---
title: "LeetCode 3913: Sort Vowels by Frequency"
summary: "LeetCode 3913 解題筆記：只把母音抽出來，用（-次數, 第一次出現的位置）排序，再放回原本母音的位置"
description: "2026-04-26 的 LeetCode 3913 解題紀錄"
date: 2026-04-26
tags: ["medium", "string", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

子音的位置不動，只重排母音（[String]({{< relref "/algorithm/String" >}}) 模板四）：

1. 掃一次，記每個母音的次數和第一次出現的位置。
2. 把母音依序抽出來，用 `(-次數, 第一次出現的位置)` 排序：次數大的在前，一樣多時先出現的在前。
3. 再掃一次，遇到母音的位置就依序放回排好的母音。

## 我的解法

```python
class Solution:
    def sortVowels(self, s: str) -> str:
        vowels = set("aeiou")
        count, first = Counter(), {}
        for i, ch in enumerate(s):
            if ch in vowels:
                count[ch] += 1
                first.setdefault(ch, i)
        ordered = sorted((ch for ch in s if ch in vowels), key=lambda ch: (-count[ch], first[ch]))
        it = iter(ordered)
        return "".join(next(it) if ch in vowels else ch for ch in s)
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。母音只有 5 種，也可以直接照順序展開每種母音的個數，變成 `O(n)`。

## 要特別避免的錯誤

- 同樣次數時比的是**第一次出現的位置**，不是字母順序。
- 只有母音的位置會被換掉，子音保持原位。

## 面試口說整理

我先數每個母音的次數和第一次出現的位置，把母音抽出來用（負次數, 第一次位置）排序，再依序放回原本母音的位置。時間 `O(n log n)`，因為母音只有 5 種也可以做到 `O(n)`。
