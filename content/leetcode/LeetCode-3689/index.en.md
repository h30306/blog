---
title: "LeetCode 3689: Maximum Total Subarray Value I"
summary: "LeetCode 3689 note: the same subarray may be chosen repeatedly, and the whole array's max minus min is the best single value, so choose it k times"
description: "LeetCode 3689 record from 2025-09-21"
date: 2025-09-21
tags: ["medium", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-09-21
- Submissions: Accepted (first try)

## Approach

A subarray's value is its max minus its min. Any subarray's max is `<=` the array's max and its min `>=` the array's min, so **the whole array has the largest value**. The same subarray may be chosen repeatedly, so choose it `k` times.

## My Solution

```python
class Solution:
    def maxTotalValue(self, nums: List[int], k: int) -> int:
        return (max(nums) - min(nums)) * k
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Notice the "same subarray can repeat" condition; if each subarray could be chosen only once, this shortcut fails and you would need the `k` largest values.

## Interview Explanation

No subarray's max minus min exceeds the whole array's, and repeats are allowed, so the answer is the whole array's value times `k`. Time `O(n)`.
