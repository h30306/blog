---
title: "LeetCode 561: Array Partition"
summary: "LeetCode 561 note: sort and pair neighbors; each pair's minimum is the element at an even index, so sum those"
description: "LeetCode 561 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "array", "greedy", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Accepted ×3 → Internal Error → Accepted ×3

## Approach

Each pair contributes its smaller value, so large values should pair with other large values to avoid waste ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1). After sorting, pair neighbors; the answer is the sum of `sorted(nums)[::2]`. The value range is small (`-10^4..10^4`), so counting sort also works.

## My Attempts

It passed on the first try; resubmitting the same code later hit a LeetCode Internal Error.

## Solution

```python
class Solution:
    def arrayPairSum(self, nums: List[int]) -> int:
        return sum(sorted(nums)[::2])
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Take the elements at **even indices** after sorting.

## Interview Explanation

Each pair contributes its smaller value, so large values should pair together; after sorting I pair neighbors and sum the first of each pair, the even-index elements. Time `O(n log n)`.
