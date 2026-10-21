---
title: "LeetCode 69: Sqrt(x)"
summary: "LeetCode 69 note: find the largest mid with mid² <= x; when a closed-interval search ends, r is the answer"
description: "LeetCode 69 record from 2022-05-12"
date: 2022-05-12
tags: ["easy", "math", "binary-search", "newtons-method"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-05-12
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Find the largest `k` with `k² <= x` ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 4). Binary search the closed `[0, x]`: if `mid² <= x` look right for larger, otherwise left. When the loop ends `r` sits on the last valid value.

## My Attempts

In May 2022 attempt 1 used `/`, making `mid` a float: `x = 5` returned 1.5; switching to `//` passed. An August rewrite came out one too high: `x = 5` returned 3.

## Solution

```python
class Solution:
    def mySqrt(self, x: int) -> int:
        l, r = 0, x
        while l <= r:
            mid = (l + r) // 2
            if mid * mid <= x:
                l = mid + 1
            else:
                r = mid - 1
        return r
```

## Complexity

Time `O(log x)`, space `O(1)`.

## Mistakes to Avoid

- Use integer division for `mid`.
- The answer rounds down: return the last value with `mid² <= x`.

## Interview Explanation

I binary search 0 to `x`, going right while the square fits and left otherwise; the right bound at the end is the largest integer whose square fits. Time `O(log x)`.
