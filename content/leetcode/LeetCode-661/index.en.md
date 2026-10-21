---
title: "LeetCode 661: Image Smoother"
summary: "LeetCode 661 note: each cell becomes the floored average of the existing cells in its 3 × 3 neighborhood, written into a new matrix"
description: "LeetCode 661 record from 2022-08-29"
date: 2022-08-29
tags: ["easy", "array", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-29
- Submissions: Runtime Error → Wrong Answer ×3 → Runtime Error ×4 → Accepted ×2

## Approach

For each cell enumerate `dx, dy ∈ {-1, 0, 1}` ([Matrix]({{< relref "/algorithm/Matrix" >}}) Template 3), keep in-range neighbors, and take sum `//` count. Write into a **new matrix**, or later cells read already-smoothed values. Build it with a comprehension; every row of `[[0] * n] * m` is the same list.

## My Attempts

This took 10 submissions:

- The result was `[[0] * n] * m`, **so every row was the same list** and the last row overwrote all of them: `[[45], [69], [2]]` returned 35 in every row. The first version also used `/`, producing values like 41.5.
- Switching to appending as I went, the condition for starting a new row was wrong and kept raising IndexError; `i == len(res)` passed.

## Solution

```python
class Solution:
    def imageSmoother(self, img: List[List[int]]) -> List[List[int]]:
        m, n = len(img), len(img[0])
        res = [[0] * n for _ in range(m)]
        for i in range(m):
            for j in range(n):
                total = count = 0
                for x in range(i - 1, i + 2):
                    for y in range(j - 1, j + 2):
                        if 0 <= x < m and 0 <= y < n:
                            total += img[x][y]
                            count += 1
                res[i][j] = total // count
        return res
```

## Complexity

Time `O(9mn)`, space `O(mn)` (output).

## Mistakes to Avoid

- Every row of `[[0] * n] * m` is the same list, so writing one writes all.
- The average is floored; use `//`.

## Interview Explanation

For each cell I enumerate its 3 × 3 neighborhood, sum the in-range cells, floor-divide by their count, and write into a new matrix. Time `O(9mn)`.
