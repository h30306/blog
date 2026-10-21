---
title: "LeetCode 2099: Find Subsequence of Length K With the Largest Sum"
summary: "LeetCode 2099 note: pick the k largest values along with their indices, then sort by index to restore the original order"
description: "LeetCode 2099 record from 2022-11-22"
date: 2022-11-22
tags: ["easy", "array", "hash-table", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-22
- Submissions: Accepted → Runtime Error → Accepted

## Approach

A subsequence keeps the original order, while the largest sum comes from the `k` largest values. Take the top `k` of `(value, index)` by value (sorting or a size-`k` heap, [Heap]({{< relref "/algorithm/Heap" >}}) Template 1), then output them sorted by index.

## My Attempts

In 2022 it passed at once by popping the `n - k` smallest from a heap and sorting by index. A 2025 rewrite wrote `sort(lambda x: -x[1])`; **the key must be passed by keyword** (TypeError), and adding `key=` passed.

## Solution

```python
class Solution:
    def maxSubsequence(self, nums: List[int], k: int) -> List[int]:
        top = heapq.nlargest(k, range(len(nums)), key=lambda i: nums[i])
        return [nums[i] for i in sorted(top)]
```

## Complexity

Time `O(n log k)`, space `O(k)`.

## Mistakes to Avoid

- Restore the original order by sorting the chosen indices.
- Pass the sort key as a keyword argument: `sort(key=...)`.

## Interview Explanation

The largest sum uses the k largest values, but order must be preserved, so I pick k indices by value with nlargest and output their values in index order. Time `O(n log k)`.
