---
title: "LeetCode 3634: Minimum Removals to Balance Array"
summary: "LeetCode 3634 note: after sorting, what remains is always a contiguous block; for each minimum nums[left], a right-only pointer finds how far it can extend, and everything outside is removed"
description: "LeetCode 3634 record from 2026-01-10"
date: 2026-01-10
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-10
- Submissions: Accepted ×3 (written on 2026-01-10, 02-06 and 02-10)

## Approach

Only the max and min matter, not the order, so sort first.

After sorting, **the kept elements are always a contiguous block**: if `a` and `c` are kept, any `b` between them never makes the condition worse.

For each `nums[left]` as the minimum, find the farthest `right` with `nums[right] <= nums[left] * k`. The threshold only grows with `left`, so `right` never moves back. The removals are `left + (n - right)`.

## My Solution

```python
class Solution:
    def minRemoval(self, nums: List[int], k: int) -> int:
        nums.sort()
        n = len(nums)
        best = n
        right = 0
        for left in range(n):
            while right < n and nums[right] <= nums[left] * k:
                right += 1                         # [left, right) can all stay
            best = min(best, left + (n - right))
        return best
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Looking for a contiguous block without sorting: any elements may be removed, not just a contiguous run.

## Interview Explanation

The condition depends only on the max and min, so I sort, and then the kept elements form a contiguous block. I try each `nums[left]` as the minimum and move a right-only pointer to the farthest element that can stay, removing everything to the left and right, and take the minimum. Sorting dominates: `O(n log n)`.
