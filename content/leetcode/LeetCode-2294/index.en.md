---
title: "LeetCode 2294: Partition Array Such That Maximum Difference Is K"
summary: "LeetCode 2294 note: subsequences ignore order, so sort and extend each group from its minimum until a value exceeds min + k"
description: "LeetCode 2294 record from 2025-09-03"
date: 2025-09-03
tags: ["medium", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-09-03
- Submissions: Accepted (first try)

## Approach

A group only cares about max minus min, not order, so sort first. Start a group at the smallest number and add everything `<= start + k`; the first number beyond that starts a new group.

Why extending as far as possible is right: the smallest number is in some group, and that group can reach at most `start + k`; taking more only leaves fewer numbers for later. This is [Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1.

## My Solution

```python
class Solution:
    def partitionArray(self, nums: List[int], k: int) -> int:
        nums.sort()
        groups = 1
        start = nums[0]
        for x in nums[1:]:
            if x - start > k:
                groups += 1
                start = x
        return groups
```

## Complexity

Time `O(n log n)`, space `O(1)` besides sorting.

## Mistakes to Avoid

- Compare with the group's **minimum**, not with the previous number.

## Interview Explanation

Subsequences ignore order, so I sort. I open a group at the smallest number and include everything within `k` of it, starting a new group when that fails. The group holding the smallest number can only reach that far anyway, so extending it fully is never worse. Time `O(n log n)`.
