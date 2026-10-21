---
title: "LeetCode 1464: Maximum Product of Two Elements in an Array"
summary: "LeetCode 1464 note: all values are positive, so take the two largest a and b and return (a - 1)(b - 1)"
description: "LeetCode 1464 record from 2022-11-21"
date: 2022-11-21
tags: ["easy", "array", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-21
- Submissions: Accepted (first try)

## Approach

Since `nums[i] >= 1`, every `(x - 1)` is non-negative, so the two largest values maximize the product. Track the largest and second largest in one pass (or pop twice from a heap, [Heap]({{< relref "/algorithm/Heap" >}})).

## My Attempts

Passed on the first try by negating everything into a heap and popping twice for the two largest.

## Solution

```python
class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        a = b = 0
        for x in nums:
            if x > a:
                a, b = x, a
            elif x > b:
                b = x
        return (a - 1) * (b - 1)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- When a new maximum arrives, the old maximum becomes the second largest.

## Interview Explanation

With positive values the best product uses the two largest numbers minus one each, which I track in one pass. Time `O(n)`, space `O(1)`.
