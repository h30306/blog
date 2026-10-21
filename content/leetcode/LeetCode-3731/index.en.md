---
title: "LeetCode 3731: Find Missing Elements"
summary: "LeetCode 3731 note: the minimum and maximum are still present, so check every integer in between against a set"
description: "LeetCode 3731 record from 2025-11-02"
date: 2025-11-02
tags: ["easy", "hash-table", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-11-02
- Submissions: Accepted (first try)

## Approach

The original range is `[min, max]`, and both ends are still in the array. Enumerate every integer in the range; those not in the array are missing, and enumerating in order keeps them sorted.

Use a set for lookups ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1).

## My Solution

I originally used `i not in nums`, an `O(n)` list lookup each time; the small range let it pass. With a set:

```python
class Solution:
    def findMissingElements(self, nums: List[int]) -> List[int]:
        seen = set(nums)
        return [x for x in range(min(nums), max(nums)) if x not in seen]
```

`max` is always present, so excluding it from the `range` is fine.

## Complexity

Time `O(n + R)` with `R = max - min`, space `O(n)`.

## Mistakes to Avoid

- `in` on a list is a linear search; switch to a set for larger ranges.

## Interview Explanation

The minimum and maximum are still present, so I convert the array to a set and enumerate every integer between them; the ones not in the set are missing. Time `O(n + R)`.
