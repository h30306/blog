---
title: "LeetCode 3627: Maximum Median Sum of Subsequences of Size 3"
summary: "LeetCode 3627 note: after sorting, each group takes the two largest and the smallest, with the second largest as the median; the answer takes every other value from the end, n / 3 of them"
description: "LeetCode 3627 record from 2025-07-27"
date: 2025-07-27
tags: ["medium", "math", "greedy", "sorting", "game-theory", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-27
- Submissions: Time Limit Exceeded → Accepted

## Approach

Each step picks three numbers and scores their median. The largest of the three can never be the median, so:

- Every group takes **the two largest remaining** plus **the smallest remaining** as filler. The median is the smaller of the two large ones.
- The smallest `n / 3` numbers all serve as filler.

After sorting, the answer is `nums[-2] + nums[-4] + ...`, every other value from the end, `n / 3` of them.

## My Attempts

Attempt 1 simulated it: sort, then `pop()` twice and `pop(0)` once per step. `pop(0)` shifts the whole list, `O(n)` each, `O(n^2)` overall: TLE. Computing the indices directly passed.

## Solution

```python
class Solution:
    def maximumMedianSum(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        return sum(nums[n - 2 - 2 * i] for i in range(n // 3))
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- `list.pop(0)` is `O(n)`.
- The largest value in a group can only be its maximum, never its median, so each group "wastes" one large value.

## Interview Explanation

The largest number can never be a median, so each group takes the two largest remaining and the smallest remaining, scoring the second largest. After sorting, the answer takes every other value from the end, `n / 3` of them. Time `O(n log n)`.
