---
title: "LeetCode 3952: Maximum Total Value of Covered Indices"
summary: "LeetCode 3952 note: each token moves left at most once, so the state is whether this index's token moved left; moving only helps if the index to the left was not already covered"
description: "LeetCode 3952 record from 2026-06-11"
date: 2026-06-11
tags: ["medium", "dynamic-programming", "state-machine", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-11
- Submissions: Accepted (first try)

## Approach

A token moves left at most one step, so the token at `i` only affects indices `i - 1` and `i`. Run a state machine DP left to right on **whether the token at `i` moved left**:

- `stay`: best after the first `i` indices with the token at `i` staying (or no token at `i`).
- `move`: best after the first `i` indices with the token at `i` moved to `i - 1`.

Transitions at index `i`:

- **No token**: both states are `max(move, stay)`.
- **Token stays**: `max(move, stay) + nums[i]`.
- **Token moves left**: index `i - 1` becomes covered, but it may already have been:
  - If `i - 1` also has a token, covering it helps only if that token moved away (the `move` state): `move + nums[i - 1]`.
  - If `i - 1` has no token, it was certainly uncovered: `max(move, stay) + nums[i - 1]`.

All values are positive, so taking a value is never worse.

## My Solution

```python
class Solution:
    def maxTotal(self, nums: List[int], s: str) -> int:
        move = float("-inf")                       # the token at index 0 cannot move left
        stay = nums[0] if s[0] == "1" else 0
        for i in range(1, len(nums)):
            best = max(move, stay)
            if s[i] == "1":
                new_stay = best + nums[i]
                if s[i - 1] == "1":
                    new_move = move + nums[i - 1]  # only free if the left token moved away
                else:
                    new_move = best + nums[i - 1]
            else:
                new_stay = new_move = best
            move, stay = new_move, new_stay
        return max(move, stay)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- When moving left, do not count the left index again if it is already covered.
- The token at index 0 cannot move left, so `move` starts at negative infinity.

## Interview Explanation

Each token moves left at most once, so I run a left-to-right state machine DP on whether this index's token moved left. Staying adds this index's value; moving adds the left index's value, but if the left index has its own token, it is empty only if that token moved away, so the transition comes only from the `move` state. Time `O(n)`.
