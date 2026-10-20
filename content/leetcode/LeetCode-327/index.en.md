---
title: "LeetCode 327: Count of Range Sum"
summary: "LeetCode 327 note: prefix sums plus merge sort counting with two pointers bounding a range, and a log of retyping it over a dozen times"
description: "LeetCode 327 record from 2026-08-01"
date: 2026-08-01
tags: ["hard", "merge-sort", "divide-and-conquer", "prefix-sum", "binary-indexed-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-01
- Submissions: AC (08-01) → AC ×5 (09-01) → AC ×4 (09-27) → WA ×2 → AC (10-18) → AC (10-19, half-open rewrite)

## Approach

Count the subarrays whose sum lies in `[lower, upper]`.

With prefix sums `P`, the subarray `[i, j)` sums to `P[j] - P[i]`, so the question becomes:

```text
how many pairs i < j satisfy lower <= P[j] - P[i] <= upper
```

That is a "count pairs with `i < j`" problem, so run merge sort counting on the prefix array: before merging, for each `P[i]` in the left half, the valid `P[j]` in the right half form a contiguous range, bounded by two pointers that only move right.

The full derivation is in [Merge Sort and Divide-and-Conquer Counting]({{< relref "/algorithm/Merge-Sort" >}}).

## My Practice Log

I retyped this one many times:

- **08-01**: first write-up, closed interval `[start, end]`, accepted on the first try.
- **09-01, 09-27**: retyped and resubmitted the same solution 9 more times.
- **10-18**: renamed the parameters to `(i, j)`, which clashed with the loop variable `i`, giving two WAs in a row:
    - The recursive call became `countAndMergeSort(0, mid)`, with the wrong left start.
    - The `for i in range(...)` loop was removed, so only one `i` was counted.
- **10-19**: rewrote it in the half-open `[low, high)` style from my merge sort practice ladder, accepted on the first try.

**Do not reuse a loop variable's name for a parameter.** That kind of bug raises no error and just gives wrong answers.

## Solution (half-open)

```python
class Solution:
    def countRangeSum(self, nums: List[int], lower: int, upper: int) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i + 1] = prefix[i] + nums[i]

        def mergeAndSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0
            mid = (low + high) // 2
            count = mergeAndSort(low, mid) + mergeAndSort(mid, high)

            j1 = j2 = mid
            for i in range(low, mid):
                while j1 < high and prefix[j1] - prefix[i] < lower:
                    j1 += 1                       # first position >= lower
                while j2 < high and prefix[j2] - prefix[i] <= upper:
                    j2 += 1                       # first position > upper
                count += j2 - j1

            prefix[low:high] = sorted(prefix[low:high])
            return count

        return mergeAndSort(0, n + 1)
```

Note the recursion covers `[0, n + 1)`: the prefix array has `n + 1` elements.

## Alternative: BIT with coordinate compression

Scan prefix sums left to right; for each `P[j]`, query how many earlier `P[i]` fall in `[P[j] - upper, P[j] - lower]`, then add `P[j]` to the BIT. Prefix sums are large, so compress them first and convert the query bounds to ranks with `bisect`.

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- A parameter name that clashes with a loop variable.
- Starting the left recursive half at 0.
- The prefix array has `n + 1` elements, so the half-open recursion covers `[0, n + 1)`.
- Flipping the bounds: `P[i]` must lie in `[P[j] - upper, P[j] - lower]`, with `upper` on the left.

## Interview Explanation

I build prefix sums, so each subarray sum is a difference of two prefix sums, and the task becomes counting pairs `i < j` with `lower <= P[j] - P[i] <= upper`. I merge sort the prefix array: before merging, both halves are sorted, and for each `P[i]` on the left the valid `P[j]` on the right form a contiguous range, found with two right-moving pointers. Each level is `O(n)`, `O(n log n)` total. A BIT with coordinate compression also works.
