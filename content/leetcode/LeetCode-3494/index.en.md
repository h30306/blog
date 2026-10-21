---
title: "LeetCode 3494: Find the Minimum Amount of Time to Brew Potions"
summary: "LeetCode 3494 note: for each potion, push forward to get the last wizard's finish time (everyone must be free), then subtract backward to get each wizard's finish time"
description: "LeetCode 3494 record from 2025-03-23"
date: 2025-03-23
tags: ["medium", "simulation", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-03-23
- Submissions: Accepted (first try, but 11.7 s)

## Approach

`done[i]` is when wizard `i` finished the previous potion. When a potion reaches wizard `i`, they must already be free, and **no waiting** is allowed in between.

1. **Push forward**: pretend the potion moves down the line, taking `max(arrival, done[i])` at wizard `i` and adding this potion's work. The result is the last wizard's finish time `t`.
   - The no-waiting rule just delays the potion's start until the tightest wizard is free; delaying does not change the final finish time, so `t` is correct.
2. **Subtract backward**: with the final finish time known, each wizard's finish time is `t` minus the work of the wizards after them; update `done`.

After every potion, `done[n - 1]` is the answer.

## My Solution

```python
class Solution:
    def minTime(self, skill: List[int], mana: List[int]) -> int:
        n = len(skill)
        done = [0] * n                         # done[i]: wizard i finished the previous potion
        for m in mana:
            t = 0
            for i in range(n):                 # forward: everyone waits until free
                t = max(t, done[i]) + skill[i] * m
            for i in range(n - 1, -1, -1):     # backward: no waiting in between
                done[i] = t
                t -= skill[i] * m
        return done[-1]
```

## Complexity

Time `O(n · m)`, space `O(n)`. Python is slow at `5000 × 5000` (it took me 11.7 s to pass); a faster version uses prefix sums of `skill` to write each potion's start time as one `max`, with the same complexity.

## Mistakes to Avoid

- Pushing forward alone is not enough: someone would be waiting, so the start is really delayed, and each wizard's true finish time comes from subtracting backward.

## Interview Explanation

I track when each wizard finished the previous potion. A new potion is pushed forward with everyone waiting until free, giving the last wizard's finish time; since waiting is not allowed, I subtract backward from the last wizard to get everyone's finish time. After all potions, the last wizard's time is the answer. Time `O(nm)`.
