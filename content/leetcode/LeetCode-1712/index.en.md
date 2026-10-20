---
title: "LeetCode 1712: Ways to Split Array Into Three Subarrays"
summary: "LeetCode 1712 note: fix the first cut and find the valid range of the second cut with two bisects or two monotonic pointers"
description: "LeetCode 1712 record from 2026-01-22"
date: 2026-01-22
tags: ["medium", "binary-search", "prefix-sum", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-22
- Submissions: TLE → WA (01-22) → TLE → AC → TLE → AC → AC (bisect version, 01-24)

## Approach

Two cuts split the array into `left`, `mid`, and `right` with `sum(left) <= sum(mid) <= sum(right)`. All numbers are non-negative.

With prefix sums `P[j] = nums[0] + ... + nums[j]`, fix the first cut at `i` (`left = nums[0..i]`) and the second at `j` (`mid = nums[i+1..j]`):

```text
sum(left) <= sum(mid)   ⟺  P[i] <= P[j] - P[i]         ⟺  P[j] >= 2 * P[i]
sum(mid)  <= sum(right) ⟺  P[j] - P[i] <= P[-1] - P[j]  ⟺  P[j] <= (P[-1] + P[i]) / 2
```

The numbers are non-negative, so `P` is non-decreasing and **the valid `j` form one contiguous range**; bisect finds both ends. Also `j` must lie in `[i + 1, n - 2]` because no part may be empty.

## My Attempts

### Day one: the wrong sliding-window idea

I first tried to push all three parts with one window. The logic did not match "fix the first cut and count the valid second cuts", which gave TLE and WA.

### Day two: two pointers, but one moved backwards

Next I fixed `i` and used `j_low` and `j_high` for the range of the second cut:

```python
j_low = min(i + 1, j_low)          # should be max
```

As `i` moves right, both boundaries only move right, so the pointers should only advance. `min` pulls `j_low` back to `i + 1`, rescanning every round in `O(n^2)` and timing out. Switching to `max` passed.

One TLE in between was an accidental resubmission of the old `min` version.

## Solution

### Solution 1: two bisects

```python
import bisect
from itertools import accumulate

class Solution:
    def waysToSplit(self, nums: List[int]) -> int:
        P = list(accumulate(nums))
        n, total = len(nums), P[-1]
        ans = 0
        for i in range(n - 2):
            lo = bisect.bisect_left(P, 2 * P[i], i + 1, n - 1)
            hi = bisect.bisect_right(P, (total + P[i]) // 2, i + 1, n - 1)
            if hi > lo:
                ans += hi - lo
        return ans % (10 ** 9 + 7)
```

The `lo` and `hi` arguments of `bisect` limit the search to `[i + 1, n - 1)`, exactly the valid second-cut positions.

Writing `P[j] <= (total + P[i]) / 2` as integer `// 2` is also correct: `P[j]` is an integer, so being at most a number is the same as being at most its floor.

### Solution 2: two forward-only pointers

```python
class Solution:
    def waysToSplit(self, nums: List[int]) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        ans = 0
        j_low = j_high = 1
        for i in range(n - 2):
            j_low = max(j_low, i + 1)
            while j_low < n - 1 and prefix[j_low + 1] < 2 * prefix[i + 1]:
                j_low += 1
            j_high = max(j_high, j_low)
            while j_high < n - 1 and 2 * prefix[j_high + 1] <= prefix[n] + prefix[i + 1]:
                j_high += 1
            ans += j_high - j_low
        return ans % (10 ** 9 + 7)
```

## Complexity

| Approach | Time |
|---|---|
| Two bisects | `O(n log n)` |
| Two monotonic pointers | `O(n)` |

Both use `O(n)` space.

## Mistakes to Avoid

- Writing a monotonic pointer update with `min`, letting it move backwards.
- Not limiting the second cut to `[i + 1, n - 2]`: no part may be empty.
- Not skipping empty ranges (`hi <= lo`): a negative count must never be added to the answer.

## Interview Explanation

I build prefix sums, fix the first cut `i`, and rewrite the two inequalities as bounds on the second cut's prefix sum: `P[j] >= 2 P[i]` and `P[j] <= (total + P[i]) / 2`. Since the numbers are non-negative, the prefix sums are non-decreasing, so the valid second cuts form a contiguous range; two bisects find it, with `j` restricted to `[i+1, n-2]`. Two forward-only pointers bring it down to `O(n)`.
