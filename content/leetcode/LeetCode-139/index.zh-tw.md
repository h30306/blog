---
title: "LeetCode 139: Word Break"
summary: "LeetCode 139 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-28 的 LeetCode 139 學習紀錄，包含筆記修正點與正確解法"
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
來源：Day 15 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 139 Word Break
- **Status:** Good enough after implementation repair.
- **Pattern:** Prefix DP / segmentation DP.

#### Why DP Fits
Whether a prefix can be segmented depends on whether a smaller prefix was already segmentable and whether the current suffix matches a dictionary word.

#### State
```text
dp[i] = whether s[:i] can be segmented using wordDict
```

#### Base Case
```text
dp[0] = True
```

Meaning:
```text
the empty prefix is segmentable
```

#### Transition
For each index `i` and each word:
```text
if i >= len(word) and dp[i - len(word)] and s[i - len(word):i] == word:
    dp[i] = True
```

#### Complexity
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

#### Main Implementation Repairs
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

#### Interview-Ready Explanation
I define `dp[i]` as whether the prefix `s[:i]` can be segmented. The empty prefix is true. For each position, I try each dictionary word. If the prefix before that word is already segmentable and the current suffix equals the word, then the current prefix is segmentable too.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def wordBreak(self, s: str, wordDict: List[str]) -> bool:
        words = set(wordDict)
        max_len = max(map(len, words), default=0)
        n = len(s)
        dp = [False] * (n + 1)
        dp[0] = True

        for i in range(1, n + 1):
            for length in range(1, min(max_len, i) + 1):
                if dp[i - length] and s[i - length:i] in words:
                    dp[i] = True
                    break

        return dp[n]
```

## 複雜度

Time O(n * maxWordLen) substring checks, Space O(n).

## 要特別避免的錯誤

- Greedily matching the longest word.
- Not bounding j by the maximum word length.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
