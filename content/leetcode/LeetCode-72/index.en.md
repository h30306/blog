---
title: "LeetCode 72: Edit Distance"
summary: "LeetCode note for Edit Distance, rebuilt from the original learning note"
description: "Cleaned LeetCode 72 article from 2026-07-16 with note repair points and final solution"
date: 2026-07-16
tags: ["medium", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-16
Source: Day 37 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 72` tests whether you can name each edit operation from source to target without mixing up insert vs delete.
- `LC 72`: pass after repair
- `LC 72` space optimization: pass after repair
- compare `LC 72` vs `LC 97` state and transition shape in one clean answer
- explain `LC 72` with exact source-to-target operation meaning for insert, delete, and replace

## Learning Note Extract

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

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(mn), Space O(mn), compressible to O(n).

## Mistakes To Watch

- Mixing source-to-target insert/delete meanings.
- Forgetting base row/column.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
