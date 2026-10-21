---
title: "LeetCode 1732: Find the Highest Altitude"
summary: "LeetCode 1732 note: the altitudes are prefix sums of gain starting from 0; take the maximum"
description: "LeetCode 1732 record from 2022-11-23"
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

Point `i` sits at `gain[0] + ... + gain[i - 1]`, a prefix sum ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})). The starting altitude 0 counts too, so the answer is at least 0.

## My Solution

```python
class Solution:
    def largestAltitude(self, gain: List[int]) -> int:
        best = cur = 0
        for g in gain:
            cur += g
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The start at 0 is an altitude too; if every gain is negative the answer is 0.

## Interview Explanation

The altitudes are prefix sums of gain, so I accumulate and keep the maximum, counting the starting 0. Time `O(n)`, space `O(1)`.
