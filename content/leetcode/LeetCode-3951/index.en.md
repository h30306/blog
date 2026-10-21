---
title: "LeetCode 3951: Minimum Energy to Maintain Brightness"
summary: "LeetCode 3951 note: a bulb lights at most 3 positions, so each time unit needs ceil(brightness / 3) bulbs; merge the intervals for the total time and multiply"
description: "LeetCode 3951 record from 2026-06-11"
date: 2026-06-11
tags: ["medium", "array", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-11
- Submissions: Accepted (first try)

## Approach

Split it into two independent parts:

1. **Bulbs per time unit**: a bulb lights itself and its two neighbors, at most 3 positions, so at least `ceil(brightness / 3)` bulbs are needed. That many always suffices: place bulbs at 1, 4, 7, ..., each lighting 3 positions with no overlap, and move the last one to `n - 1` if it falls off the end, lighting `min(3k, n) >= brightness` positions (the problem guarantees `brightness <= n`).
2. **Which time units**: those covered by at least one interval. Intervals may overlap, so sort, merge, and sum the lengths ([Array]({{< relref "/algorithm/Array" >}}) Template 5).

The answer is their product.

## My Solution

```python
class Solution:
    def minEnergy(self, n: int, brightness: int, intervals: List[List[int]]) -> int:
        bulbs = (brightness + 2) // 3                  # ceil(brightness / 3)
        total = 0
        cur_s, cur_e = None, None
        for s, e in sorted(intervals):
            if cur_e is not None and s <= cur_e:       # 重疊（包含共用端點）就合併
                cur_e = max(cur_e, e)
            else:
                if cur_e is not None:
                    total += cur_e - cur_s + 1
                cur_s, cur_e = s, e
        total += cur_e - cur_s + 1
        return total * bulbs
```

## Complexity

Time `O(m log m)` for `m` intervals, space `O(m)` (sorting).

## Mistakes to Avoid

- Intervals are inclusive integer times of length `e - s + 1`; a shared endpoint counts as overlapping when merging.
- Write `ceil(b / 3)` in integers as `(b + 2) // 3`.

## Interview Explanation

Each bulb lights at most 3 positions, so each time unit needs `ceil(brightness / 3)` bulbs, which can always be arranged. The time needing light is the union of the intervals, which I sort and merge for its total length, then multiply by the bulbs per unit. Time `O(m log m)`.
