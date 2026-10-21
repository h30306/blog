---
title: "LeetCode 118: Pascal's Triangle"
summary: "LeetCode 118 note: each row starts and ends with 1, and every inner cell is the sum of the two cells above it"
description: "LeetCode 118 record from 2022-08-16"
date: 2022-08-16
tags: ["easy", "array", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-16
- Submissions: Accepted ×6

## Approach

Row `i` has `i + 1` numbers with 1 at both ends, and inner cells are `row[j] = prev[j - 1] + prev[j]` ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1). Create rows of 1s first, then fill the middle.

## My Solution

```python
class Solution:
    def generate(self, numRows: int) -> List[List[int]]:
        rows = [[1] * (i + 1) for i in range(numRows)]
        for i in range(2, numRows):
            for j in range(1, i):
                rows[i][j] = rows[i - 1][j - 1] + rows[i - 1][j]
        return rows
```

## Complexity

Time `O(n²)`, space `O(n²)` (output).

## Mistakes to Avoid

- Row `i` has `i + 1` numbers, counting from 0.

## Interview Explanation

Each row has 1s at the ends and each inner cell sums the two cells above, so I create rows of 1s and fill the middle. Time `O(n²)`.
