---
title: "LeetCode 3555: Smallest Subarray to Sort in Every Sliding Window"
summary: "LeetCode 3555 note: every length-k window is one instance of LeetCode 581; with n only 1000, two O(k) scans per window are enough"
description: "LeetCode 3555 record from 2026-01-29"
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
- Submissions: Accepted (first try)

## Approach

Each window asks exactly [LeetCode 581]({{< relref "/leetcode/LeetCode-581" >}}): what is the shortest segment to sort so the whole window is non-decreasing?

- Scan left to right with a running max; the last index `< max` is the right boundary.
- Scan right to left with a running min; the last index `> min` is the left boundary.

With `n <= 1000` there are `n - k + 1` windows at `O(k)` each, at most about `n^2 / 4` operations, which is fast enough.

## My Solution

```python
class Solution:
    def minSubarraySort(self, nums: List[int], k: int) -> List[int]:
        def unsorted_len(lo: int, hi: int) -> int:     # LeetCode 581 on nums[lo..hi]
            max_seen, end = float("-inf"), -1
            for i in range(lo, hi + 1):
                if nums[i] < max_seen:
                    end = i
                else:
                    max_seen = nums[i]
            if end == -1:
                return 0
            min_seen, start = float("inf"), -1
            for i in range(hi, lo - 1, -1):
                if nums[i] > min_seen:
                    start = i
                else:
                    min_seen = nums[i]
            return end - start + 1

        return [unsorted_len(i, i + k - 1) for i in range(len(nums) - k + 1)]
```

My original copied each window with `nums[i:i + k]`; passing indices avoids the copy.

## Complexity

Time `O((n - k + 1) · k)`, space `O(1)` excluding the output.

## Mistakes to Avoid

- Return 0 for windows that are already sorted.
- Use the window's index range for the boundaries, not the whole array.

## Interview Explanation

Each window is one run of 581: a running max from the left finds the right boundary, and a running min from the right finds the left boundary. `n` is only 1000, so two `O(k)` scans per window give `O(n · k)` overall. For large `n` I would need to maintain the boundaries incrementally as the window slides.
