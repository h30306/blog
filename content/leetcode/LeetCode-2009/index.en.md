---
title: "LeetCode 2009: Minimum Number of Operations to Make Array Continuous"
summary: "LeetCode 2009 note: the result is n consecutive integers; after deduplicating and sorting, a sliding window finds the most distinct values within a span of n - 1, and the rest must change"
description: "LeetCode 2009 record from 2026-01-14"
date: 2026-01-14
tags: ["hard", "sliding-window", "hash-table", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-14
- Submissions: TLE → WA → RE → AC → WA → AC

## Approach

The final array is `[x, x + 1, ..., x + n - 1]`. Original values inside that range, without duplicates, can stay; everything else changes.

So find **the length-`n` value range `[x, x + n - 1]` containing the most distinct original values**.

1. Deduplicate and sort.
2. Sliding window: the right end is `vals[right]`; shrink the left until `vals[right] - vals[left] <= n - 1`. Everything in the window can stay.
3. The answer is `n - most values kept`.

The range can be assumed to start at an original value (pushing it right to the first original value is never worse), so starting from each `vals[left]` is enough.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, TLE | Slid over the whole value range `0..max`, testing `in nums` on a list, with values up to `10^9` |
| Attempt 2, WA | Slid over the sorted array but **did not deduplicate**, so repeated values counted as "kept". For `[1, 1]` one must become 2, so the answer is 1; it returned 0 |
| Attempt 3, RE | Added duplicate counting with a misspelled variable (`deplicate`) |
| Attempt 4, AC | Fixed the spelling; `duplicate` subtracted repeats inside the window |
| Attempt 5, WA | Simplifying, I dropped the deduplication again |
| Attempt 6, AC | Used `sorted(set(nums))` directly, the cleanest |

## Solution

```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        n = len(nums)
        vals = sorted(set(nums))                   # each value can be kept only once
        left = best = 0
        for right, x in enumerate(vals):
            while x - vals[left] > n - 1:
                left += 1
            best = max(best, right - left + 1)     # all of these can stay
        return n - best
```

The window width uses the **original** `n`, not the deduplicated length.

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Skipping deduplication: a repeated value can be kept only once.
- Using the deduplicated length for the width: the final array still has length `n`.

## Interview Explanation

The result is `n` consecutive integers, and original values inside that range without repeats can stay. So I deduplicate and sort, then slide a window for the most values with max minus min at most `n - 1`, and the answer is `n` minus that. The width uses the original `n`. Time `O(n log n)`.
