---
title: "LeetCode 334: Increasing Triplet Subsequence"
summary: "LeetCode 334 note: keep the smallest first and the smallest second that has something smaller before it; any number above second completes a triplet"
description: "LeetCode 334 record from 2022-11-17"
date: 2022-11-17
tags: ["medium", "array", "greedy", "longest-increasing-subsequence"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-17
- Submissions: Time Limit Exceeded → Runtime Error → Accepted → Wrong Answer

## Approach

Greedy ([Greedy]({{< relref "/algorithm/Greedy" >}})): `first` is the smallest value so far, and `second` is the smallest value that has some smaller value before it. For each `x`: if `x <= first` update `first`; else if `x <= second` update `second`; else `x > second` completes a triplet. Updating `first` leaves `second` valid, since a smaller value already preceded it. **Compare with `<=`**; equal values are not increasing.

## My Attempts

- The first 2022 version enumerated three indices recursively and timed out exponentially. Switching to the `first`/`second` greedy above passed.
- A 2025 rewrite used `if first > num: first, second = num, first` and `elif second > num`:
  - With strict `>`, **a value equal to `first` fell to the next branch and became `second`**: `[0, 0, 1]` returned `True` instead of `False`.
  - Shifting the old `first` into `second` is also wrong in itself: the old `first` need not have a smaller value before it.

## Solution

```python
class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:
        first = second = float("inf")
        for x in nums:
            if x <= first:
                first = x
            elif x <= second:
                second = x
            else:
                return True
        return False
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Use `<=`: a value equal to `first` cannot serve as `second`.
- Do not shift the old `first` into `second` when updating `first`.
- Enumerating three indices is `O(n³)`.

## Interview Explanation

I keep first, the smallest value so far, and second, the smallest value with something smaller before it; a new value updates first, else second, and anything larger than second completes the triplet. Time `O(n)`, space `O(1)`.
