---
title: "LeetCode 747: Largest Number At Least Twice of Others"
summary: "LeetCode 747 note: find the largest and second largest in one pass and return the largest's index if it is at least twice the second; multiply to avoid dividing by zero"
description: "LeetCode 747 record from 2022-09-03"
date: 2022-09-03
tags: ["easy", "array", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-03
- Submissions: Runtime Error → Wrong Answer → Runtime Error ×2 → Wrong Answer → Accepted → Runtime Error ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted ×2

## Approach

If the largest is at least twice the second largest, it is at least twice every other value ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1). In one pass track the largest, its index and the second largest: a new maximum demotes the old one to second; **otherwise** compare with the second. Test `max >= 2 * second` without division, so a second largest of 0 is fine.

## My Attempts

This took 17 submissions:

- At first I divided, `max_ / max(nums)`, raising **ZeroDivisionError** when the others were 0, and special-cased `set(nums) == {0}` to pass.
- Rewriting as one pass for the largest and second largest, the second check was an `if` rather than an `elif`, **so a freshly updated maximum also became the second largest**: `[7, 0]` returned -1 instead of 0. Other versions returned the value instead of the index or still divided. `elif` with `max_ >= 2 * sec_max` passed.

## Solution

```python
class Solution:
    def dominantIndex(self, nums: List[int]) -> int:
        first = second = -1
        idx = -1
        for i, x in enumerate(nums):
            if x > first:
                first, second, idx = x, first, i
            elif x > second:
                second = x
        return idx if first >= 2 * second else -1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Compare by multiplying; division fails on 0.
- Update the second largest in an `elif`, or the maximum becomes its own runner-up.
- Return the index, not the value.

## Interview Explanation

If the largest is at least twice the runner-up it beats everyone, so one pass records the largest, its index and the runner-up, and I compare by multiplication to avoid dividing by zero. Time `O(n)`, space `O(1)`.
