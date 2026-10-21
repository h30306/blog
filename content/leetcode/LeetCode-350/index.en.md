---
title: "LeetCode 350: Intersection of Two Arrays II"
summary: "LeetCode 350 note: an intersection keeping multiplicity, where Counter's & takes the smaller count from each side"
description: "LeetCode 350 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "array", "hash-table", "two-pointers", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted ×4

## Approach

Each value appears as many times as its smaller count. `Counter`'s `&` takes the smaller count per key ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). With sorted arrays, two pointers also work.

## My Solution

```python
class Solution:
    def intersect(self, nums1: List[int], nums2: List[int]) -> List[int]:
        return list((Counter(nums1) & Counter(nums2)).elements())
```

## Complexity

Time `O(m + n)`, space `O(min(m, n))`.

## Mistakes to Avoid

- Unlike LC 349, duplicates are kept here.

## Interview Explanation

Each value's count is the smaller of its two counts, so I intersect `Counter`s and expand the result. Time `O(m + n)`.
