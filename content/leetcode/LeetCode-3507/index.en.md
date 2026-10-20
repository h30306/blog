---
title: "LeetCode 3507: Minimum Pair Removal to Sort Array I"
summary: "LeetCode 3507 note: n is tiny, so simulate; the right side of a slice assignment must be a list"
description: "LeetCode 3507 record from 2025-04-06"
date: 2025-04-06
tags: ["easy", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-06
- Submissions: Runtime Error → Accepted

## Approach

The rule is fixed: find the adjacent pair with the smallest sum (leftmost on ties) and merge it into one number. Repeat until the array is non-decreasing and return the number of operations.

`n <= 50`, one scan per operation is `O(n)`, and there are at most `n` operations, so direct `O(n^2)` simulation is enough.

The `n = 10^5` version (LC 3510) is the one that needs a heap plus a doubly linked list.

## My Attempt: assigning an int to a slice

```python
nums[min_index:min_index+2] = min_value      # TypeError
```

The right side of a slice assignment must be iterable. To replace two elements with one, write `[min_value]`.

## Solution

```python
class Solution:
    def minimumPairRemoval(self, nums: List[int]) -> int:
        ops = 0
        while any(nums[i] > nums[i + 1] for i in range(len(nums) - 1)):
            best = min(range(len(nums) - 1), key=lambda i: nums[i] + nums[i + 1])
            nums[best:best + 2] = [nums[best] + nums[best + 1]]
            ops += 1
        return ops
```

`min` returns the first of tied values, which matches "leftmost on ties".

## Complexity

Time `O(n^2)`, space `O(1)`.

## Mistakes to Avoid

- Putting a single value on the right side of a slice assignment.
- Picking the right pair on ties: compare with `<`, not `<=`.

## Interview Explanation

`n` is at most 50, so I simulate: while the array is not non-decreasing, find the adjacent pair with the smallest sum, leftmost on ties, replace it with the sum, and count the operation. Each operation is `O(n)` and there are at most `n`, so `O(n^2)` total. For large `n`, I would keep pair sums in a heap and use a doubly linked list for the merges.
