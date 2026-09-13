---
title: "LeetCode 174: Dungeon Game"
summary: "LeetCode note for Dungeon Game, rebuilt from the original learning note"
description: "Cleaned LeetCode 174 article from 2026-06-30 with note repair points and final solution"
date: 2026-06-30
tags: ["hard", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-06-30
Source: Day 31 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 174`: pass after wording repair
- `LC 221` and `LC 174` are both 2D DP, but they are not the same recurrence family as the earlier grid problems.
- explain `LC 174` with reverse DP and the `minimum required health on entry` state

## Learning Note Extract

#### Problem 2 - LC 174 Dungeon Game
- **Pattern:** reverse 2D DP with minimum required resource.

#### Why This Fits
Forward DP feels tempting but usually creates the wrong state question.

The real requirement is not:
```text
what is the best health after arriving here?
```

It is:
```text
what minimum health must I have when entering this cell so that I can still survive to the goal?
```

That naturally points backward from the destination.

#### Core State / Invariant
```text
dp[r][c] = minimum health required upon entering cell (r, c) to guarantee survival through the destination
```

This is the interview-safe state because it encodes the safety guarantee directly.

#### Transition
Let the cheaper required next state be:
```text
need_next = min(dp[r + 1][c], dp[r][c + 1])
```

Then:
```text
dp[r][c] = max(1, need_next - dungeon[r][c])
```

Why:
- if the current cell gives health, required entry health can drop
- if the current cell deals damage, required entry health rises
- health can never be below `1`

#### Base Case
At the destination:
```text
dp[last_row][last_col] = max(1, 1 - dungeon[last_row][last_col])
```

Reason:
- after processing the last cell, the knight must still have at least `1` health

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
- trying to maximize remaining health instead of minimizing required entry health
- doing forward DP with an unstable state
- forgetting the clamp to `1`
- using `max(down, right)` instead of `min(down, right)` for the required next state
- getting the destination base case wrong

#### Strong Spoken Explanation
I solve this backward because the meaningful state is the minimum health required when entering a cell so that I can still reach the princess alive. From each cell, I only care about the cheaper of the two required next states, right or down. Then I subtract the current cell value because healing reduces the needed entry health and damage increases it. Finally I clamp the result to at least `1`, because the knight can never be dead or at zero health.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def calculateMinimumHP(self, dungeon: List[List[int]]) -> int:
        m, n = len(dungeon), len(dungeon[0])
        dp = [float('inf')] * (n + 1)
        dp[n - 1] = 1

        for r in range(m - 1, -1, -1):
            for c in range(n - 1, -1, -1):
                need = min(dp[c], dp[c + 1]) - dungeon[r][c]
                dp[c] = max(1, need)

        return dp[0]
```

## Complexity

Time O(mn), Space O(n).

## Mistakes To Watch

- Forward DP cannot know future minimum health constraints cleanly.
- Forgetting health must always be at least 1.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
