---
title: "LeetCode 53: Maximum Subarray"
summary: "LeetCode Problem Solving - 1D DP with rolling state / Kadane's algorithm"
description: "LeetCode study note from 2026-05-10"
date: 2026-05-10
tags: ["leetcode", "medium", "dynamic-programming", "kadane"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-10
Source Note: `notes/day21-week4-weekend-day2-api-recall-speed-round.md`

## Intuition

This is 1D DP with rolling state, also known as Kadane's algorithm. I define curr as the maximum subarray sum ending at the current index, and best as the maximum subarray sum seen so far. For each element, the best suba

Pattern: 1D DP with rolling state / Kadane's algorithm

## Approach

- **Pattern:** 1D DP with rolling state / Kadane's algorithm.

## Correct State
```text
curr = maximum subarray sum ending at the current index
best = maximum subarray sum seen so far
```

## Why This State Fits
For any index `i`, the best subarray ending at `i` has only 2 possibilities:
- start fresh at `nums[i]`
- extend the best subarray ending at `i - 1`

That gives the recurrence:
```text
curr = max(nums[i], curr + nums[i])
best = max(best, curr)
```

## Initialization
```text
curr = best = nums[0]
```

Why:
```text
all-negative arrays are valid, so initializing to 0 would be wrong
```

## Complexity
```text
Time: O(n)
Space: O(1)
```

## Common Mistakes
- saying `curr` is just "current subarray sum" instead of the exact ending-here invariant
- initializing to `0`, which breaks all-negative arrays
- returning `curr` instead of `best`

## Interview-Ready Explanation
This is 1D DP with rolling state, also known as Kadane's algorithm. I define `curr` as the maximum subarray sum ending at the current index, and `best` as the maximum subarray sum seen so far. For each element, the best subarray ending here either starts fresh at this element or extends the previous ending-here subarray, so `curr = max(nums[i], curr + nums[i])`. Then I update `best = max(best, curr)`. I initialize both to `nums[0]` so all-negative arrays are handled correctly. The time complexity is `O(n)` and the space complexity is `O(1)`.

## Code
```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]

        for i in range(1, len(nums)):
            curr = max(nums[i], curr + nums[i])
            best = max(best, curr)

        return best
```

## Findings

- Keep the state meaning explicit before writing the transition.
- Check base cases and return value before trusting the recurrence.
- Explain why the iteration order or traversal order preserves the intended invariant.

## Encountered Problems

Pass.
