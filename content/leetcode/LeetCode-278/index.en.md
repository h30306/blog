---
title: "LeetCode 278: First Bad Version"
summary: "LeetCode 278 note: find the first version where isBadVersion is True with a lower-bound binary search, calling the API O(log n) times"
description: "LeetCode 278 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "binary-search", "interactive"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted ×3

## Approach

Once broken, every later version is broken, so `isBadVersion` turns `True` at some point and stays; find the first ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1): if `mid` is bad, `r = mid`, otherwise `l = mid + 1`.

## My Solution

```python
class Solution:
    def firstBadVersion(self, n: int) -> int:
        l, r = 1, n
        while l < r:
            mid = (l + r) // 2
            if isBadVersion(mid):
                r = mid
            else:
                l = mid + 1
        return l
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- The bad `mid` may be the first; use `r = mid`, not `mid - 1`.

## Interview Explanation

Every version after the first bad one is bad, so a lower-bound search shrinks the right bound to a bad middle and moves the left bound past a good one. Time `O(log n)`.
