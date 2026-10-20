---
title: "LeetCode 220: Contains Duplicate III"
summary: "LeetCode 220 note: with bucket size valueDiff + 1, two numbers in one bucket always qualify, so only the two neighboring buckets need checking; the window keeps the latest indexDiff numbers, so each bucket holds at most one"
description: "LeetCode 220 record from 2026-01-10"
date: 2026-01-10
tags: ["hard", "sliding-window", "bucket-sort", "ordered-set", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-10
- Submissions: Wrong Answer ×2 → Output Limit Exceeded → Accepted

## Approach

Two conditions: index difference `<= indexDiff` and value difference `<= valueDiff`.

- **The index condition** is a sliding window: keep only the latest `indexDiff` numbers.
- **The value condition** uses buckets of size `size = valueDiff + 1`, with `x` in bucket `x // size`.
  - Two numbers in one bucket differ by `<= valueDiff`, so return `True` right away. Hence **each bucket holds at most one number**.
  - A qualifying number may also sit in a neighboring bucket, so check buckets `b - 1` and `b + 1`.
  - Anything farther differs by `> valueDiff`.

As the window moves, delete the bucket holding `nums[i - indexDiff - 1]`.

Python's `//` floors for negatives, `-1 // 3 == -1`, so negative numbers bucket correctly too.

## My Attempts

| Version | Problem |
|---|---|
| Attempts 1–2 | Deleted expired elements by **index** (`del buckets[i - indexDiff - 1]`), but bucket keys are value divided by size; neighbor checks used `< valueDiff`, missing equality. For `nums = [2, 5]`, `indexDiff = 2`, `valueDiff = 3`, `|2 - 5| = 3`, so the answer is `True`; both returned `False` |
| Attempt 3, OLE | Fixed, but left a `print(buckets)` in |
| AC | Removed the `print` |

## Solution

```python
class Solution:
    def containsNearbyAlmostDuplicate(self, nums: List[int], indexDiff: int, valueDiff: int) -> bool:
        size = valueDiff + 1
        buckets = {}                               # bucket id -> its only number
        for i, x in enumerate(nums):
            if i > indexDiff:
                del buckets[nums[i - indexDiff - 1] // size]   # leaves the window
            b = x // size
            if b in buckets:
                return True                        # same bucket: difference <= valueDiff
            if b - 1 in buckets and x - buckets[b - 1] <= valueDiff:
                return True
            if b + 1 in buckets and buckets[b + 1] - x <= valueDiff:
                return True
            buckets[b] = x
        return False
```

The expired number was put in a bucket and never overwritten (overwriting means a shared bucket, which would have returned already), so `del` always finds it.

## Complexity

Time `O(n)`, space `O(min(n, indexDiff))`. An ordered set (`SortedList`) over the window, querying the smallest value `>= x - valueDiff`, is the `O(n log k)` alternative.

## Mistakes to Avoid

- Deleting by index: bucket keys are `value // size`.
- Neighbor checks need `<=`.
- The bucket size is `valueDiff + 1`, not `valueDiff` (which divides by zero when `valueDiff = 0`).
- Submitting with a `print` left in.

## Interview Explanation

A sliding window keeps the latest `indexDiff` numbers for the index condition, and buckets of size `valueDiff + 1` handle the value condition. Two numbers in one bucket always qualify, so each bucket holds at most one; I also check the two neighboring buckets, since farther buckets cannot qualify. As the window moves I delete the expired number's bucket. Time `O(n)`.
