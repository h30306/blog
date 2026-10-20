---
title: "LeetCode 912: Sort an Array"
summary: "LeetCode 912 note: hand-written merge sort and the two bugs I hit"
description: "LeetCode 912 record from the 2026-10-18 merge sort practice ladder"
date: 2026-10-18
tags: ["medium", "sorting", "merge-sort", "divide-and-conquer"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-18
Source: merge sort practice ladder, step 0

## Approach

Sort the array in `O(n log n)` without the built-in sort. Quick sort is risky here: the tests include many duplicates and already sorted arrays, so a poor pivot degrades to `O(n^2)`. Merge sort is `O(n log n)` even in the worst case.

## My Attempts

### Attempt 1: the right half was never sorted

```python
mid = (lo + hi) // 2
sort(lo, mid)
sort(mid, lo)        # should be sort(mid, hi)
```

Inside `sort(mid, lo)`, `hi - lo` evaluates to `lo - mid`, which is always `<= 0`, so it returns immediately. `[5, 2, 3, 1]` comes out as `[2, 3, 1, 5]`.

At first I did not see why this fails when "the top level still merges `0:n`". The reason is that **merge only merges; it does not sort**:

- Each merge step compares only the two fronts, assuming each front is the smallest value left in its half.
- Merge never reorders elements within one half. If 3 is before 1 in the right half, 3 is still before 1 after the merge.

So both halves must be sorted by recursion first. Another angle: if one `O(n)` merge could sort any array, comparison sorting would be `O(n)`, but its lower bound is `O(n log n)`.

### Attempt 2: reading the wrong array during merge

```python
temp[k] = temp[i]    # should be nums[i]
temp[k] = temp[j]    # should be nums[j]
```

`temp` is the write buffer. Reading from it returns `0` or leftovers from an earlier merge. `[5, 2, 3, 1]` becomes `[0, 0, 0, 0]`.

Rule: during the merge, **`nums` is read only and `temp` is write only**. The same array name should never appear on both sides of an assignment.

## Solution

```python
class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        n = len(nums)
        temp = [0] * n

        def sort(low: int, high: int):
            if high - low <= 1:
                return

            mid = (low + high) // 2
            sort(low, mid)
            sort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    temp[k] = nums[i]
                    i += 1
                else:
                    temp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = temp[low:high]

        sort(0, n)
        return nums
```

## Complexity

- Time `O(n log n)`: `log n` levels, and the merges on each level add up to `O(n)`. The recurrence is `T(n) = 2T(n/2) + O(n)`. It always splits all the way down, so even the best case is `O(n log n)`.
- Space `O(n)`: the `temp` buffer plus `O(log n)` recursion depth.

## Mistakes to Avoid

- Mixing interval styles. With half-open ranges, use `[low, high)` everywhere and stop at `high - low <= 1`.
- Forgetting to copy the merged result back into `nums`.
- Allocating a new list on every merge. Still `O(n log n)`, but the constant is large and Python may time out.
- Using `<` instead of `<=`. It does not change this problem's output, but the sort becomes unstable and later counting problems break.

## Interview Explanation

I use merge sort because its worst case is `O(n log n)`, unlike quick sort, which duplicates or sorted input can push to `O(n^2)`. Recursion sorts both halves, then two pointers merge them into a buffer that is copied back. There are `log n` levels at `O(n)` each, so time is `O(n log n)` and space is the `O(n)` buffer. Using `<=` keeps the sort stable.
