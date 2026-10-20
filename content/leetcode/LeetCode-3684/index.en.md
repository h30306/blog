---
title: "LeetCode 3684: Maximize Sum of At Most K Distinct Elements"
summary: "LeetCode 3684 note: all values are positive, so deduplicate and take the k largest in descending order"
description: "LeetCode 3684 record from 2026-01-29"
date: 2026-01-29
tags: ["easy", "greedy", "sorting", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-29
- Submissions: Wrong Answer → Accepted

## Approach

Every value is positive, so taking more is better; take up to `k`. They must be distinct, so deduplicate and take the `k` largest. With fewer than `k` distinct values, take them all.

## My Attempts

Attempt 1 hard-coded "the top 3" from the examples with `biggest, second, third`, **never using `k`**. For `nums = [5, 3]`, `k = 1` the answer is `[5]`; it returned `[5, 3]`.

Sorting descending, skipping duplicates, and stopping at `k` passed.

## Solution

```python
class Solution:
    def maxKDistinct(self, nums: List[int], k: int) -> List[int]:
        return sorted(set(nums), reverse=True)[:k]
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Do not hard-code the `k` from the examples; use the parameter.

## Interview Explanation

All values are positive, so more is better. I deduplicate, sort descending, and take the first `k`. Time `O(n log n)`.
