---
title: "LeetCode 1092: Shortest Common Supersequence"
summary: "LeetCode 1092 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-25 的 LeetCode 1092 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-25
tags: ["hard", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-25
來源：Day 41 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 1092`: pass after wording repair
- explain `LC 1092` using an `LCS` table plus reconstruction, including why matches are appended once
- `LC 1092` vs `LC 1143`

## 當天筆記摘錄

#### Problem 1 - LC 1092 Shortest Common Supersequence
- **Pattern:** 2D DP with reconstruction over two prefixes.

#### Why This Fits
The question is:
```text
what is the shortest string that contains str1 and str2 as subsequences?
```

The cleanest interview route is:
- first compute the `LCS` table
- then walk backward to build one shortest supersequence

Why this is strong:
- it reuses the Week 7 anchor table you already know
- it makes the overlap explicit:
  - matched characters should appear once
  - non-overlapping characters must still be preserved in order

#### Core State / Invariant
```text
lcs[i][j] = length of the longest common subsequence between str1[:i] and str2[:j]
```

#### Base Cases
If either prefix is empty:
```text
lcs[i][0] = 0
lcs[0][j] = 0
```

Reason:
```text
an empty string contributes no shared subsequence
```

#### Transition
If the current characters match:
```text
str1[i - 1] == str2[j - 1]
=> lcs[i][j] = lcs[i - 1][j - 1] + 1
```

If they do not match:
```text
lcs[i][j] = max(lcs[i - 1][j], lcs[i][j - 1])
```

#### Reconstruction Rule
Start from `(m, n)` and walk backward:

If the current characters match:
```text
append that character once
move diagonally
```

If they do not match:
- if `lcs[i - 1][j] >= lcs[i][j - 1]`
  - append `str1[i - 1]`
  - move up
- else
  - append `str2[j - 1]`
  - move left

After one string is exhausted:
- append the remaining tail of the other string
- reverse the built result at the end

#### Why This Works
The `LCS` table tells you where the overlap is.

So during reconstruction:
- a matched character belongs once in the final answer
- on mismatch, moving toward the larger `LCS` value preserves more shared overlap
- the character from the side you move off must still appear in the supersequence, so you append it

The result keeps:
- all characters from `str1` in order
- all characters from `str2` in order
- shared characters only once when possible

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Reconstruction adds:
```text
O(m + n)
```

#### Common Mistakes
- returning only the length instead of reconstructing the string
- appending a matched character twice
- forgetting to reverse the built answer
- forgetting to append the remaining tail when one string finishes first
- using `LC 72` edit-cost wording instead of subsequence / overlap wording
- assuming the output is unique when multiple shortest supersequences can exist

#### Strong Spoken Explanation
I first compute the standard `LCS` table, where `lcs[i][j]` is the LCS length of `str1[:i]` and `str2[:j]`. That table tells me which characters can be shared. Then I reconstruct from the bottom-right. If the current characters match, I append the character once and move diagonally because that overlap should appear only once in the shortest supersequence. If they do not match, I move toward the neighbor with the larger `LCS` value and append the character from the side I moved off, because that character still has to be preserved in order. After the walk, I append any remaining tail and reverse the result. The table takes `O(m * n)` time and space, and reconstruction is linear.

#### Alternative Direct DP
There is also a direct length DP:
```text
scs[i][j] = length of the shortest common supersequence of str1[:i] and str2[:j]
```

with:
```text
match    -> 1 + scs[i - 1][j - 1]
mismatch -> 1 + min(scs[i - 1][j], scs[i][j - 1])
```

Interview-safe rule:
- mention it if asked
- but the `LCS + reconstruction` route is easier to derive from Week 7 anchors in real time

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def shortestCommonSupersequence(self, str1: str, str2: str) -> str:
        m, n = len(str1), len(str2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if str1[i - 1] == str2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1] + 1
                else:
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

        i, j = m, n
        ans = []
        while i > 0 and j > 0:
            if str1[i - 1] == str2[j - 1]:
                ans.append(str1[i - 1])
                i -= 1
                j -= 1
            elif dp[i - 1][j] >= dp[i][j - 1]:
                ans.append(str1[i - 1])
                i -= 1
            else:
                ans.append(str2[j - 1])
                j -= 1

        while i > 0:
            ans.append(str1[i - 1])
            i -= 1
        while j > 0:
            ans.append(str2[j - 1])
            j -= 1

        return ''.join(reversed(ans))
```

## 複雜度

Time O(mn), Space O(mn).

## 要特別避免的錯誤

- Returning the LCS instead of the supersequence.
- Appending both matching characters instead of one.
- Forgetting to append leftovers after one string is exhausted.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
