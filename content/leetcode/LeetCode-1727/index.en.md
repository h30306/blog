---
title: "LeetCode 1727: Largest Submatrix With Rearrangements"
summary: "LeetCode 1727 note: compute each row's heights of consecutive ones above; columns can be reordered, so sort heights descending and the j-th tallest times j + 1 is a candidate"
description: "LeetCode 1727 record from 2026-06-23"
date: 2026-06-23
tags: ["medium", "greedy", "sorting", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-23
- Submissions: Accepted (first try)

## Approach

Fix the submatrix's **bottom edge** at row `i`. Each column has `h[j]` consecutive ones going up (the same heights as "largest rectangle in a histogram").

Columns can be reordered, so put the tall ones together: sort heights descending; taking the first `j + 1` columns, the height is limited by the `(j + 1)`-th tallest, giving area `sorted_h[j] × (j + 1)`. Take the maximum over every row and `j`.

After reordering, column positions no longer matter, so no monotonic stack is needed; sorting is enough ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1).

## My Solution

```python
class Solution:
    def largestSubmatrix(self, matrix: List[List[int]]) -> int:
        n = len(matrix[0])
        h = [0] * n
        best = 0
        for row in matrix:
            for j in range(n):
                h[j] = h[j] + 1 if row[j] else 0
            for j, height in enumerate(sorted(h, reverse=True)):
                best = max(best, height * (j + 1))
        return best
```

I originally accumulated the heights inside `matrix`; here a separate `h` avoids modifying the input.

## Complexity

Time `O(m · n log n)`, space `O(n)`.

## Mistakes to Avoid

- A 0 resets the height; it does not carry over.
- Sort a copy of the heights, not `h` itself (the next row needs each column's own height).

## Interview Explanation

I fix the bottom edge and compute how many consecutive ones each column has above it. Columns can be reordered, so I sort heights descending; using the first `j + 1` columns the height is the `(j + 1)`-th tallest, and the area is that times `j + 1`. I do this for every row and keep the maximum. Time `O(m · n log n)`.
