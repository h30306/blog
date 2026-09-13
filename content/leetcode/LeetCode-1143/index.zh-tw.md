---
title: "LeetCode 1143: Longest Common Subsequence"
summary: "LeetCode 1143 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-11 的 LeetCode 1143 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-11
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
第一次嘗試：2026-07-11
來源：Day 36 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 1143`: pass after mismatch-proof wording repair
- explain `LC 1143` with exact prefix-based state and mismatch transition

## 當天筆記摘錄

#### Problem 1 - LC 1143 Longest Common Subsequence
- **Pattern:** 2D DP on two prefixes.

#### Why This Fits
At any pair of positions, the question is:
```text
what is the LCS length for the prefixes up to these two positions?
```

That naturally gives a 2D table over:
- prefix of `text1`
- prefix of `text2`

#### Core State / Invariant
```text
dp[i][j] = length of the longest common subsequence between text1[:i] and text2[:j]
```

#### Base Case
If either prefix is empty:
```text
dp[i][0] = 0
dp[0][j] = 0
```

Reason:
```text
an empty string has no common subsequence with positive length
```

#### Transition
If the new characters match:
```text
text1[i - 1] == text2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1] + 1
```

If they do not match:
```text
dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
```

#### Why This Works
- match:
  - the matching characters can extend the best subsequence from the smaller prefixes
- mismatch:
  - one of the two last characters is not used, so drop one side and keep the better answer

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
- using substring instead of subsequence reasoning
- mixing character index with prefix length index
- forgetting that mismatch takes `max(up, left)`
- saying diagonal is used on every step

#### Strong Spoken Explanation
I define `dp[i][j]` as the LCS length between the prefixes `text1[:i]` and `text2[:j]`. The base row and base column are zero because an empty prefix cannot contribute any positive common subsequence. If the current characters match, I extend the smaller-prefix answer from the diagonal by one. If they do not match, I drop one side and keep the better result from `up` or `left`. The final answer is `dp[m][n]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def longestCommonSubsequence(self, text1: str, text2: str) -> int:
        m, n = len(text1), len(text2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if text1[i - 1] == text2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else:
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

        return dp[m][n]
```

## 複雜度

Time O(mn), Space O(mn), compressible to O(n).

## 要特別避免的錯誤

- Using substring logic; subsequence does not require contiguous characters.
- On mismatch, incorrectly taking diagonal.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
