---
title: "LeetCode 836: Rectangle Overlap"
summary: "LeetCode 836 note: two rectangles overlap exactly when their x intervals and y intervals both overlap, i.e. min(right) > max(left)"
description: "LeetCode 836 record from 2022-09-15"
date: 2022-09-15
tags: ["easy", "math", "geometry"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-15
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×4 → Runtime Error ×2 → Wrong Answer ×4 → Accepted

## Approach

2D overlap splits into two 1D interval overlaps ([Math]({{< relref "/algorithm/Math" >}}) Template 3): the intersection is `min(x2) - max(x1)` wide and `min(y2) - max(y1)` tall, and **both must be positive** (touching edges do not count). No case analysis of who is left of whom is needed.

## My Attempts

This took 13 submissions; the first twelve did case analysis on "some endpoint lies inside the other rectangle's range" and always missed a case:

- Checking only that `rec2` starts before `rec1` ends: `[1, 2, 3, 4]` and `[2, 1, 4, 2]` merely touch at `y = 2`, yet it returned `True`.
- Checking only y, or with strict inequalities: identical y ranges (`[1, 0, 4, 2]`, `[3, 0, 4, 2]`) returned `False`.
- With endpoint checks on both axes, **containment** slipped through: `[3, 3, 4, 4]` lies inside `[3, 2, 6, 5]`, and it returned `False`.

Computing the intersection's width and height finally passed.

## Solution

```python
class Solution:
    def isRectangleOverlap(self, rec1: List[int], rec2: List[int]) -> bool:
        width = min(rec1[2], rec2[2]) - max(rec1[0], rec2[0])
        height = min(rec1[3], rec2[3]) - max(rec1[1], rec2[1])
        return width > 0 and height > 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Check both the x and the y direction.
- Use strict inequality; touching edges do not count.
- When one rectangle contains the other, neither endpoint falls inside the other's range, so endpoint-in-interval checks miss it.

## Interview Explanation

I split the overlap into x and y intervals: the intersection width is the smaller right edge minus the larger left edge, likewise for height, and both must be positive. Time `O(1)`.
