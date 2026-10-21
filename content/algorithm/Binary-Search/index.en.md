---
title: "Binary Search"
summary: "Lower / upper bound, binary search on the answer, k-th smallest, integer roots, and why the two interval styles must not be mixed"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["binary-search", "prefix-sum", "two-pointers"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

At its core, binary search **finds the boundary where a monotonic condition flips from False to True.**

```text
index:       0     1     2     3     4     5
condition: False False False True  True  True
                               ↑ the position we want
```

Two common uses:

1. **Finding a position in a sorted array**, such as the first index with value `>= x`.
2. **Binary search on the answer**: the answer range is large, but you can write a monotonic `check(x)` that says whether `x` can be the answer.

## Template 1: Lower Bound / Upper Bound (half-open)

I always use the **half-open** interval `[lo, hi)`. When the loop ends, `lo == hi` is the answer:

```python
def lower_bound(arr, x):              # first index with value >= x
    lo, hi = 0, len(arr)              # hi is len(arr), not len(arr) - 1
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] < x:
            lo = mid + 1
        else:
            hi = mid
    return lo

def upper_bound(arr, x):              # first index with value > x
    lo, hi = 0, len(arr)
    while lo < hi:
        mid = (lo + hi) // 2
        if arr[mid] <= x:
            lo = mid + 1
        else:
            hi = mid
    return lo
```

Python's `bisect.bisect_left` and `bisect.bisect_right` are exactly these two functions.

### Key Parameters:

- **`hi = len(arr)`**: if every element is smaller than `x`, the answer is `len(arr)`, so `hi` must be able to equal it (LC 3508).
- **Parenthesize `mid = (lo + hi) // 2`**: `lo + hi // 2` computes `hi // 2` first (LC 3709).
- **Count inside `[a, b]`** = `upper_bound(b) - lower_bound(a)`.

## Template 2: Binary Search on the Answer

Find the smallest `x` for which `check(x)` holds:

```python
lo, hi = smallest possible answer, largest possible answer
while lo < hi:
    mid = (lo + hi) // 2
    if check(mid):
        hi = mid                      # mid works; the answer is mid or to its left
    else:
        lo = mid + 1                  # mid fails; the answer is to its right
return lo
```

### Key Parameters:

- **Make sure `check` is monotonic**: if `x` works, every value larger than `x` works too.
- **Make the upper bound large enough**: LC 3824 first used `max(nums)`, but the answer can exceed it.
- **For a maximum, flip it**: if `check(mid)` holds, set `lo = mid`, and then `mid` must be `(lo + hi + 1) // 2` or the loop never ends. Alternatively, find the first failing position and subtract 1.

## Template 3: K-th Smallest by Counting "≤ mid"

Instead of finding the k-th smallest value directly, binary search the answer: **the first `mid` for which "count of values `<= mid`" is `>= k` is the k-th smallest.**

```python
lo, hi = minimum value, maximum value
while lo < hi:
    mid = (lo + hi) // 2
    if count_at_most(mid) < k:
        lo = mid + 1
    else:
        hi = mid
return lo
```

In LC 719, `count_at_most` uses a sliding window to count pairs with distance `<= mid` in `O(n)`, for `O(n log W)` overall.

## Template 4: Integer K-th Root

`x ** (1 / k)` is floating-point math and can be off. For an exact `floor(n^(1/k))`, binary search on integers:

```python
def kth_root_floor(n, k):             # largest x with x ** k <= n
    lo, hi = 0, n + 1
    while lo < hi:
        mid = (lo + hi) // 2
        if mid ** k <= n:
            lo = mid + 1
        else:
            hi = mid
    return lo - 1
```

LC 3932 counts perfect k-th powers in `[l, r]`: `kth_root_floor(r) - kth_root_floor(l - 1)`.

## Template 5: Sort + Prefix Sums + bisect

Many "sum or count over a range" queries become: sort, build prefix sums, and use bisect for the boundary on each query:

```python
pairs = sorted(zip(keys, values))
sorted_keys = [k for k, _ in pairs]
prefix = [0]
for _, v in pairs:
    prefix.append(prefix[-1] + v)

def query(limit):                     # sum of values with key <= limit
    return prefix[bisect.bisect_right(sorted_keys, limit)]
```

LC 2838, 2300, and 3709 all follow this pattern.

## Template 6: Rotated arrays

Splitting at `mid`, at least one half is sorted; decide which, then whether the target lies in it:

```python
while l <= r:
    mid = (l + r) // 2
    if nums[mid] == target:
        return mid
    if nums[l] <= nums[mid]:             # left half sorted
        if nums[l] <= target < nums[mid]:
            r = mid - 1
        else:
            l = mid + 1
    else:                                # right half sorted
        if nums[mid] < target <= nums[r]:
            l = mid + 1
        else:
            r = mid - 1
```

- **Search** (LC 33): the code above; **with duplicates** (LC 81), `nums[l] == nums[mid]` hides the sorted half, so `l += 1`.
- **Minimum** (LC 153): compare `nums[mid]` with `nums[r]`: larger means `l = mid + 1`, otherwise `r = mid`; **with duplicates** (LC 154), equality means `r -= 1`.
- **Peak** (LC 162): `nums[mid] < nums[mid + 1]` guarantees a peak to the right.
- **The single element among pairs** (LC 540): before it, every pair starts at an even index.

## Never Mix the Two Interval Styles

| | Half-open `[lo, hi)` | Closed `[lo, hi]` |
|---|---|---|
| Initial `hi` | `len(arr)` | `len(arr) - 1` |
| Loop condition | `while lo < hi` | `while lo <= hi` |
| Shrink left | `hi = mid` | `hi = mid - 1` |
| Shrink right | `lo = mid + 1` | `lo = mid + 1` |

**Pick one and stick to it.** LC 1292 passed with the closed style; switching to `while lo < hi` without also changing `hi = mid - 1` gave a WA.

## Complexity

- Binary search over an array of length `n`: `O(log n)`.
- Binary search on the answer: `O(log(answer range) × cost of check)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **`mid = left + right // 2`**: operator precedence, missing parentheses (LC 3709).
- **`hi = len(arr) - 1` with a half-open loop**: the "insert at the end" position can never be returned (LC 3508).
- **Mixing the two interval styles**: changing the loop condition but not the updates (LC 1292).
- **An upper bound too small for binary search on the answer** (LC 3824).
- **Taking a floating-point root and comparing for equality**: in Python, `64 ** (1/3)` is `3.9999999999999996`, not `4.0` (LC 3932).
- **Using float division for a threshold**: `success / spell` can lose precision with large numbers; use integer `ceil` (LC 2300).
- **Letting a two-pointer index move backwards**: `j_low = min(i + 1, j_low)` pulls the pointer back every time, turning it into `O(n^2)` (LC 1712).

- **`mid = (l + r) / 2`**: Python 3's `/` gives a float, unusable as an index (LC 704, 74, 35).
- **Returning on an exact match while minimizing**: a smaller value may also work (LC 875).
- **Comparing only `nums[mid]` with the target in a rotated array**: decide the sorted half first (LC 33, 81).
- **Moving one step at a time**: `l += 1` / `r -= 1` is a linear search, TLE (LC 981).
- **Testing existence with `start < end`**: a single occurrence has start equal to end (LC 34).
- **`while l < r` with `l = mid`**: `mid` rounds down, `l` never moves, infinite loop (LC 441, 34).

## Related LeetCode

- `LC 2300` Successful Pairs of Spells and Potions
- `LC 2838` Maximum Coins Heroes Can Collect
- `LC 3709` Design Exam Scores Tracker
- `LC 3508` Implement Router
- `LC 3814` Maximum Capacity Within Budget
- `LC 1712` Ways to Split Array Into Three Subarrays
- `LC 3639` Minimum Time to Activate String
- `LC 3824` Minimum K to Reduce Array Within Limit
- `LC 1292` Maximum Side Length of a Square with Sum Less than or Equal to Threshold
- `LC 719` Find K-th Smallest Pair Distance
- `LC 3932` Count K-th Roots in a Range
- `LC 327` Count of Range Sum
- `LC 704` Binary Search
- `LC 35` Search Insert Position
- `LC 34` Find First and Last Position of Element in Sorted Array
- `LC 74` Search a 2D Matrix
- `LC 240` Search a 2D Matrix II
- `LC 33` Search in Rotated Sorted Array
- `LC 81` Search in Rotated Sorted Array II
- `LC 153` Find Minimum in Rotated Sorted Array
- `LC 154` Find Minimum in Rotated Sorted Array II
- `LC 162` Find Peak Element
- `LC 875` Koko Eating Bananas
- `LC 275` H-Index II
- `LC 1337` The K Weakest Rows in a Matrix
- `LC 268` Missing Number
- `LC 367` Valid Perfect Square
- `LC 69` Sqrt(x)
- `LC 888` Fair Candy Swap
- `LC 278` First Bad Version
- `LC 374` Guess Number Higher or Lower
- `LC 441` Arranging Coins
- `LC 287` Find the Duplicate Number
- `LC 981` Time Based Key-Value Store
- `LC 540` Single Element in a Sorted Array
- `LC 744` Find Smallest Letter Greater Than Target
