---
title: "LeetCode 1984: Minimum Difference Between Highest and Lowest of K Scores"
summary: "LeetCode 1984 note: after sorting, the chosen k scores are always contiguous; slide a fixed window of length k and subtract its ends"
description: "LeetCode 1984 record from 2026-01-26"
date: 2026-01-26
tags: ["easy", "sliding-window", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-26
- Submissions: Accepted ×2

## Approach

After sorting, minimizing highest minus lowest means the `k` chosen scores are **contiguous**: if one in the middle were skipped, swapping it in for the highest or lowest could only shrink the difference or keep it.

A fixed window of length `k` has difference `nums[right] - nums[right - k + 1]`.

## My Solution

```python
class Solution:
    def minimumDifference(self, nums: List[int], k: int) -> int:
        nums.sort()
        return min(nums[i + k - 1] - nums[i] for i in range(len(nums) - k + 1))
```

My first accepted version maintained `left` by hand, plus an unused `min_num`; the second used `right - k + 1` as the left end directly, which is much cleaner.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Looking for a contiguous block without sorting: any `k` scores may be chosen, not a contiguous run.

## Interview Explanation

After sorting, the best `k` scores are contiguous, since including a skipped value never widens the gap. So I sort and slide a window of length `k`, where the difference is the two ends subtracted, and take the minimum. Time `O(n log n)`.
