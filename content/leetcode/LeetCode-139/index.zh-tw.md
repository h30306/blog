---
title: "LeetCode 139: Word Break"
summary: "LeetCode 解題筆記：Word Break"
description: "2026-04-28 的 LeetCode 學習紀錄"
date: 2026-04-28
tags: ["medium", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-28
來源筆記：`notes/day15-week4-day1-word-break-rest-basics.md`

## 解題思路

這篇整理 Word Break 的解題筆記，重點放在 Prefix DP / segmentation DP、狀態定義、轉移式與容易犯錯的地方。

## 解法

以下內容整理自當天的 learning note，保留英文關鍵句，方便之後直接拿來做面試口說複習。

- **Pattern:** Prefix DP / segmentation DP.

## Why DP Fits
Whether a prefix can be segmented depends on whether a smaller prefix was already segmentable and whether the current suffix matches a dictionary word.

## State
```text
dp[i] = whether s[:i] can be segmented using wordDict
```

## Base Case
```text
dp[0] = True
```

Meaning:
```text
the empty prefix is segmentable
```

## Transition
For each index `i` and each word:
```text
if i >= len(word) and dp[i - len(word)] and s[i - len(word):i] == word:
    dp[i] = True
```

## Complexity
```text
Time: O(n * m * L)
Space: O(n)
```

Where:
```text
n = len(s)
m = len(wordDict)
L = word length / substring compare cost
```

## Main Implementation Repairs
- `dp` size must be:
```python
[False] * (len(s) + 1)
```
- loop bound must use:
```python
range(1, len(s) + 1)
```
- index must use:
```python
dp[i - len(word)]
```
not:
```python
dp[i - word]
```

## Interview-Ready Explanation
I define `dp[i]` as whether the prefix `s[:i]` can be segmented. The empty prefix is true. For each position, I try each dictionary word. If the prefix before that word is already segmentable and the current suffix equals the word, then the current prefix is segmentable too.

## 收穫

- 先講清楚 state meaning，再寫 recurrence。
- base case、迴圈方向、return value 要在 coding 前確認。
- 如果是 DP 壓縮、graph traversal、或 greedy frontier，要能說出 invariant 為什麼成立。

## 遇到的問題

Good enough after implementation repair.
