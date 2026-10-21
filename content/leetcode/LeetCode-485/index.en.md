---
title: "LeetCode 485: Max Consecutive Ones"
summary: "LeetCode 485 note: extend the current count on a 1, reset it on a 0, and keep the maximum"
description: "LeetCode 485 record from 2022-08-24"
date: 2022-08-24
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
First Attempt: 2022-08-24
- Submissions: Accepted ×4

## Approach

Like LC 674, walk the runs ([Array]({{< relref "/algorithm/Array" >}}) Template 1): add one on a 1, reset on a 0, and update the maximum each step.

## My Solution

```python
class Solution:
    def findMaxConsecutiveOnes(self, nums: List[int]) -> int:
        best = cur = 0
        for x in nums:
            cur = cur + 1 if x == 1 else 0
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Update the maximum every step so the last run is not missed.

## Interview Explanation

I scan once, adding one on each 1 and resetting on each 0, updating the maximum every step. Time `O(n)`, space `O(1)`.
