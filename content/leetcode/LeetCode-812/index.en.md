---
title: "LeetCode 812: Largest Triangle Area"
summary: "LeetCode 812 note: with at most 50 points, enumerate every triple and take the largest shoelace area"
description: "LeetCode 812 record from 2022-09-07"
date: 2022-09-07
tags: ["easy", "array", "math", "geometry", "polygons"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-07
- Submissions: Wrong Answer ×2 → Accepted

## Approach

With at most 50 points there are about 20,000 triples, so enumerate them ([Math]({{< relref "/algorithm/Math" >}}) Template 3). The area comes from the shoelace formula (cross product): `|(x2 - x1)(y3 - y1) - (x3 - x1)(y2 - y1)| / 2`.

## My Attempts

The first two tried "half the bounding box" directly:

- Attempt 1 also read `[0]` (the x coordinate) for the y extremes and got a negative `-0.5`.
- Attempt 2 fixed the coordinates, but **the largest triangle need not be half the bounding box**: for `[[1, 5], [2, 0], [2, 2]]` half the box is 2.5 while the triangle's area is only 1.0.

A week later, enumerating triples with the shoelace formula passed.

## Solution

```python
class Solution:
    def largestTriangleArea(self, points: List[List[int]]) -> float:
        best = 0
        for (x1, y1), (x2, y2), (x3, y3) in combinations(points, 3):
            area = abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)) / 2
            best = max(best, area)
        return best
```

## Complexity

Time `O(n³)`, space `O(1)`.

## Mistakes to Avoid

- The largest triangle is not necessarily half the bounding box; actually enumerate triples.
- The cross product can be negative; take its absolute value.

## Interview Explanation

With few points I enumerate every triple, compute the area by cross product, and keep the maximum. Time `O(n³)` with n at most 50.
