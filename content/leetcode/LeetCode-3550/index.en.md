---
title: "LeetCode 3550: Smallest Index With Digit Sum Equal to Index"
summary: "LeetCode 3550 note: check indices in increasing order, computing each digit sum; the first match is the answer"
description: "LeetCode 3550 record from 2025-05-18"
date: 2025-05-18
tags: ["easy", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-18
- Submissions: Accepted (first try)

## Approach

Starting from index 0, compute the digit sum of `nums[i]`; the first one equal to `i` is the smallest index. If none, return -1.

## My Solution

```python
class Solution:
    def smallestIndex(self, nums: List[int]) -> int:
        for i, x in enumerate(nums):
            if sum(int(c) for c in str(x)) == i:
                return i
        return -1
```

## Complexity

Time `O(n · d)` with `d` digits, space `O(d)`.

## Mistakes to Avoid

- Return the smallest index: scan from the start and stop at the first match.

## Interview Explanation

Scanning indices in increasing order, I sum each number's digits via its string form and return the first index that matches, otherwise -1. Time `O(n · d)`.
