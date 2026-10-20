---
title: "LeetCode 658: Find K Closest Elements"
summary: "LeetCode 658 note: shrink two pointers from both ends to length k, or binary search the window start"
description: "LeetCode 658 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "two-pointers", "binary-search", "sliding-window"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Accepted (first try)

## Approach

The array is sorted, so the `k` elements closest to `x` always form **one contiguous block**.

## My Solution: two pointers shrinking from both ends

Start with the whole array and repeatedly drop whichever end is farther from `x` until `k` remain. On ties, drop the right end, since the smaller value counts as closer.

```python
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        left, right = 0, len(arr) - 1
        while right - left + 1 > k:
            if abs(arr[right] - x) >= abs(arr[left] - x):
                right -= 1
            else:
                left += 1
        return arr[left:right + 1]
```

My original code also special-cased `x <= arr[0]` and `x >= arr[-1]`, but the two pointers already handle both, so those checks can go.

## Faster: binary search the window start

The answer is `arr[lo:lo + k]`; only the start `lo` is needed. Compare which of `arr[mid]` and `arr[mid + k]` is farther from `x`:

- `x - arr[mid] > arr[mid + k] - x`: the left end is farther, so the start moves right: `lo = mid + 1`.
- Otherwise the start is `mid` or further left: `hi = mid`.

```python
class Solution:
    def findClosestElements(self, arr: List[int], k: int, x: int) -> List[int]:
        lo, hi = 0, len(arr) - k
        while lo < hi:
            mid = (lo + hi) // 2
            if x - arr[mid] > arr[mid + k] - x:
                lo = mid + 1
            else:
                hi = mid
        return arr[lo:lo + k]
```

This deliberately avoids `abs`: signed differences still give the right direction when `x` lies outside both values.

## Complexity

| Approach | Time |
|---|---|
| Two pointers | `O(n - k)` |
| Binary search | `O(log(n - k) + k)` |

Both use `O(1)` space excluding the output.

## Mistakes to Avoid

- Dropping the left end on ties: smaller values win ties, so drop the right end.
- Using `abs` in the binary search version: when `arr[mid]` equals `arr[mid + k]`, `abs` can move the window the wrong way.
- Sorting by distance, picking `k`, and sorting back: `O(n log n)` and ignores that the input is sorted.

## Interview Explanation

The array is sorted, so the answer is a contiguous block of length `k`. The direct approach shrinks two pointers from both ends, dropping the end farther from `x` and the right end on ties, in `O(n - k)`. Faster is to binary search the start: compare `x - arr[mid]` with `arr[mid + k] - x` and move right when the left end is farther, for `O(log(n - k) + k)`.
