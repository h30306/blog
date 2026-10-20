---
title: "LeetCode 3492: Maximum Containers on a Ship"
summary: "LeetCode 3492 note: at most n² cells and at most maxWeight // w by weight, so take the smaller, using integer division"
description: "LeetCode 3492 record from 2025-03-23"
date: 2025-03-23
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-03-23
- Submissions: Wrong Answer → Accepted ×2

## Approach

Take the smaller of two limits:

- Cells: `n × n`.
- Weight: each container weighs `w`, so at most `maxWeight // w` (rounded down).

## My Attempts

Attempt 1 used `maxWeight / w`, returning a float. For `n = 2`, `w = 3`, `maxWeight = 7` the answer is 2; it returned `2.333...`. Wrapping it in `int(...)` passed; `//` is clearer.

## Solution

```python
class Solution:
    def maxContainers(self, n: int, w: int, maxWeight: int) -> int:
        return min(n * n, maxWeight // w)
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `/` is float division in Python 3; counts need `//`.

## Interview Explanation

The count is limited both by the `n²` cells and by weight, `maxWeight // w`, so I take the smaller. Time `O(1)`.
