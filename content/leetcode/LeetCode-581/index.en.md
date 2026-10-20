---
title: "LeetCode 581: Shortest Unsorted Continuous Subarray"
summary: "LeetCode 581 note: scanning left to right with a running max, the last index below it is the right boundary; scanning right to left with a running min, the last index above it is the left boundary"
description: "LeetCode 581 record from 2026-01-29"
date: 2026-01-29
tags: ["medium", "two-pointers", "greedy", "sorting", "array", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-29
- Submissions: Accepted ×2

## Approach

The range to sort, `[start, end]`, is:

- **Right boundary `end`**: scan left to right with a running max `max_seen`. If `nums[i] < max_seen`, something larger sits to its left, so `nums[i]` must be sorted: `end = i`. The last such `i` is the boundary.
- **Left boundary `start`**: symmetrically scan right to left with a running min `min_seen`; the last `i` with `nums[i] > min_seen` is the boundary.

Everything right of `end` is `>=` all earlier values and increasing, so it is already in place; likewise left of `start`.

The two scans are like moving in from both ends to find the first misplaced value, except the comparison is against the extreme of the other side, not the neighbor.

## My Solution

```python
class Solution:
    def findUnsortedSubarray(self, nums: List[int]) -> int:
        n = len(nums)
        max_seen, end = float("-inf"), -1
        for i in range(n):
            if nums[i] < max_seen:
                end = i                            # something larger is on its left
            else:
                max_seen = nums[i]
        if end == -1:
            return 0                               # already sorted

        min_seen, start = float("inf"), -1
        for i in range(n - 1, -1, -1):
            if nums[i] > min_seen:
                start = i                          # something smaller is on its right
            else:
                min_seen = nums[i]
        return end - start + 1
```

## Complexity

Time `O(n)`, space `O(1)`. The intuitive alternative sorts a copy and compares the first differing index from each end, `O(n log n)`.

## Mistakes to Avoid

- Finding only the first adjacent drop: for `[1, 3, 2, 0]`, the range must extend over everything larger than `0`, so the answer is the whole array, 4.
- Return 0 when already sorted, not `end - start + 1`.

## Interview Explanation

Scanning left to right with a running max, the last index whose value is below the max is the right boundary, since something larger is on its left. Scanning right to left with a running min, the last index above the min is the left boundary. Two linear scans: time `O(n)`, space `O(1)`.
