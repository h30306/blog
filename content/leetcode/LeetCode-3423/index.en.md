---
title: "LeetCode 3423: Maximum Difference Between Adjacent Elements in a Circular Array"
summary: "LeetCode 3423 note: circular adjacency includes the last and first elements; starting from i = 0 with nums[i - 1] covers it"
description: "LeetCode 3423 record from 2025-07-17"
date: 2025-07-17
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-07-17
- Submissions: Accepted (first try)

## Approach

Take the maximum absolute difference over adjacent pairs ([Array]({{< relref "/algorithm/Array" >}}) Template 1). Circular means the last and first elements are adjacent too. In Python `nums[-1]` is the last element, so starting `i` at 0 and comparing with `nums[i - 1]` covers every adjacent pair at once.

## My Solution

```python
class Solution:
    def maxAdjacentDistance(self, nums: List[int]) -> int:
        return max(abs(nums[i] - nums[i - 1]) for i in range(len(nums)))
```

I originally added `abs(nums[-1] - nums[0])` separately, which is equivalent.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Remember the ends are adjacent too.

## Interview Explanation

I take the maximum difference over adjacent pairs including last and first; comparing with `nums[i - 1]` from `i = 0` naturally includes that pair. Time `O(n)`.
