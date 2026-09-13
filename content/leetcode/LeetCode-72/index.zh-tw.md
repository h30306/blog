---
title: "LeetCode 72: Edit Distance"
summary: "LeetCode 72 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-16 的 LeetCode 72 學習紀錄，包含筆記修正點與正確解法"
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

- `LC 72` tests whether you can name each edit operation from source to target without mixing up insert vs delete.
- `LC 72`: pass after repair
- `LC 72` space optimization: pass after repair
- compare `LC 72` vs `LC 97` state and transition shape in one clean answer
- explain `LC 72` with exact source-to-target operation meaning for insert, delete, and replace

## 當天筆記摘錄

#### Problem 1 - LC 72 Edit Distance
- **Pattern:** 2D DP on two prefixes with edit operations.

#### Why This Fits
At each table cell, the question is:
```text
what is the minimum number of edits needed to convert word1[:i] into word2[:j]?
```

That naturally gives a 2D table over:
- source prefix of `word1`
- target prefix of `word2`

#### Core State / Invariant
```text
dp[i][j] = minimum number of operations needed to convert word1[:i] into word2[:j]
```

The direction matters:
- source = `word1`
- target = `word2`

#### Base Cases
If the target is empty:
```text
dp[i][0] = i
```

Reason:
```text
delete all i source characters
```

If the source is empty:
```text
dp[0][j] = j
```

Reason:
```text
insert all j target characters
```

#### Transition
If the current characters already match:
```text
word1[i - 1] == word2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = 1 + min(
    dp[i - 1][j],     # delete word1[i - 1]
    dp[i][j - 1],     # insert word2[j - 1]
    dp[i - 1][j - 1]  # replace word1[i - 1] with word2[j - 1]
)
```

#### Why This Works
- delete:
  - remove the last source character and solve the smaller source prefix
- insert:
  - create the last target character after solving the smaller target prefix
- replace:
  - align the last source character to the last target character in one step

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
- mixing up insert and delete because the source / target direction was never stated
- writing the right recurrence but being unable to explain what each branch means
- forgetting that the diagonal stays unchanged on a character match
- using vague language like `change one side`
- returning the wrong cell instead of `dp[m][n]`

#### Strong Spoken Explanation
I define `dp[i][j]` as the minimum edits needed to convert `word1[:i]` into `word2[:j]`. The first column is `i` because converting a non-empty source prefix into an empty target means deleting all source characters. The first row is `j` because converting an empty source into a non-empty target means inserting all target characters. If the current characters match, no extra edit is needed and I take the diagonal. Otherwise I try the three edit choices from the source-to-target point of view: delete the current source character, insert the current target character, or replace the current source character with the current target character. The answer is `dp[m][n]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        m, n = len(word1), len(word2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for i in range(m + 1):
            dp[i][0] = i
        for j in range(n + 1):
            dp[0][j] = j

        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if word1[i - 1] == word2[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]
                else:
                    dp[i][j] = 1 + min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])

        return dp[m][n]
```

## 複雜度

Time O(mn), Space O(mn), compressible to O(n).

## 要特別避免的錯誤

- Mixing source-to-target insert/delete meanings.
- Forgetting base row/column.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
