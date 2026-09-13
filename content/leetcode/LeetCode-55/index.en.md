---
title: "LeetCode 55: Jump Game"
summary: "LeetCode note for Jump Game, rebuilt from the original learning note"
description: "Cleaned LeetCode 55 article from 2026-05-01 with note repair points and final solution"
date: 2026-05-01
tags: ["medium", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-01
Source: Day 16 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 1. Explain why `LC 55` is greedy, not DP.

## Learning Note Extract

#### Problem 1 - LC 55 Jump Game
- **Status:** Good enough after greedy correction.
- **Pattern:** Greedy reachable frontier.

#### Why Greedy Fits
At each index, the only future-relevant information is:
```text
how far to the right we can reach so far
```

We do not need to try every jump path. If an index is reachable, then the exact path that reached it no longer matters; only the farthest frontier matters.

#### Core Invariant
```text
farthest = farthest index reachable after scanning positions up to i
```

#### Failure Condition
```text
if i > farthest:
    current index is unreachable -> return False
```

#### Update Rule
```text
farthest = max(farthest, i + nums[i])
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- calling the best solution DP just because it scans left to right
- thinking greedy means "always physically take the biggest jump now"
- storing per-index state when only one frontier variable is needed

#### Interview-Ready Explanation
I scan left to right and keep the farthest index reachable so far. If I ever reach an index beyond that frontier, the answer is false. Otherwise I extend the frontier with `i + nums[i]`. If the frontier reaches the last index, the array is solvable.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def canJump(self, nums: List[int]) -> bool:
        farthest = 0
        for i, jump in enumerate(nums):
            if i > farthest:
                return False
            farthest = max(farthest, i + jump)
        return True
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Doing exhaustive DFS.
- Updating farthest from an unreachable index.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
