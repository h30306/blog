---
title: "LeetCode 1051: Height Checker"
summary: "LeetCode 1051 note: sort and count the positions that differ from the original"
description: "LeetCode 1051 record from 2022-09-30"
date: 2022-09-30
tags: ["easy", "array", "sorting", "counting-sort", "bubble-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-30
- Submissions: Accepted (first try)

## Approach

The expected order is the sorted array, so count the positions where the two differ. Heights are `1..100`, so counting sort gives `O(n + 100)` ([Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})).

## My Solution

```python
class Solution:
    def heightChecker(self, heights: List[int]) -> int:
        return sum(a != b for a, b in zip(heights, sorted(heights)))
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Build a sorted copy with `sorted`; do not sort the original in place.

## Interview Explanation

The expected order is the sorted array, so I compare it position by position with the original and count differences, in `O(n log n)`, or linear with counting sort.
