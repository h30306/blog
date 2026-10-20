---
title: "LeetCode 1989: Maximum Number of People That Can Be Caught in Tag"
summary: "LeetCode 1989 note: process the \"it\" players left to right, each catching the leftmost uncaught person in range, with a right-only pointer to the next candidate"
description: "LeetCode 1989 record from 2026-01-27"
date: 2026-01-27
tags: ["medium", "two-pointers", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-27
- Submissions: Wrong Answer → Accepted (2026-01-28)

## Approach

Greedy: process the "it" players left to right, and **each catches the leftmost uncaught person in `[i - dist, i + dist]`**. People on the left can only be caught by this player or players further left, so saving them for later is useless; people on the right are left for later players, who have more options.

A pointer `j` points to the next person who might be caught:

- Skip all "it" players and people with `j < i - dist` (too far left; later players cannot reach them either).
- If `j <= i + dist`, catch them and advance `j`.

## My Attempts

Attempt 1 was driven by the people: `left` found the next person and `right` found the first "it" who could catch them. The problem: if nobody can catch that person, `right` keeps moving past every "it" player until `n`, when **the person should be skipped, not the players**.

For `team = [0, 0, 1]`, `dist = 1`, the person at 0 cannot be caught, but the "it" at 2 can catch the person at 1, so the answer is 1. Searching for someone to catch the person at 0, `right` passed the "it" at 2 and returned 0.

Driving the loop by the "it" players and letting the people pointer skip people that are too far left passed.

## Solution

```python
class Solution:
    def catchMaximumAmountofPeople(self, team: List[int], dist: int) -> int:
        n = len(team)
        caught = 0
        j = 0                                      # next candidate person
        for i in range(n):
            if team[i] != 1:
                continue
            while j < n and (team[j] == 1 or j < i - dist):
                j += 1                             # skip "it" players and people too far left
            if j < n and j <= i + dist:
                caught += 1
                j += 1
        return caught
```

## Complexity

Time `O(n)`: `i` and `j` only move right. Space `O(1)`.

## Mistakes to Avoid

- Skip the person who cannot be caught; do not skip the "it" players for them.
- Each "it" should catch the leftmost person in range, not the nearest.

## Interview Explanation

I process each "it" player left to right and let them catch the leftmost uncaught person in range, since later players are even less able to reach people on the left. A right-only pointer tracks the next candidate, skipping "it" players and people too far left, and if it is within range the person is caught. Both pointers only move right, so time is `O(n)`.
