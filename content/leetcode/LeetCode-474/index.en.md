---
title: "LeetCode 474: Ones and Zeroes"
summary: "LeetCode note for Ones and Zeroes, rebuilt from the original learning note"
description: "Cleaned LeetCode 474 article from 2026-08-19 with note repair points and final solution"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-19
Source: Day 45 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 474`: pass after invariant wording repair
- explain `LC 474` as a two-capacity `0/1` knapsack with backward loops in both dimensions

## Learning Note Extract

#### Problem 1 - LC 474 Ones and Zeroes
- **Pattern:** two-capacity `0/1` knapsack maximization.

#### Why This Fits
Each string can be picked:
```text
at most once
```

Each picked string consumes:
- some zeros
- some ones

The value of picking it is:
```text
+1 string in the subset
```

#### Core State / Invariant
```text
dp[i][j] = maximum number of strings we can pick from the strings processed so far
using at most i zeros and j ones
```

#### Base Case
Initialize the whole table to:
```text
0
```

Reason:
```text
before processing any strings, the best answer is 0
```

#### Transition
For a string with `zeros` and `ones`:
```text
dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)
```

#### Why Both Loops Go Backward
The transition reads:
```text
dp[i - zeros][j - ones]
```

That source state must still belong to:
```text
previous strings only
```

If either capacity loop goes forward, the same string can be reused again in the same iteration.

#### Complexity
```text
Time: O(len(strs) * m * n)
Space: O(m * n)
```

#### Common Mistakes
- forgetting this is two-capacity, not one-capacity
- saying the value is zeros or ones instead of number of strings chosen
- going forward in one dimension and backward in the other
- omitting `processed so far` from the invariant

#### Strong Spoken Explanation
This is a two-capacity `0/1` knapsack. Each string is an item, its cost is `(zeroCount, oneCount)`, and its value is `1` because taking that string increases the answer by one. I use `dp[i][j]` to mean the maximum number of strings I can pick from the strings processed so far using at most `i` zeros and `j` ones. For each string, I count its zeros and ones, then iterate both capacities backward and update `dp[i][j] = max(dp[i][j], dp[i - zeros][j - ones] + 1)`. Both loops must go backward so the current string is only used once.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def findMaxForm(self, strs: List[str], m: int, n: int) -> int:
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for s in strs:
            zeros = s.count('0')
            ones = len(s) - zeros
            for z in range(m, zeros - 1, -1):
                for o in range(n, ones - 1, -1):
                    dp[z][o] = max(dp[z][o], dp[z - zeros][o - ones] + 1)

        return dp[m][n]
```

## Complexity

Time O(len(strs)*m*n), Space O(m*n).

## Mistakes To Watch

- Iterating capacities forward and reusing the same string.
- Tracking only one capacity.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
