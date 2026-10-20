---
title: "LeetCode 1401: Circle and Rectangle Overlapping"
summary: "LeetCode 1401 note: the rectangle's nearest point to the center is the center clamped into the rectangle; they overlap when that point is within the radius"
description: "LeetCode 1401 record from 2026-01-05"
date: 2026-01-05
tags: ["medium", "math", "geometry"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-05
- Submissions: Wrong Answer ×3 → Accepted

## Approach

The circle and the rectangle intersect ⇔ **the rectangle's nearest point to the center** lies in the circle.

That point is easy: x and y are independent, so clamp the center's x into `[x1, x2]` and y into `[y1, y2]`:

```text
nx = min(max(xc, x1), x2)
ny = min(max(yc, y1), y2)
```

With the center inside the rectangle, the nearest point is the center itself at distance 0, which also counts as overlapping.

Compare squared distances to avoid floating-point square roots.

## My Attempts

My version split into four directions (the center left of, below, right of, or above the rectangle) and found the nearest point in each. Two of the four `if`s were wrong:

| Version | Problem |
|---|---|
| Attempt 1 | Missed the center-inside case; the last direction (above) was `yCenter < y2` instead of `yCenter > y2`. With radius 2, center `(6, 4)` and rectangle `(5, 0)–(6, 2)`, the top edge point `(6, 2)` is exactly 2 away, so the answer is `True`; it returned `False` |
| Attempt 2 | Added center-inside, but the "above" condition was still wrong; the same example returned `False` |
| Attempt 3 | Changed it to `<=`, still the wrong direction. With radius 3, center `(3, 4)` and rectangle `(2, 2)–(5, 3)`, the answer is `True`; it returned `False` |
| AC | Changed it to `yCenter >= y2` |

Clamping needs no cases, so there is no direction to get backwards.

## Solution

```python
class Solution:
    def checkOverlap(self, radius: int, xCenter: int, yCenter: int, x1: int, y1: int, x2: int, y2: int) -> bool:
        nx = min(max(xCenter, x1), x2)             # the rectangle's nearest point to the center
        ny = min(max(yCenter, y1), y2)
        return (nx - xCenter) ** 2 + (ny - yCenter) ** 2 <= radius ** 2
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Writing a comparison backwards in a case split.
- Missing the center-inside case.
- Comparing floating-point square roots: squared comparisons are more robust.

## Interview Explanation

I find the rectangle's nearest point to the center by clamping each coordinate of the center into the rectangle; they overlap when its squared distance is at most the squared radius. With the center inside, the nearest point is the center itself, which works naturally. Time `O(1)`.
