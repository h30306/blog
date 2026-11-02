---
title: "LeetCode 4099: Minimum Operations to Sort With Locked Indices"
summary: "LeetCode 4099 note: the swaps needed equal the inversion count; every locked position some element must cross has to be unlocked, so count those, compare with k, and add the inversions counted with merge sort"
description: "LeetCode 4099 record from 2026-11-02"
date: 2026-11-02
tags: ["medium", "array", "merge-sort", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-02
- Submissions: Accepted ×2

## Approach

Compute two parts separately:

**1. Swaps**: with only adjacent swaps, the minimum number of swaps to sort is the **inversion count**, achievable as long as the needed positions are unlocked. Count inversions with merge sort ([Merge Sort]({{< relref "/algorithm/Merge-Sort" >}})) in `O(n log n)`.

**2. Positions that must be unlocked**: while position `i` is locked, no element can cross it. If `nums[i] > i + 1`, that element must move right to `nums[i] - 1`, so every position from `i` to `nums[i] - 1` must be unlocked. Scan once, keep `reach`, the farthest position that must be unlocked so far, and count every locked position within `reach`.

Elements moving left need no separate handling: if the value at `i` is less than `i + 1`, some value among the first `i + 1` positions is greater than `i`, and it must cross `i` to the right, which is already counted.

If the required unlocks exceed `k`, return -1; otherwise the answer is unlocks plus inversions.

## My Attempts

Both submissions passed on the first try. The first used an inclusive-right merge sort on a copy of the array; the second used half-open ranges and sorted `nums` in place, the same template as LC 493.

## Solution

```python
class Solution:
    def minOperations(self, nums: List[int], locked: List[int], k: int) -> int:
        unlocks = 0
        reach = -1
        for i, num in enumerate(nums):
            if num > i + 1:
                reach = max(reach, num - 1)
            if locked[i] and i <= reach:
                unlocks += 1
        if unlocks > k:
            return -1

        temp = [0] * len(nums)

        def sort_count(lo, hi):
            if hi - lo <= 1:
                return 0
            mid = (lo + hi) // 2
            count = sort_count(lo, mid) + sort_count(mid, hi)
            i, j, t = lo, mid, lo
            while i < mid or j < hi:
                if j >= hi or (i < mid and nums[i] <= nums[j]):
                    temp[t] = nums[i]
                    i += 1
                else:
                    temp[t] = nums[j]
                    count += mid - i
                    j += 1
                t += 1
            nums[lo:hi] = temp[lo:hi]
            return count

        return unlocks + sort_count(0, len(nums))
```

## Complexity

Time `O(n log n)`, space `O(n)`. With `n` only up to 2000 an `O(n^2)` inversion count would also pass, but the problem asks for `O(n log n)`.

## Mistakes to Avoid

- Count the unlocks first, because the merge sort sorts `nums` in place.
- When the element at `i` must move right, position `i` itself must be unlocked too (the range includes `i`).
- Swaps and unlocks both count as operations; add them.

## Interview Explanation

The minimum number of adjacent swaps is the inversion count, which I get with merge sort in `O(n log n)`. Separately, every locked position that some element must cross has to be unlocked: scanning once, an element with value above `i + 1` must move right to `num - 1`, so I track the farthest such target and count locked positions within it. An element moving left always implies another element crossing to the right, so it needs no extra handling. If the unlocks exceed `k` the answer is -1, otherwise unlocks plus inversions.
