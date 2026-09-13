---
title: "LeetCode 931: Minimum Falling Path Sum"
summary: "LeetCode note for Minimum Falling Path Sum, rebuilt from the original learning note"
description: "Cleaned LeetCode 931 article from 2026-07-04 with note repair points and final solution"
date: 2026-07-04
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-04
Source: Day 32 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 931`: pass after wording repair
- explain `LC 931` with the exact state, legal predecessor set, and why the answer is the min of the last row

## Learning Note Extract

#### Problem 1 - LC 931 Minimum Falling Path Sum
- **Pattern:** 2D optimization DP with three incoming directions.

#### Why This Fits
Each cell in row `r` can be reached from exactly one of 3 cells in row `r - 1`:
- up-left
- up
- up-right

The graph is still acyclic and local, so DP fits cleanly.

#### Core State / Invariant
```text
dp[r][c] = minimum falling path sum that ends at cell (r, c)
```

That state is exact because the question asks for:
```text
the minimum sum of any valid falling path from the first row to the last row
```

#### Base Case
First row:
```text
dp[0][c] = matrix[0][c]
```

Reason:
- a falling path can start at any cell in the first row

#### Transition
For each lower-row cell:
```text
dp[r][c] = matrix[r][c] + min(
    dp[r - 1][c],
    dp[r - 1][c - 1] if valid,
    dp[r - 1][c + 1] if valid
)
```

#### Final Answer
```text
answer = min(dp[last_row][c] for all c)
```

Because the path may end at any column in the last row.

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- returning `dp[last_row][last_col]` instead of the min over the last row
- forgetting diagonal parents
- mixing invalid columns into the recurrence without guarding them
- saying it is the same as `LC 64` when the predecessor set and answer shape are different

#### Strong Spoken Explanation
I define `dp[r][c]` as the minimum falling path sum ending at cell `(r, c)`. The first row is the base case because a path can start at any top-row cell. For each later cell, I take the minimum among the legal parents from the previous row: up-left, up, and up-right, then add the current cell value. The final answer is the minimum value in the last row because a falling path can end in any column there.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def minFallingPathSum(self, matrix: List[List[int]]) -> int:
        n = len(matrix)
        prev = matrix[0][:]

        for r in range(1, n):
            curr = [0] * n
            for c in range(n):
                best = prev[c]
                if c > 0:
                    best = min(best, prev[c - 1])
                if c + 1 < n:
                    best = min(best, prev[c + 1])
                curr[c] = matrix[r][c] + best
            prev = curr

        return min(prev)
```

## Complexity

Time O(n^2), Space O(n).

## Mistakes To Watch

- Returning bottom-right only; any bottom cell can end the path.
- Using LC 64 right/down movement instead of falling predecessors.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
