---
title: "LeetCode 452: Minimum Number of Arrows to Burst Balloons"
summary: "LeetCode 452 note: sort by end and shoot at the end; only a balloon starting after the arrow needs a new one, and touching ends count as overlapping"
description: "LeetCode 452 record from 2026-11-03"
date: 2026-11-03
tags: ["medium", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-03
- Submissions: Accepted (first try)

## Approach

Sort by end ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 2). Shoot the first arrow at the **end** of the first balloon: the further right, the more later balloons it can hit, but it cannot go past this balloon's end.

Moving on, a balloon whose start is `<=` the arrow position is hit by that arrow; a start `>` the arrow position needs a new arrow, shot at that balloon's end.

It is almost LC 435; only the boundary differs. Balloons are closed intervals, so `[1,2]` and `[2,3]` both burst with one arrow at 2: **touching ends overlap** and the test is `>`. In LC 435 touching ends do not overlap and the test is `>=`.

## My Attempts

Accepted on the first try. Having just written LC 435, I only had to change `>=` to `>`.

## Solution

```python
class Solution:
    def findMinArrowShots(self, points: List[List[int]]) -> int:
        points.sort(key=lambda x: x[1])
        arrows, pos = 0, float("-inf")
        for start, end in points:
            if start > pos:           # current arrow misses, shoot a new one at the end
                arrows += 1
                pos = end
        return arrows
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Copying `>=` from LC 435: `[[1,2],[2,3]]` returns 2; the answer is 1.
- When sorting by start, shrink the arrow position to `min(pos, end)` on overlap, or balloons with a smaller end are missed. Sorting by end avoids this.

## Interview Explanation

I sort by end and shoot every arrow at the current balloon's end, which hits as many later balloons as possible. Scanning forward, a balloon whose start does not pass the arrow is hit; otherwise I shoot another arrow at that balloon's end. Touching ends overlap, so the test is strictly greater, not greater-or-equal. Time `O(n log n)`.
