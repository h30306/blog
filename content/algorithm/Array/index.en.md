---
title: "Array Scanning"
summary: "Adjacent comparisons and walking monotonic runs (uphill, downhill, hills and valleys), keeping prefix / suffix maximums and sums in one pass, enumerating pairs in small ranges, and breaking ties with tuple keys"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["array", "simulation", "enumeration"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Many array problems need only one scan; the point is "what to remember while scanning":

| To decide | Remember while scanning | Examples |
|---|---|---|
| A shape (increasing, decreasing, peaks) | Which run you are in, the last non-flat direction | Trionic arrays, hills and valleys |
| A contiguous run | The current run's length | Longest Fibonacci subarray, increasing suffix |
| Comparison with everything on one side | Prefix maximum, suffix sum | Greater than all on the left, above the average on the right |
| At most one change | Changes used, and which element to change | Fix one number to make the array non-decreasing |

When you need the sum of an arbitrary range, see [Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}).

## Template 1: Walking monotonic runs

Advance one index run by run and check each run's length:

```python
i, n = 0, len(nums)
while i + 1 < n and nums[i] < nums[i + 1]:   # uphill
    i += 1
p = i
while i + 1 < n and nums[i] > nums[i + 1]:   # downhill
    i += 1
q = i
while i + 1 < n and nums[i] < nums[i + 1]:   # uphill again
    i += 1
ok = 0 < p < q < n - 1 and i == n - 1
```

- **Trionic arrays** (LC 3637): the code above; all three runs must be non-empty and reach the end exactly.
- **Sums of the two sides of a bitonic array** (LC 3909): walk to the peak and sum each side (the peak counts on both sides, or on neither when only comparing).
- **Shortest prefix to remove** (LC 3818): walk left from the right end; everything before the longest strictly increasing suffix goes.
- **Longest Fibonacci subarray** (LC 3708): extend while `nums[i] == nums[i-1] + nums[i-2]`, otherwise reset the length to 2.
- **Hills and valleys** (LC 2210): treat equal neighbors as one point and remember only the last non-flat direction; up then down is a hill, down then up a valley.
- **Adjacent differences in a circular array** (LC 3423): the last and first elements are adjacent too.

- **Mountains and monotonic arrays** (LC 941, 896): a mountain walks a strict ascent, peaks away from both ends, then walks a strict descent to the very end; monotonic means a rise and a fall never both occur, with equal neighbors allowed.
- **Run lengths** (LC 674, 485): update the maximum every step so the final run is not missed.

## Template 2: At most one change

```python
changed = False
for i in range(1, len(nums)):
    if nums[i] < nums[i - 1]:
        if changed:
            return False
        changed = True
        if i >= 2 and nums[i] < nums[i - 2]:
            nums[i] = nums[i - 1]        # only raising nums[i] works
        # otherwise lowering nums[i - 1] is enough and affects nothing later
return True
```

Counting drops is not enough: `[3, 4, 1, 2]` has a single drop, but changing neither 4 nor 1 works (LC 665).

## Template 3: Comparing with everything on one side

"Greater than everything on the left" is "greater than the prefix maximum", and "greater than the average on the right" uses the suffix sum:

```python
best = float("-inf")
for i, x in enumerate(nums):             # left to right: prefix maximum
    if x > best:
        ...                              # x is greater than everything to its left
    best = max(best, x)

suffix = 0
for i in range(n - 1, -1, -1):           # right to left: suffix sum
    cnt = n - 1 - i                      # how many are to the right
    if cnt and nums[i] * cnt > suffix:   # compare averages by multiplying, no floats
        ...
    suffix += nums[i]
```

- **Greater than all on the left or all on the right** (LC 3912): scan both directions, take the union, and output in original order.
- **Above the average on the right** (LC 3833): the second part above; the average excludes the element itself.
- **Opposite-parity counts to the right** (LC 3917): scan right to left counting odds and evens seen.
- **Most candies after the extra** (LC 1431): compare with the global maximum; a tie counts.

## Template 4: Small-range enumeration, or tuples for ties

- **Equal pairs with `i * j` divisible by `k`** (LC 2176): with `n <= 100`, enumerate all pairs; the condition is on the **indices**' product, not the values.
- **Best reachable tower** (LC 3809): "highest quality, ties to the smallest coordinate" is one key: take the minimum of `(-q, x, y)`.

## Template 5: Direct simulation

Many problems just follow the rules; the work is in the index arithmetic:

- **Circular moves** (LC 3379): `k` steps right is `(i + k) % n`; left is `(i - k) % n`, since Python's `%` returns a non-negative result for negative operands.
- **Rotating only part of the array** (LC 3819): pull out the elements that move, rotate them, and put them back in their original positions in order; there may be none, so check before taking a modulo.
- **Walking out in eight directions** (LC 1222): from the king, step along each direction; the first queen met is the one that can attack.
- **Smallest rectangle covering every 1** (LC 3195): track the topmost, bottommost, leftmost and rightmost 1.
- **Merge intervals, then multiply by the per-unit cost** (LC 3951): each time unit needs the same number of bulbs, so only the total covered time matters.
- **Others**: `ans[i] = nums[nums[i]]` (LC 1920), alternating sums (LC 3701), letter weights mod 26 mapped backward (LC 3838).

## Key Parameters

- When walking runs, guard each condition with `i + 1 < n` before comparing `nums[i]` and `nums[i + 1]`.
- Compare averages by multiplying: `a > s / c` is `a * c > s` (with `c > 0`).

## Complexity

One or two scans: time `O(n)`, space `O(1)` or `O(n)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Mixing up `>` and `>=`**: tying the maximum also counts as the most (LC 1431).
- **Conditions on values instead of indices**: the problem wants `i * j` divisible by `k`; I used the values' product (LC 2176).
- **Only counting drops**: one drop can still be unfixable; I also indexed `i + 2` out of range (LC 665).
- **`return False` inside the `for` loop**: it gave up after the first `p`; another version never checked the final uphill run (LC 3637).
- **Averaging with integer division and including the element itself** (LC 3833).
- **Taking a modulo without checking for zero**: with no non-negative elements, `k % 0` raised an error (LC 3819).
- **Updating the maximum only when a run breaks**: the final run is missed (LC 674).
- **Sorting before looking for increasing runs**: the order is destroyed (LC 674).
- **Checking only one side of a mountain**: both an ascent and a descent must exist (LC 941); **checking one direction or using strict inequalities for monotonic** (LC 896).
- **`i - 1 // 2`**: `//` binds tighter than `-` (LC 1646).
- **Not ordering the endpoints on a ring**: with `start > destination` the slice is empty (LC 1184).
- **Swapped branches**: when the gap exceeds the duration, add the duration (LC 495).

## Related LeetCode

- `LC 1431` Kids With the Greatest Number of Candies
- `LC 2176` Count Equal and Divisible Pairs in an Array
- `LC 3423` Maximum Difference Between Adjacent Elements in a Circular Array
- `LC 665` Non-decreasing Array
- `LC 2210` Count Hills and Valleys in an Array
- `LC 3637` Trionic Array I
- `LC 3708` Longest Fibonacci Subarray
- `LC 3809` Best Reachable Tower
- `LC 3818` Minimum Prefix Removal to Make Array Strictly Increasing
- `LC 3909` Compare Sums of Bitonic Parts
- `LC 3912` Valid Elements in an Array
- `LC 3917` Count Indices With Opposite Parity
- `LC 3833` Count Dominant Indices
- `LC 3195` Find the Minimum Area to Cover All Ones I
- `LC 1222` Queens That Can Attack the King
- `LC 1920` Build Array from Permutation
- `LC 3701` Compute Alternating Sum
- `LC 3819` Rotate Non Negative Elements
- `LC 3379` Transformed Array
- `LC 3838` Weighted Word Mapping
- `LC 3951` Minimum Energy to Maintain Brightness
- `LC 674` Longest Continuous Increasing Subsequence
- `LC 485` Max Consecutive Ones
- `LC 941` Valid Mountain Array
- `LC 896` Monotonic Array
- `LC 3131` Find the Integer Added to Array I
- `LC 1646` Get Maximum in Generated Array
- `LC 495` Teemo Attacking
- `LC 1184` Distance Between Bus Stops
