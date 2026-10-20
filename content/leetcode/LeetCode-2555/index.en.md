---
title: "LeetCode 2555: Maximize Win From Two Segments"
summary: "LeetCode 2555 note: a sliding window gives how many prizes a segment ending at each prize collects, and a running \"best single segment among the first i prizes\" supplies the second segment to its left"
description: "LeetCode 2555 record from 2026-01-13"
date: 2026-01-13
tags: ["medium", "sliding-window", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-13
- Submissions: Accepted (first try)

## Approach

Overlapping segments are never better than non-overlapping ones, so assume the two segments are **one left, one right, disjoint**.

1. Sliding window: the right end is prize `right` and `left` is the first prize with position `>= prizePositions[right] - k`, giving `right - left + 1` prizes.
2. The other segment must lie entirely left of `left`, using only the first `left` prizes. Keep `best_before[i]` = the most one segment can collect among the first `i` prizes.
3. The answer is `max(right - left + 1 + best_before[left])`.

`best_before` is filled in during the same slide: `best_before[right + 1] = max(best_before[right], this segment)`.

## My Solution

```python
class Solution:
    def maximizeWin(self, prizePositions: List[int], k: int) -> int:
        n = len(prizePositions)
        best_before = [0] * (n + 1)                # best single segment among the first i prizes
        left = ans = 0
        for right, p in enumerate(prizePositions):
            while p - prizePositions[left] > k:
                left += 1
            cur = right - left + 1
            ans = max(ans, cur + best_before[left])     # second segment left of `left`
            best_before[right + 1] = max(best_before[right], cur)
        return ans
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Adding the two individually best segments: they may collect the same prizes twice.
- `best_before[left]` covers "the first `left` prizes", excluding `left` itself, so it never overlaps the current segment.

## Interview Explanation

The two segments can be taken as disjoint, one left of the other. A sliding window gives how many prizes a segment ending at each prize collects, and an array records the best single segment among the first `i` prizes. The current segment starts at `left`, so the other must lie left of it, and the answer is the max of this segment plus `best_before[left]`. Time `O(n)`.
