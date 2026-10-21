---
title: "LeetCode 414: Third Maximum Number"
summary: "LeetCode 414 note: track the three largest distinct values, skipping repeats, and return the maximum if fewer than three distinct values exist"
description: "LeetCode 414 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "array", "sorting"]
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
- Submissions: Accepted (first try)

## Approach

The problem asks for the third largest **distinct** value. Keep `first > second > third` in one pass, skip values already present, and shift everything down when a new maximum arrives ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1). With fewer than three distinct values return the maximum. `O(n)`, no sorting.

## My Attempts

Passed on the first try with `sorted(set(nums))[-3]`, falling back to `max(nums)` via `try/except` when fewer than three exist, in `O(n log n)`.

## Solution

```python
class Solution:
    def thirdMax(self, nums: List[int]) -> int:
        top = []
        for x in nums:
            if x in top:
                continue
            top.append(x)
            top.sort(reverse=True)
            if len(top) > 3:
                top.pop()
        return top[2] if len(top) == 3 else top[0]
```

## Complexity

Time `O(n)`, space `O(1)` (`top` holds at most 4).

## Mistakes to Avoid

- Count distinct values only; repeats do not count.

## Interview Explanation

I keep at most three distinct largest values, skipping repeats and trimming to three after each insert, then return the third if it exists or else the maximum. Time `O(n)`.
