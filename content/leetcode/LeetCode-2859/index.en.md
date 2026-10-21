---
title: "LeetCode 2859: Sum of Values at Indices With K Set Bits"
summary: "LeetCode 2859 note: count the set bits of the index, not of the value"
description: "LeetCode 2859 record from 2023-09-17"
date: 2023-09-17
tags: ["easy", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2023-09-17
- Submissions: Accepted (first try)

## Approach

For each index `i`, count the 1s in `bin(i)` ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})) and add `nums[i]` when there are exactly `k`.

## My Solution

```python
class Solution:
    def sumIndicesWithKSetBits(self, nums: List[int], k: int) -> int:
        return sum(x for i, x in enumerate(nums) if bin(i).count("1") == k)
```

## Complexity

Time `O(n log n)`, space `O(1)`.

## Mistakes to Avoid

- Test the index, not `nums[i]`.

## Interview Explanation

For each index I count its set bits and add the value when the count is k. Time `O(n log n)`.
