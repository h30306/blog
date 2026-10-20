---
title: "LeetCode 3899: Angles of a Triangle"
summary: "LeetCode 3899 note: check the triangle inequality first, compute the three angles with the law of cosines, and remember to sort them"
description: "LeetCode 3899 record from 2026-04-12"
date: 2026-04-12
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
First Attempt: 2026-04-12
- Submissions: Wrong Answer → Accepted

## Approach

1. **Triangle inequality**: positive area ⇔ any two sides sum to more than the third (strictly; equality makes the points collinear with zero area).
2. **Law of cosines**: `cos A = (b² + c² - a²) / (2bc)`, `A = acos(cos A)`, converted to degrees.
3. Output in **non-decreasing** order.

## My Attempts

Attempt 1 computed the angles correctly but returned them in the order of `a, b, c` without sorting. For `sides = [4, 4, 1]` it returned `[82.8, 82.8, 14.4]` instead of `[14.4, 82.8, 82.8]`. Adding `sorted` passed.

## Solution

```python
from math import acos, degrees

class Solution:
    def internalAngles(self, sides: List[int]) -> List[float]:
        a, b, c = sorted(sides)
        if a + b <= c:
            return []                              # zero area or not a triangle
        def angle(opp: int, x: int, y: int) -> float:
            cos_v = (x * x + y * y - opp * opp) / (2 * x * y)
            return degrees(acos(max(-1.0, min(1.0, cos_v))))   # guard float error outside [-1, 1]
        return sorted([angle(a, b, c), angle(b, a, c), angle(c, a, b)])
```

Sorting first means the triangle inequality only needs the two shortest sides compared with the longest.

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Sort the output.
- The triangle inequality is strict.
- Floating-point error can push `acos`'s argument slightly outside `[-1, 1]`; clamping is safer.

## Interview Explanation

I sort the sides; it is a triangle only if the two shortest sum to strictly more than the longest. Then the law of cosines gives each angle, converted to degrees, and the output is sorted. Time `O(1)`.
