---
title: "LeetCode 3649: Number of Perfect Pairs"
summary: "LeetCode 3649 note: simplify the condition to \"larger absolute value <= 2 × smaller absolute value\", then count with two pointers over sorted absolute values"
description: "LeetCode 3649 record from 2025-08-16"
date: 2025-08-16
tags: ["medium", "two-pointers", "math", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-16
- Submissions: Accepted (first try)

## Approach

The key is simplifying the condition first. Let `x = min(|a|, |b|)` and `y = max(|a|, |b|)`:

- Whatever the signs, `{|a - b|, |a + b|}` is always `{y - x, y + x}`: with equal signs the subtraction cancels, with opposite signs the addition does.
- Condition 1: `min = y - x <= x`, i.e. **`y <= 2x`**.
- Condition 2: `max = y + x >= y`, **always true**.

So count pairs where the larger absolute value is `<=` twice the smaller one; signs and positions do not matter.

After sorting the absolute values, for each `right` find the leftmost `left` with `2 * arr[left] >= arr[right]`; everything in `[left, right)` pairs with `arr[right]`. As `right` grows, `left` only moves right, so these are same-direction pointers.

## My Solution

```python
class Solution:
    def perfectPairs(self, nums: List[int]) -> int:
        arr = sorted(abs(x) for x in nums)
        ans = left = 0
        for right, y in enumerate(arr):
            while 2 * arr[left] < y:
                left += 1
            ans += right - left            # arr[left..right-1] all pair with y
        return ans
```

`left` stops at `right` at the latest (`2y >= y`), so it never goes out of range.

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Enumerating pairs with the original condition in `O(n^2)`: too slow for `n` up to `10^5`.
- Missing one of the sign cases while simplifying.

## Interview Explanation

I simplify first: with absolute values `x <= y`, `|a - b|` and `|a + b|` are always `y - x` and `y + x`, so the second condition always holds and the first becomes `y <= 2x`. Then I sort the absolute values and, for each right end, move a left pointer that only goes right until `2 * arr[left] >= arr[right]`; everything between pairs up. Time `O(n log n)`.
