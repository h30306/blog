---
title: "LeetCode 349: Intersection of Two Arrays"
summary: "LeetCode 349 note: convert both arrays to sets and intersect them"
description: "LeetCode 349 record from 2022-08-23"
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
- Submissions: Accepted (first try)

## Approach

Each value appears once in the result, so a set intersection does it ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Sorting one array and binary searching each value of the other also works.

## My Solution

```python
class Solution:
    def intersection(self, nums1: List[int], nums2: List[int]) -> List[int]:
        return list(set(nums1) & set(nums2))
```

## Complexity

Time `O(m + n)`, space `O(m + n)`.

## Mistakes to Avoid

- No duplicates in the result; keeping multiplicity is LC 350.

## Interview Explanation

I intersect the two arrays as sets, which naturally removes duplicates. Time `O(m + n)`.
