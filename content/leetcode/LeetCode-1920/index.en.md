---
title: "LeetCode 1920: Build Array from Permutation"
summary: "LeetCode 1920 note: follow the definition ans[i] = nums[nums[i]]; for O(1) extra space, stack the new value times n on top of the old one"
description: "LeetCode 1920 record from 2025-05-06"
date: 2025-05-06
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-05-06
- Submissions: Accepted (first try)

## Approach

Build the new array by definition ([Array]({{< relref "/algorithm/Array" >}}) Template 5). For the `O(1)` extra-space follow-up, values lie in `0..n-1`, so each slot can hold two: `nums[i] += n * (nums[nums[i]] % n)`; `% n` recovers the old value and `// n` the new one.

## My Solution

```python
class Solution:
    def buildArray(self, nums: List[int]) -> List[int]:
        return [nums[x] for x in nums]
```

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- When working in place, read old values with `% n`, since earlier slots may already be modified.

## Interview Explanation

Building `ans[i] = nums[nums[i]]` directly is enough. In place, since values are below `n`, add the new value times `n` onto each slot and divide by `n` at the end. Time `O(n)`.
