---
title: "LeetCode 986: Interval List Intersections"
summary: "LeetCode 986 note: two pointers each hold an interval, the intersection is [max(starts), min(ends)], and the interval that ends first cannot meet anything else, so its pointer advances"
description: "LeetCode 986 record from 2026-02-01"
date: 2026-02-01
tags: ["medium", "two-pointers", "sweep-line", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-01
- Submissions: Accepted (first try)

## Approach

Both lists are sorted and internally disjoint, so use two pointers as when merging two sorted arrays.

- The intersection is `[max(start1, start2), min(end1, end2)]`, non-empty when `lo <= hi` (closed intervals, so touching endpoints count).
- **The interval that ends first** cannot intersect any later interval in the other list (those start later), so advance its pointer.

## My Solution

```python
class Solution:
    def intervalIntersection(self, firstList: List[List[int]], secondList: List[List[int]]) -> List[List[int]]:
        i = j = 0
        res = []
        while i < len(firstList) and j < len(secondList):
            start1, end1 = firstList[i]
            start2, end2 = secondList[j]
            lo, hi = max(start1, start2), min(end1, end2)
            if lo <= hi:
                res.append([lo, hi])
            if end1 < end2:
                i += 1                             # firstList[i] ends first
            else:
                j += 1
        return res
```

## Complexity

Time `O(n + m)`, space `O(1)` excluding the output.

## Mistakes to Avoid

- Checking `lo < hi`: the closed interval `[5, 5]` is a valid intersection.
- Advancing the pointer whose interval starts first: advance the one that **ends** first.

## Interview Explanation

Both lists are sorted, so two pointers each hold one interval. The intersection runs from the larger start to the smaller end and is added when the start does not exceed the end. The interval that ends first cannot meet any later interval, so its pointer moves. Time `O(n + m)`.
