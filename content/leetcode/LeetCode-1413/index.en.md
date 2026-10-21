---
title: "LeetCode 1413: Minimum Value to Get Positive Step by Step Sum"
summary: "LeetCode 1413 note: the start value plus every prefix sum must be at least 1, so it is max(1, 1 - minimum prefix sum)"
description: "LeetCode 1413 record from 2022-11-23"
date: 2022-11-23
tags: ["easy", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-23
- Submissions: Accepted (first try)

## Approach

The running values are `start + prefix[i]` ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})) and all must be `>= 1`; the binding one is the **minimum prefix sum**, so `start >= 1 - min(prefix)`. The start value must itself be positive, hence the max with 1.

## My Solution

```python
class Solution:
    def minStartValue(self, nums: List[int]) -> int:
        cur = low = 0
        for x in nums:
            cur += x
            low = min(low, cur)
        return 1 - low
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Starting `low` at 0 also encodes "the start value itself must be `>= 1`".

## Interview Explanation

Each step's value is the start plus a prefix sum, so I find the minimum prefix sum and answer 1 minus it; starting the minimum at 0 keeps the answer at least 1. Time `O(n)`.
