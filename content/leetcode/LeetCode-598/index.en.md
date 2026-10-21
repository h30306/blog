---
title: "LeetCode 598: Range Addition II"
summary: "LeetCode 598 note: every operation covers the top-left corner, so the most-incremented cells form the intersection of all operations: min(a) × min(b)"
description: "LeetCode 598 record from 2022-08-28"
date: 2022-08-28
tags: ["easy", "array", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-28
- Submissions: Wrong Answer → Accepted ×3 → Runtime Error ×2 → Accepted ×2

## Approach

Each operation is a rectangle anchored at `(0, 0)`, so the cells hit by **every** operation hold the maximum; they form the intersection, `min(a)` rows by `min(b)` columns, each minimum taken **separately** and then multiplied ([Math]({{< relref "/algorithm/Math" >}}) Template 4). With no operations everything is 0 and the answer is `m × n`.

## My Attempts

Attempt 1 returned `min(min_row, min_column) ** 2` when the two minimums differed, **treating the intersection as a square**: `m = 4`, `n = 1`, `ops = [[2, 1]]` should be 2; it returned 1. Two REs followed (a misnamed variable, a type error), and multiplying the two passed.

## Solution

```python
class Solution:
    def maxCount(self, m: int, n: int, ops: List[List[int]]) -> int:
        for a, b in ops:
            m, n = min(m, a), min(n, b)
        return m * n
```

## Complexity

Time `O(k)` for `k` operations, space `O(1)`.

## Mistakes to Avoid

- The intersection need not be square; take the row and column minimums separately.
- With no operations the answer is `m × n`.

## Interview Explanation

Every operation contains the top-left corner, so the maximum cells are the intersection of all operations: the product of the minimum row and column bounds, starting from m and n so no operations gives m × n. Time `O(k)`.
