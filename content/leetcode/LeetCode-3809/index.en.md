---
title: "LeetCode 3809: Best Reachable Tower"
summary: "LeetCode 3809 note: keep towers within the Manhattan radius and take the minimum by (-quality, x, y), which also handles ties"
description: "LeetCode 3809 record from 2026-01-17"
date: 2026-01-17
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-17
- Submissions: Accepted (first try)

## Approach

"Highest quality, ties to the lexicographically smallest coordinate" merges into one key: the minimum of `(-q, x, y)` ([Array]({{< relref "/algorithm/Array" >}}) Template 4). Consider only towers with Manhattan distance `|x - cx| + |y - cy| <= radius`, and return `[-1, -1]` if none.

## My Solution

```python
class Solution:
    def bestTower(self, towers: List[List[int]], center: List[int], radius: int) -> List[int]:
        cx, cy = center
        reachable = [(-q, x, y) for x, y, q in towers if abs(x - cx) + abs(y - cy) <= radius]
        if not reachable:
            return [-1, -1]
        _, x, y = min(reachable)
        return [x, y]
```

I originally compared quality, x and y in an if / elif chain; a tuple key is harder to get wrong.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Quality should be maximal, so the key uses `-q` to take the minimum together with the coordinates.

## Interview Explanation

I keep towers within the radius and take the minimum of (negative quality, x, y), which picks the highest quality with the smallest coordinate on ties; with none, return `[-1, -1]`. Time `O(n)`.
