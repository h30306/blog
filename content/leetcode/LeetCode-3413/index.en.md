---
title: "LeetCode 3413: Maximum Coins From K Consecutive Bags"
summary: "LeetCode 3413 note: the best k bags always have one end on a segment boundary; compute \"left end at a segment start\" and \"right end at a segment end\" (the latter by mirroring and reusing the same function)"
description: "LeetCode 3413 record from 2026-01-16"
date: 2026-01-16
tags: ["medium", "sliding-window", "greedy", "sorting", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-16
- Submissions: Wrong Answer → Accepted

## Approach

Much like [LeetCode 2271]({{< relref "/leetcode/LeetCode-2271" >}}), except each segment has its own weight `c`.

Moving a length-`k` window right by one changes the total by "the bag coming in minus the bag going out". Between segment boundaries that change is constant, so the total changes linearly and **the maximum occurs at a boundary**: the window's left end at some segment's start, or its right end at some segment's end.

In 2271 every weight is 1, so left alignment alone was enough; here both are needed:

- Left-aligned: the same two pointers as 2271, summing fully covered segments and counting the next one partially.
- Right-aligned: mirror the coordinates (`[l, r]` becomes `[-r, -l]`), which turns right alignment into left alignment, and reuse the function.

## My Attempts

Attempt 1 missed one case: if a segment is longer than `k`, the carpet cannot cover even that segment and `right` stays at `left`. On the next round `left` advances while `right` still points at the previous segment, so **that segment gets added in full**. For `coins = [[2, 3, 5], [7, 8, 5]]`, `k = 1`, the answer is 5; this returned 15.

Setting `right` to `left + 1` when `right == left` passed.

## Solution

```python
class Solution:
    def maximumCoins(self, coins: List[List[int]], k: int) -> int:
        def best_left_aligned(segs: List[List[int]]) -> int:   # window starts at a segment start
            segs.sort()
            n = len(segs)
            right = full = best = 0
            for left in range(n):
                end = segs[left][0] + k - 1
                while right < n and segs[right][1] <= end:
                    l, r, c = segs[right]
                    full += (r - l + 1) * c
                    right += 1
                partial = 0
                if right < n and segs[right][0] <= end:
                    partial = (end - segs[right][0] + 1) * segs[right][2]
                best = max(best, full + partial)
                if right > left:
                    l, r, c = segs[left]
                    full -= (r - l + 1) * c
                else:
                    right = left + 1               # segment longer than k, not fully covered
            return best

        mirrored = [[-r, -l, c] for l, r, c in coins]   # right-aligned = left-aligned after mirroring
        return max(best_left_aligned([s[:] for s in coins]), best_left_aligned(mirrored))
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Checking only left alignment: with different weights the best window may be right-aligned.
- When a segment is longer than `k`, `right` stays at `left`, and the next round must skip that segment.

## Interview Explanation

Sliding the window by one changes the total by a constant between segment boundaries, so the maximum occurs when one end of the window sits on a boundary. Two pointers compute the best left-aligned window, summing full segments and the next one partially; for right alignment I mirror the coordinates and reuse the same function. Time `O(n log n)`.
