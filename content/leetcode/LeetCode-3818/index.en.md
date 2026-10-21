---
title: "LeetCode 3818: Minimum Prefix Removal to Make Array Strictly Increasing"
summary: "LeetCode 3818 note: find the longest strictly increasing suffix from the right; everything before it must go"
description: "LeetCode 3818 record from 2026-01-25"
date: 2026-01-25
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-25
- Submissions: Accepted (first try)

## Approach

What remains is a suffix that must be strictly increasing. A longer suffix means a shorter removed prefix, so walk left from the end while `nums[i - 1] < nums[i]` ([Array]({{< relref "/algorithm/Array" >}}) Template 1). Where it stops, `i`, is the length to remove.

## My Solution

```python
class Solution:
    def minimumPrefixLength(self, nums: List[int]) -> int:
        i = len(nums) - 1
        while i > 0 and nums[i - 1] < nums[i]:
            i -= 1
        return i
```

I originally wrote `while ... else: return right`; with no `break` the `else` always runs, so it is equivalent, but returning directly is clearer.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Strictly increasing: stop at equal values too.

## Interview Explanation

The remainder must be a strictly increasing suffix, so I walk left until the first non-increasing step; that index is the prefix length to remove. Time `O(n)`.
