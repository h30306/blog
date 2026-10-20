---
title: "LeetCode 2200: Find All K-Distant Indices in an Array"
summary: "LeetCode 2200 note: extend each key k positions both ways, and keep a pointer to how far output has gone so overlapping ranges are not emitted twice"
description: "LeetCode 2200 record from 2026-01-04"
date: 2026-01-04
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-04
- Submissions: Accepted (brute force) → Wrong Answer → Accepted ×2

## Approach

Every position with `nums[j] == key` makes each index in `[j - k, j + k]` part of the answer. Output the union of these ranges in order.

Scanning key positions in order, **range starts only move right**, so a pointer `next_start` remembers how far output has gone: the next range starts at `max(next_start, j - k)` and nothing repeats.

## My Attempts

### Attempt 1: brute force

For every index, check all key positions and include it if any is within `k`. Correct, in `O(n · number of keys)` time.

### Attempt 2: overlapping ranges emitted twice

The next version emitted `[j - k, j + k]` for every key without handling overlaps. For `nums = [2, 3, 2, 1, 1, 2, 1, 2]`, `key = 2`, `k = 3`, every key's range overlaps the others, so indices were emitted several times: `[0, 1, 2, 3, 0, 1, 2, 3, 4, 5, ...]`.

Adding a pointer to the end of the previous range passed.

## Solution

```python
class Solution:
    def findKDistantIndices(self, nums: List[int], key: int, k: int) -> List[int]:
        n = len(nums)
        res = []
        next_start = 0                         # first index not yet emitted
        for j, x in enumerate(nums):
            if x == key:
                start = max(next_start, j - k)
                end = min(n - 1, j + k)
                res.extend(range(start, end + 1))
                next_start = end + 1
        return res
```

## Complexity

Time `O(n)`: each index is emitted at most once. Space `O(1)` excluding the output.

## Mistakes to Avoid

- Emitting overlapping ranges twice.
- Not clamping ranges to `[0, n - 1]`.

## Interview Explanation

Each position `j` holding `key` makes `[j - k, j + k]` part of the answer. I scan key positions in order with a pointer to how far output has gone, starting each range at `max(pointer, j - k)`, so overlaps are never emitted twice. Each index is output at most once, so time is `O(n)`.
