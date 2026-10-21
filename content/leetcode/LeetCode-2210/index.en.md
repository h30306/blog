---
title: "LeetCode 2210: Count Hills and Valleys in an Array"
summary: "LeetCode 2210 note: treat equal neighbors as one point and remember only the last non-flat direction; up then down is a hill, down then up a valley"
description: "LeetCode 2210 record from 2025-07-27"
date: 2025-07-27
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
First Attempt: 2025-07-27
- Submissions: Accepted (first try)

## Approach

Equal neighbors belong to the same hill or valley, so look only at directions: each adjacent pair goes up, down or flat ([Array]({{< relref "/algorithm/Array" >}}) Template 1). Skip flat pairs and remember the last non-flat direction; up turning down is a hill, down turning up a valley.

## My Solution

```python
class Solution:
    def countHillValley(self, nums: List[int]) -> int:
        res, prev = 0, 0                       # prev：上一個不平的方向，1 上、-1 下
        for a, b in zip(nums, nums[1:]):
            d = (b > a) - (b < a)
            if d == 0:
                continue
            if prev and d != prev:
                res += 1
            prev = d
        return res
```

I originally stored the directions as `"U"`, `"D"`, `"T"` in a list and scanned it again; same logic.

## Complexity

Time `O(n)`, space `O(n)` (the `nums[1:]` copy).

## Mistakes to Avoid

- Equal neighbors are not new hills or valleys; skip them.

## Interview Explanation

I look at the direction of each adjacent pair, skip equal ones, and remember the last non-flat direction; each change of direction adds one hill or valley. Time `O(n)`.
