---
title: "LeetCode 493: Reverse Pairs"
summary: "LeetCode 493 note: when the counting condition differs from the sort order, scan first, then merge"
description: "LeetCode 493 record from the 2026-10-19 merge sort practice ladder"
date: 2026-10-19
tags: ["hard", "merge-sort", "divide-and-conquer", "two-pointers", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-19
Source: merge sort practice ladder, step 3

## Approach

Count pairs with `i < j` and `nums[i] > 2 * nums[j]`.

What is new here: **the counting condition differs from the sort order**, so you cannot count during the merge as in LCR 170. Take a left half `[3]` and a right half `[2]`:

- The merge check `3 <= 2` fails, so the 2 on the right is taken first.
- The count check `3 > 2 * 2 = 4` also fails, so this is not a reverse pair.

Taking the right element first during the merge does not mean the pair counts. So **scan once with two pointers to count, then merge**.

Two monotonic properties make the two pointers work:

1. The right half is ascending, so for a fixed `nums[i]`, the `j` with `nums[i] > 2 * nums[j]` form a **prefix** of the right half.
2. The left half is ascending, so as `i` moves right, `nums[i]` grows and that prefix only gets longer. `j` never moves back.

## My First Attempt

Correct on the first try:

```python
class Solution:
    def reversePairs(self, nums: list[int]) -> int:
        n = len(nums)
        tmp = [0] * n
        count = 0

        def mergeAndSort(low: int, high: int):
            nonlocal count
            if high - low <= 1:
                return

            mid = (low + high) // 2
            mergeAndSort(low, mid)
            mergeAndSort(mid, high)

            i, j, k = low, mid, low
            pair = 0
            while i < mid:
                while j < high and nums[i] > 2 * nums[j]:
                    pair += 1
                    j += 1
                count += pair
                i += 1

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    tmp[k] = nums[i]
                    i += 1
                else:
                    tmp[k] = nums[j]
                    j += 1
                k += 1

            nums[low: high] = tmp[low: high]

        mergeAndSort(0, n)
        return count
```

Possible cleanups: `pair` is always `j - mid`, and `k` is unused in the counting block.

## The Question I Had: why is `nonlocal` required?

Python's rule: **if a function assigns to a name anywhere (`=`, `+=`), that name is local throughout the function.**

`count += pair` means `count = count + pair`. Ints are immutable, so this assigns to the name, Python treats `count` as local, and reading it raises `UnboundLocalError`.

`tmp[k] = x` and `nums[low:high] = ...` change the contents of a list. They never assign to the names `tmp` or `nums`, so no `nonlocal` is needed.

Note that `lst += [1]` mutates the list in place, but it is still an assignment to the name syntactically, so it fails too. What matters is the syntax, not whether the object changes.

## Solution (returning the count)

```python
class Solution:
    def reversePairs(self, nums: list[int]) -> int:
        n = len(nums)
        tmp = [0] * n

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j = mid
            for i in range(low, mid):          # count first
                while j < high and nums[i] > 2 * nums[j]:
                    j += 1
                count += j - mid

            i, j, k = low, mid, low            # then merge
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    tmp[k] = nums[i]
                    i += 1
                else:
                    tmp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = tmp[low:high]
            return count

        return mergeAndSort(0, n)
```

## Complexity

Time `O(n log n)`: counting is `O(n)` per level because `j` only moves forward, the merge is `O(n)`, and there are `log n` levels. Space `O(n)`.

## Mistakes to Avoid

- Trying to count during the merge: the conditions differ, so the result is wrong.
- In Java/C++, `2 * nums[j]` overflows; cast to `long`. Python does not have this issue, but mention it in an interview.

## Interview Explanation

The counting condition `nums[i] > 2 * nums[j]` differs from the sort comparison, so on each level I count with two pointers first and merge afterwards. Both halves are sorted, so for each left `nums[i]`, the matching `j` form a prefix of the right half, and that prefix only grows as `i` moves right. `j` never moves back, so counting is `O(n)`. Total time `O(n log n)`, space `O(n)`. In Java I would watch for overflow in `2 * nums[j]`.
