---
title: "LeetCode 3796: Find Maximum Value in a Constrained Sequence"
summary: "LeetCode 3796 note: each position's bound is the min of its own limit, the left bound + difference and the right bound + difference; one pass each way"
description: "LeetCode 3796 record from 2026-01-03"
date: 2026-01-03
tags: ["medium", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-03
- Submissions: Wrong Answer ×2 → Accepted (2026-01-04)

## Approach

Let `ub[i]` be the largest possible `a[i]`. Three things limit it:

- Its own `restrictions` (and `a[0]` is fixed at 0).
- The left: `a[i] <= a[i - 1] + diff[i - 1]`, so `ub[i] <= ub[i - 1] + diff[i - 1]`.
- The right: likewise `ub[i] <= ub[i + 1] + diff[i]`.

Propagate once left to right and once right to left ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 3). Afterwards neighboring bounds differ by at most `diff`, so `ub` itself is a valid sequence reaching every bound at once, and the answer is `max(ub)`.

## My Attempts

I first tried binary-searching, between each pair of restricted points, for where the two slopes cross.

1. **Attempt 1** did not propagate the limits: for the last segment it used "last restriction + remaining differences" without checking reachability from `a[0] = 0`. For `n = 2`, `restrictions = [[1, 3]]`, `diff = [0]`, `a[1]` can only be 0; it returned 3.
2. **Attempt 2** propagated the restriction values both ways, but after finding the first position where the left slope exceeds the right, it returned `r - 1`, **checking only the cell before the crossing**. For `n = 4`, `restrictions = [[3, 1]]`, `diff = [3, 3, 3]` the best is `[0, 3, 4, 1]` with the maximum 4 at the crossing cell; it returned 3.
3. Computing a bound for every position with one pass each way passed, with no binary search needed.

## Solution

```python
class Solution:
    def findMaxVal(self, n: int, restrictions: List[List[int]], diff: List[int]) -> int:
        ub = [inf] * n
        ub[0] = 0
        for idx, cap in restrictions:
            ub[idx] = min(ub[idx], cap)
        for i in range(n - 1):                     # from the left
            ub[i + 1] = min(ub[i + 1], ub[i] + diff[i])
        for i in range(n - 2, -1, -1):             # from the right
            ub[i] = min(ub[i], ub[i + 1] + diff[i])
        return max(ub)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Limits must propagate in both directions, not just between neighboring restricted points.
- The peak of two slopes can be the crossing cell itself; do not check only the cell before it.

## Interview Explanation

Each position's maximum is limited by its own restriction and by its neighbors. I fill the restrictions into a bound array and propagate once each way; afterwards every neighboring difference is legal, so all bounds are reachable together and the answer is the largest bound. Time `O(n)`.
