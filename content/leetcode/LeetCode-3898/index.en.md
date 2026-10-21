---
title: "LeetCode 3898: Find the Degree of Each Vertex"
summary: "LeetCode 3898 note: the number of ones in row i of the adjacency matrix is vertex i's degree"
description: "LeetCode 3898 record from 2026-04-12"
date: 2026-04-12
tags: ["easy", "graph", "matrix", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-12
- Submissions: Accepted (first try)

## Approach

`matrix[i][j] = 1` means an edge between `i` and `j`, so vertex `i`'s degree is the sum of row `i`. An undirected graph's matrix is symmetric; I originally summed each column, which gives the same result.

## My Solution

```python
class Solution:
    def findDegrees(self, matrix: List[List[int]]) -> List[int]:
        return [sum(row) for row in matrix]
```

## Complexity

Time `O(n²)`, space `O(n)` for the output.

## Mistakes to Avoid

- For a directed graph, row sums are outdegrees and column sums are indegrees; they cannot be swapped.

## Interview Explanation

Row `i` of the adjacency matrix records `i`'s neighbors, so each row's sum is the degree. Time `O(n²)`.
