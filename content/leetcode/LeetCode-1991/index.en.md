---
title: "LeetCode 1991: Find the Middle Index in Array"
summary: "LeetCode 1991 note: compute the total, maintain the left sum while scanning, and get the right sum as total - left - nums[i]"
description: "LeetCode 1991 record from 2022-11-23"
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

Compute `total`, maintain `left` from the left ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})), and the right sum is `total - left - nums[i]`. The first position with `left == right` is the answer (the leftmost is required). It is the same problem as LC 724.

## My Solution

```python
class Solution:
    def findMiddleIndex(self, nums: List[int]) -> int:
        total, left = sum(nums), 0
        for i, x in enumerate(nums):
            if left == total - left - x:
                return i
            left += x
        return -1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Add `nums[i]` to `left` after comparing; the element itself belongs to neither side.

## Interview Explanation

I compute the total and maintain the left sum; the right sum is the total minus the left and the current element, and the first match is the answer. Time `O(n)`, space `O(1)`.
