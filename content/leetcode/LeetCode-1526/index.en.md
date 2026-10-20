---
title: "LeetCode 1526: Minimum Number of Increments on Subarrays to Form a Target Array"
summary: "LeetCode 1526 note: scanning left to right, every rise above the previous height needs that many new operations; drops reuse earlier operations"
description: "LeetCode 1526 record from 2026-07-04"
date: 2026-07-04
tags: ["hard", "dynamic-programming", "greedy", "monotonic-stack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-04
- Submissions: Accepted (first try)

## Approach

Think of `target` as a row of heights, where each operation raises a contiguous stretch by 1.

Scanning left to right:

- The first cell needs `target[0]` operations.
- If `target[i] <= target[i - 1]`, cell `i` can reuse operations covering the previous cell (extend them), needing nothing new.
- If `target[i] > target[i - 1]`, the extra `target[i] - target[i - 1]` layers need **new** operations, since the previous cell is only that tall.

So the answer is `target[0] + Σ max(0, target[i] - target[i - 1])`.

## My Solution

```python
class Solution:
    def minNumberOperations(self, target: List[int]) -> int:
        ops = target[0]
        for i in range(1, len(target)):
            ops += max(0, target[i] - target[i - 1])   # rises need new operations
        return ops
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Drops add nothing: earlier operations simply stop there.

## Interview Explanation

Treat the array as heights, with each operation raising a contiguous stretch by one layer. Going left to right, any part higher than the previous cell needs new operations, while equal or lower cells reuse earlier ones. So the answer is the first height plus every rise. Time `O(n)`.
