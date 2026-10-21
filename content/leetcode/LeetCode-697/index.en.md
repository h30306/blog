---
title: "LeetCode 697: Degree of an Array"
summary: "LeetCode 697 note: record each value's count, first index and last index; among the most frequent values, take the shortest span"
description: "LeetCode 697 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Wrong Answer ×3 → Runtime Error ×2 → Accepted ×5

## Approach

A subarray with the full array's degree must contain **every** occurrence of some most frequent value, so the shortest is `last[x] - first[x] + 1`. Several values may tie for the highest count, so take the minimum over all of them ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). One pass records counts and first and last indices.

## My Attempts

This took 10 submissions:

- The first three took **one** most frequent value with `most_common()[0]`, never comparing others with the same count, and computed the length with negative indices, off by one: `[2]` returned -1 and 0.
- After recording all positions per value there were more slips, `d.values` without parentheses and comparing a list against a length; comparing the lengths of the position lists passed.

## Solution

```python
class Solution:
    def findShortestSubArray(self, nums: List[int]) -> int:
        cnt, first, last = Counter(), {}, {}
        for i, x in enumerate(nums):
            cnt[x] += 1
            first.setdefault(x, i)
            last[x] = i
        degree = max(cnt.values())
        return min(last[x] - first[x] + 1 for x in cnt if cnt[x] == degree)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Several values may share the highest count; compare all of them.
- The length is `last - first + 1`.

## Interview Explanation

The subarray must cover every occurrence of some most frequent value, so one pass records counts and first and last positions, and I take the shortest span among the most frequent values. Time `O(n)`.
