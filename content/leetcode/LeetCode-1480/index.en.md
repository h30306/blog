---
title: "LeetCode 1480: Running Sum of 1d Array"
summary: "LeetCode 1480 note: the definition of a prefix sum, adding each element to the previous running total"
description: "LeetCode 1480 record from 2022-11-23"
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

The prefix sum itself ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})): `res[i] = res[i - 1] + nums[i]`. In Python, `itertools.accumulate` does it directly.

## My Solution

```python
class Solution:
    def runningSum(self, nums: List[int]) -> List[int]:
        for i in range(1, len(nums)):
            nums[i] += nums[i - 1]
        return nums
```

## Complexity

Time `O(n)`, space `O(1)` in place.

## Mistakes to Avoid

- Start at index 1; element 0 stays as is.

## Interview Explanation

Adding the previous total to each element gives the prefix sums, done in place in `O(n)`.
