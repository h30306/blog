---
title: "LeetCode 63: Unique Paths II"
summary: "LeetCode note for Unique Paths II, rebuilt from the original learning note"
description: "Cleaned LeetCode 63 article from 2026-06-27 with note repair points and final solution"
date: 2026-06-27
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
First Attempt: 2026-06-27
Source: Day 29 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 63`: pass after boundary pushback

## Learning Note Extract

#### Problem 2 - LC 63 Unique Paths II
- **Pattern:** 2D counting DP with blocked cells.

#### Why This Fits
This is the same table as `LC 62`, with one upgrade:
```text
some cells are unreachable because they are obstacles
```

So the real test is not a new pattern.

It is whether you can preserve the old state meaning under a new legality rule.

#### Core State / Invariant
```text
dp[r][c] = number of valid paths from the start to cell (r, c) without stepping on obstacles
```

#### Base Cases
If the start cell is blocked:
```text
answer = 0
```

Otherwise:
```text
dp[0][0] = 1
```

Boundary nuance:
- first row cells stay reachable only until the first obstacle appears
- first column cells stay reachable only until the first obstacle appears

Because after an obstacle on the boundary:
```text
there is no alternative route from above or left on that boundary
```

#### Transition
If the current cell is an obstacle:
```text
dp[r][c] = 0
```

Otherwise:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can also be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- forgetting that blocked start cell means immediate `0`
- filling the first row / first column with `1` even after an obstacle already appeared
- using the `LC 62` recurrence blindly without zeroing obstacle cells
- saying the obstacle cell is `-inf` or `None` instead of `0` ways

#### Strong Spoken Explanation
I keep the same state as `LC 62`: `dp[r][c]` is the number of valid paths to cell `(r, c)`. The difference is that obstacle cells contribute zero paths because I am not allowed to stand on them. If the start is blocked, the answer is immediately zero. For non-obstacle cells, the recurrence is still `up + left`, but the boundary initialization must stop once an obstacle appears because cells later on that boundary are no longer reachable from only one direction.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def uniquePathsWithObstacles(self, obstacleGrid: List[List[int]]) -> int:
        m, n = len(obstacleGrid), len(obstacleGrid[0])
        dp = [0] * n
        dp[0] = 1

        for r in range(m):
            for c in range(n):
                if obstacleGrid[r][c] == 1:
                    dp[c] = 0
                elif c > 0:
                    dp[c] += dp[c - 1]

        return dp[-1]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Not clearing dp[c] when hitting an obstacle.
- Assuming the start cell is always open.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
