---
title: "LeetCode 775: Global and Local Inversions"
summary: "LeetCode 775 note: turn a counting problem into an existence check and solve it in O(n)"
description: "LeetCode 775 record from the 2026-10-20 merge sort practice ladder"
date: 2026-10-20
tags: ["medium", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-20
Source: extension of the merge sort practice ladder, practicing when not to use merge sort

## Approach

`nums` is a permutation of `0 ~ n-1`. A global inversion is any inversion; a local inversion is an inversion between neighbors. Return `true` if the two counts are equal.

Baseline: merge sort for the global count plus one scan for the local count, `O(n log n)`.

Key observation: **every local inversion is also a global inversion**, so local is a subset of global:

```text
global = local ∪ { inversions at distance >= 2 }
```

The counts are equal ⟺ **no** pair exists with `j >= i + 2` and `nums[i] > nums[j]`.

The problem changes from "count two things and compare" to "check whether one kind of pair exists". For a fixed `j`, you only need to know whether the maximum of `nums[0..j-2]` exceeds `nums[j]`, and that maximum can be maintained while scanning.

## My First Attempt

```python
local_inversions = 0
for i in range(n - 1):
    if nums[i] > nums[i + 1]:
        local_inversions += 1

mx = -1
for i in range(2, n):
    mx = max(mx, nums[i - 2])
    if nums[i - 2] > nums[i]:      # should compare mx
        return False
return True
```

## Review

- **`mx` is computed but never used**: comparing only `nums[i - 2]` misses elements at distance 3 or more. Counterexample `[2, 0, 3, 1]`: (2, 1) is an inversion at distance 3, so the answer is `false`, but this version returns `true`.
- **`local_inversions` is unnecessary**: the whole point of this solution is not to count.
- **The `n == 1` special case is unnecessary**: `range(2, n)` is empty when `n <= 2`.

**After writing, scan once: is every computed variable actually used?**

## Solution

```python
class Solution:
    def isIdealPermutation(self, nums: list[int]) -> bool:
        mx = -1                          # max(nums[0..i-2])
        for i in range(2, len(nums)):
            mx = max(mx, nums[i - 2])
            if mx > nums[i]:
                return False             # found an inversion at distance >= 2
        return True
```

### Alternative: every element is at most one step from home

A common version on the discussion board:

```python
class Solution:
    def isIdealPermutation(self, nums: list[int]) -> bool:
        return all(abs(x - i) <= 1 for i, x in enumerate(nums))
```

A valid permutation is `[0, 1, ..., n-1]` with some **adjacent, non-overlapping** swaps applied. If any element is two or more steps from its home position, it must have jumped over some element, which creates an inversion at distance >= 2.

This solution **relies on the input being a permutation** and breaks for arbitrary integers. The prefix maximum solution does not.

## Complexity

Both solutions run in `O(n)` time and `O(1)` space.

## Mistakes to Avoid

- Reaching for merge sort as soon as inversions appear, without checking whether the question asks "how many" or "are they equal".
- Maintaining a variable and then comparing against something else.

## Interview Explanation

An adjacent inversion is always an inversion, so local is a subset of global. The counts are equal exactly when no inversion at distance at least 2 exists. I scan left to right, keep the maximum of `nums[0..i-2]`, and return `false` as soon as it exceeds `nums[i]`. No counting is needed: `O(n)` time, `O(1)` space, and it does not depend on the input being a permutation.
