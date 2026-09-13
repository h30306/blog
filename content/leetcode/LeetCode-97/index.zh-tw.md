---
title: "LeetCode 97: Interleaving String"
summary: "LeetCode 97 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-16 的 LeetCode 97 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-16
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
第一次嘗試：2026-07-16
來源：Day 37 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 97`: pass after repair
- `LC 97` greedy-vs-DP explanation: pass after repair
- compare `LC 72` vs `LC 97` state and transition shape in one clean answer

## 當天筆記摘錄

#### Problem 2 - LC 97 Interleaving String
- **Pattern:** 2D DP on two prefixes with a derived third-string index.

#### Why This Fits
The real question is:
```text
can the prefix s3[:i + j] be formed by interleaving s1[:i] and s2[:j]?
```

That gives a 2D boolean table because:
- once `i` and `j` are known
- the third prefix length is already determined

#### Core State / Invariant
```text
dp[i][j] = whether s3[:i + j] can be formed by interleaving s1[:i] and s2[:j]
```

#### Required Guard
Before any DP:
```text
if len(s1) + len(s2) != len(s3):
    return False
```

Reason:
```text
an interleaving must consume every character exactly once
```

#### Base Case
```text
dp[0][0] = True
```

Reason:
```text
two empty prefixes can form the empty prefix of s3
```

#### Transition
Let:
```text
k = i + j - 1
```

Then:
```text
dp[i][j] is true if either:
1. dp[i - 1][j] is true and s1[i - 1] == s3[k]
2. dp[i][j - 1] is true and s2[j - 1] == s3[k]
```

#### Why This Works
At the last consumed position of `s3`, the character must have come from exactly one of:
- the end of the used prefix of `s1`
- the end of the used prefix of `s2`

If either smaller state is valid and the matching character fits, the current state is valid.

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- forgetting the length guard
- using `i + j` instead of `i + j - 1` for the current character index
- treating interleaving like substring alternation instead of order-preserving merge
- failing to explain why both transitions can be true at once
- losing track of what `dp[i][j]` means when speaking

#### Strong Spoken Explanation
I define `dp[i][j]` as whether the first `i + j` characters of `s3` can be formed by interleaving the first `i` characters of `s1` and the first `j` characters of `s2`. I first reject if the total lengths do not add up. The empty-empty state is true. For each cell, the last consumed character of `s3` must come either from `s1[i - 1]` or from `s2[j - 1]`, so I check whether either smaller state was already valid and that chosen source character matches the current character in `s3`. The final answer is `dp[len(s1)][len(s2)]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def isInterleave(self, s1: str, s2: str, s3: str) -> bool:
        m, n = len(s1), len(s2)
        if m + n != len(s3):
            return False

        dp = [False] * (n + 1)
        dp[0] = True
        for j in range(1, n + 1):
            dp[j] = dp[j - 1] and s2[j - 1] == s3[j - 1]

        for i in range(1, m + 1):
            dp[0] = dp[0] and s1[i - 1] == s3[i - 1]
            for j in range(1, n + 1):
                k = i + j - 1
                dp[j] = (dp[j] and s1[i - 1] == s3[k]) or (dp[j - 1] and s2[j - 1] == s3[k])

        return dp[n]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Forgetting the length check.
- Using i+j instead of i+j-1 for the s3 index.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
