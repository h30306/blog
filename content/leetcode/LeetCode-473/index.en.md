---
title: "LeetCode 473: Matchsticks to Square"
summary: "LeetCode 473 note: the total must be divisible by 4; place sticks from longest to shortest into one of four sides, skipping a side that would overflow or that equals a side already tried"
description: "LeetCode 473 record from 2022-11-16"
date: 2022-11-16
tags: ["medium", "array", "dynamic-programming", "backtracking", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-16
- Submissions: Time Limit Exceeded → Accepted ×2 → Runtime Error ×3 → Time Limit Exceeded → Accepted ×2

## Approach

Placement backtracking ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template): each stick goes into one of four sides of length `total / 4`. Pruning matters:

- If the total is not divisible by 4, or the longest stick exceeds a side, return `False`.
- **Sort longest first**: big sticks fail fast.
- Skip a side the stick would overflow.
- If this side's current length equals a side already tried, the outcome is the same, so skip.

## My Attempts

This took 9 submissions:

- Attempt 1 was correct four-side backtracking but had no memoization or equal-side pruning, and timed out.
- The `@cache` version first had misspelled names (`value`, `e5`, NameError). After that **the four branches were summed with `+`**, forcing every branch to finish before adding, and it timed out again; one run happened to finish in time and was accepted (it returned an integer, nonzero counting as `True`).
- A 2022-11-27 rewrite with `or` and longest-first sorting passed reliably.

## Solution

```python
class Solution:
    def makesquare(self, matchsticks: List[int]) -> bool:
        total = sum(matchsticks)
        if total % 4:
            return False
        side = total // 4
        matchsticks.sort(reverse=True)
        if matchsticks[0] > side:
            return False
        sides = [0] * 4
        def dfs(i):
            if i == len(matchsticks):
                return True
            tried = set()
            for k in range(4):
                if sides[k] + matchsticks[i] > side or sides[k] in tried:
                    continue
                tried.add(sides[k])
                sides[k] += matchsticks[i]
                if dfs(i + 1):
                    return True
                sides[k] -= matchsticks[i]
            return False
        return dfs(0)
```

## Complexity

Worst case `O(4^n)`, passing thanks to pruning; space `O(n)`.

## Mistakes to Avoid

- Combine the four branches with `or` and return early; `+` explores every branch.
- Sort longest first; placing small sticks first discovers failures very deep.
- Sides of equal current length need only one try.

## Interview Explanation

The total must divide by 4, giving the side length. I sort sticks longest first and backtrack placing each into one of four sides, skipping overflows and sides whose current length was already tried since they behave identically. Exponential in the worst case, but fast with pruning.
