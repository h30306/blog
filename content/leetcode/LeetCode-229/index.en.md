---
title: "LeetCode 229: Majority Element II"
summary: "LeetCode 229 note: at most two values can exceed n / 3; Boyer-Moore keeps two candidates and a second pass verifies their counts"
description: "LeetCode 229 record from 2022-11-12"
date: 2022-11-12
tags: ["medium", "array", "hash-table", "sorting", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-12
- Submissions: Accepted ×2

## Approach

At most two values can appear more than `n / 3` times. Generalizing Boyer-Moore, keep two candidates with counts: a match adds a vote; another value takes an empty slot if there is one, otherwise **both counts drop by one** (three distinct values cancel). The survivors need not exceed `n / 3`, so count them again. Hash-map counting ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1) also works, without `O(1)` space.

## My Attempts

Both submissions passed on the first try by sorting and counting each run of equal values with two pointers, keeping runs longer than `n // 3`, in `O(n log n)` rather than with voting.

## Solution

```python
class Solution:
    def majorityElement(self, nums: List[int]) -> List[int]:
        c1, c2, n1, n2 = None, None, 0, 0
        for x in nums:
            if x == c1:
                n1 += 1
            elif x == c2:
                n2 += 1
            elif n1 == 0:
                c1, n1 = x, 1
            elif n2 == 0:
                c2, n2 = x, 1
            else:
                n1, n2 = n1 - 1, n2 - 1
        return [c for c in (c1, c2) if c is not None and nums.count(c) > len(nums) // 3]
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Check for a match with either candidate before filling an empty slot, or one value may take both slots.
- Always verify the counts at the end.

## Interview Explanation

At most two values can exceed a third, so I keep two candidates with votes and decrement both on any other value, cancelling triples of distinct values, then recount the survivors. Time `O(n)`, space `O(1)`.
