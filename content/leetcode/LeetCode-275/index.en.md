---
title: "LeetCode 275: H-Index II"
summary: "LeetCode 275 note: with sorted citations, find the first i where citations[i] >= n - i; the answer is n - i, in O(log n) with binary search"
description: "LeetCode 275 record from 2022-11-27"
date: 2022-11-27
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-27
- Submissions: Wrong Answer ×2 → Accepted ×2

## Approach

The h-index is the largest `h` with `h` papers cited at least `h` times. The array is ascending; from index `i` to the end there are `n - i` papers, so the condition is `citations[i] >= n - i` ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). It goes false-then-true from left to right, so find the first true `i`; the answer is `n - i`, or 0 when `i = n`.

## My Attempts

The first two versions scanned linearly but compared against the total count and returned nothing when no index matched: `[0]` returned `None` instead of 0.

## Solution

```python
class Solution:
    def hIndex(self, citations: List[int]) -> int:
        n = len(citations)
        l, r = 0, n
        while l < r:
            mid = (l + r) // 2
            if citations[mid] >= n - mid:
                r = mid
            else:
                l = mid + 1
        return n - l
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- With all citations 0 the answer is 0; every path must return.

## Interview Explanation

With sorted citations, from some index on there are enough citations, so I binary search the first `i` with `citations[i] >= n - i` and return `n - i`. Time `O(log n)`.
