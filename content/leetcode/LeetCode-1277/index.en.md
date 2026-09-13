---
title: "LeetCode 1277: Count Square Submatrices With All Ones"
summary: "LeetCode note for Count Square Submatrices With All Ones, rebuilt from the original learning note"
description: "Cleaned LeetCode 1277 article from 2026-07-04 with note repair points and final solution"
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

- `LC 1277`: pass after state-definition repair
- explain `LC 1277` using the same local square state as `LC 221`, but with `sum(dp)` as the final aggregation

## Learning Note Extract

#### Problem 2 - LC 1277 Count Square Submatrices With All Ones
- **Pattern:** 2D DP on square geometry with count aggregation.

#### Why This Fits
This is the same local square-growth logic as `LC 221`, but the question changed from:
```text
what is the largest square?
```

to:
```text
how many all-1 squares exist in total?
```

So the state can stay almost the same, but the final aggregation changes.

#### Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

#### Transition
If `matrix[r][c] == 0`:
```text
dp[r][c] = 0
```

If `matrix[r][c] == 1` and not on the first row or first column:
```text
dp[r][c] = 1 + min(dp[r - 1][c], dp[r][c - 1], dp[r - 1][c - 1])
```

Boundary `1` cells contribute:
```text
dp[r][c] = 1
```

#### Why Summing DP Works
If `dp[r][c] = k`, then that cell is the bottom-right corner of:
- one `1 x 1` square
- one `2 x 2` square
- ...
- one `k x k` square

So each `dp[r][c]` contributes exactly `k` valid squares to the final count.

#### Final Answer
```text
answer = sum(dp[r][c] for all cells)
```

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
- reusing the `LC 221` state but still returning only the max
- forgetting that each side length contributes multiple squares
- using `max(...)` instead of `min(...)`
- not being able to explain why summing side lengths is valid

#### Strong Spoken Explanation
I reuse the same DP state as `LC 221`: `dp[r][c]` is the side length of the largest all-1 square ending at `(r, c)`. The recurrence stays the same because square growth still depends on top, left, and diagonal. The difference is the output: if a cell has largest side length `k`, it contributes `k` different valid squares ending there, so I sum all DP values instead of tracking only the maximum.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def countSquares(self, matrix: List[List[int]]) -> int:
        m, n = len(matrix), len(matrix[0])
        dp = [0] * (n + 1)
        total = 0

        for r in range(1, m + 1):
            prev_diag = 0
            for c in range(1, n + 1):
                old = dp[c]
                if matrix[r - 1][c - 1] == 1:
                    dp[c] = 1 + min(dp[c], dp[c - 1], prev_diag)
                    total += dp[c]
                else:
                    dp[c] = 0
                prev_diag = old

        return total
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Returning only the maximum side length like LC 221.
- Forgetting each side length from 1..dp[r][c] is a separate square.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
