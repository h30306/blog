---
title: "LeetCode 268: Missing Number"
summary: "LeetCode 268 note: the sum of 0..n minus the array's sum is the missing number, which may be 0"
description: "LeetCode 268 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "array", "hash-table", "math", "binary-search"]
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
- Submissions: Accepted → Wrong Answer → Accepted

## Approach

`0..n` has `n + 1` numbers and the array is missing one. The full sum is `n(n + 1) / 2`; subtracting the array's sum gives the missing value. XOR also works: XOR all of `0..n` with the array, pairs cancel, and the missing one remains.

## My Attempts

The first submission passed. A November rewrite sorted and looked only for gaps larger than 1, **missing the case where 0 is absent**: `[1]` should be 0; it returned 1.

## Solution

```python
class Solution:
    def missingNumber(self, nums: List[int]) -> int:
        n = len(nums)
        return n * (n + 1) // 2 - sum(nums)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The missing value may be 0 or `n`; checking only gaps after sorting misses both.

## Interview Explanation

The sum of `0..n` is `n(n+1)/2`; subtracting the array's sum gives the missing number. Time `O(n)`, space `O(1)`.
