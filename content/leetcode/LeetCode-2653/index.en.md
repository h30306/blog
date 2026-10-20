---
title: "LeetCode 2653: Sliding Subarray Beauty"
summary: "LeetCode 2653 note: values are only -50 to 50, so the fixed window keeps a count array, and each window accumulates upward from -50 to find the x-th smallest negative"
description: "LeetCode 2653 record from 2026-01-03"
date: 2026-01-03
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-03
- Submissions: Accepted (first try)

## Approach

Each length-`k` window needs its `x`-th smallest value if it is negative, otherwise 0.

A general "x-th smallest in a window" needs an ordered structure, but here **values are only `-50..50`**, so a count array of 101 slots is enough:

- As the window moves, the incoming value +1 and the outgoing value -1.
- For each window, accumulate negative counts upward from `-50`; the value where the total reaches `x` is the answer, or 0 if there are fewer than `x` negatives.

Each window scans at most 50 slots: `O(50n)` overall.

## My Solution

```python
class Solution:
    def getSubarrayBeauty(self, nums: List[int], k: int, x: int) -> List[int]:
        cnt = [0] * 101                            # value v stored at cnt[v + 50]
        res = []
        for right, v in enumerate(nums):
            cnt[v + 50] += 1
            if right >= k:
                cnt[nums[right - k] + 50] -= 1
            if right >= k - 1:
                seen = 0
                for idx in range(50):              # negatives only, -50..-1
                    seen += cnt[idx]
                    if seen >= x:
                        res.append(idx - 50)
                        break
                else:
                    res.append(0)
        return res
```

My original used a 50-slot array indexed directly by the negative `v` (`neg_array[v]`), relying on Python's negative indexing from the end so that `-50` maps to index 0 and index `i` means value `i - 50`. It works but is hard to read, so this version uses an explicit `+ 50` offset.

## Complexity

Time `O(n · 50)`, space `O(1)` (101 slots).

## Mistakes to Avoid

- Sorting every window: `O(n · k log k)`.
- Return 0 when there are fewer than `x` negatives.

## Interview Explanation

Values range only from -50 to 50, so a count array maintains the fixed window, +1 in and -1 out. For each window I accumulate negative counts from -50 upward; reaching `x` gives the `x`-th smallest negative, otherwise 0. Each window checks at most 50 slots: `O(50n)`.
