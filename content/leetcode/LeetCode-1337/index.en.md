---
title: "LeetCode 1337: The K Weakest Rows in a Matrix"
summary: "LeetCode 1337 note: soldiers come first in each row, so binary search the first 0 for the count; sort by (count, row index) and take k"
description: "LeetCode 1337 record from 2022-11-21"
date: 2022-11-21
tags: ["easy", "array", "binary-search", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-21
- Submissions: Accepted (first try)

## Approach

Each row's 1s precede its 0s, so the soldier count is the position of the first 0, found by binary search ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). Sort by `(count, row index)` and take the first `k` indices.

## My Solution

```python
class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        def soldiers(row):
            l, r = 0, len(row)
            while l < r:
                mid = (l + r) // 2
                if row[mid] == 1:
                    l = mid + 1
                else:
                    r = mid
            return l
        return sorted(range(len(mat)), key=lambda i: (soldiers(mat[i]), i))[:k]
```

I originally used `sum(row)` and a heap, which also passes; here binary search uses the fact that the 1s come first.

## Complexity

Time `O(m log n + m log m)`, space `O(m)`.

## Mistakes to Avoid

- With equal counts, the smaller row index is weaker.

## Interview Explanation

Soldiers lead each row, so binary search finds the first 0 for the count; sorting by (count, index) gives the first `k`. Time `O(m log n + m log m)`.
