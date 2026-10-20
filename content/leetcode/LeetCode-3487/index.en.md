---
title: "LeetCode 3487: Maximum Unique Subarray Sum After Deletion"
summary: "LeetCode 3487 note: free deletion means picking distinct values; take every non-negative one, or only the maximum when all are negative"
description: "LeetCode 3487 record from 2025-03-16"
date: 2025-03-16
tags: ["easy", "greedy", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-03-16
- Submissions: Wrong Answer ×2 → Accepted (2025-07-25)

## Approach

Any elements may be deleted (just not all), so any set of elements with distinct values can be left behind as a subarray. The problem becomes: **pick distinct values with the largest sum**.

- Take one of every non-negative value (0 does not change the sum).
- If everything is negative, something must remain, so keep the largest.

This is the "sort then scan" form from [Greedy]({{< relref "/algorithm/Greedy" >}}), without even needing the sort.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Collected only positives; **with all negatives the set was empty and it returned 0**. For `[-3]` the answer is -3 |
| Attempt 2 | Special-cased length 1, but `[-5, -1]` still returned 0 instead of -1 |
| AC | When the set is empty, return the largest negative |

## Solution

```python
class Solution:
    def maxSum(self, nums: List[int]) -> int:
        keep = set(x for x in nums if x >= 0)
        return sum(keep) if keep else max(nums)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The result cannot be empty: with all negatives, return the maximum, not 0.
- Special-casing length 1 is not enough; the real check is whether any non-negative value exists.

## Interview Explanation

Since deletion is free, any set of distinct values can become the subarray, so I add each non-negative value once. If there are none, one element must remain, so I return the largest negative. Time `O(n)`.
