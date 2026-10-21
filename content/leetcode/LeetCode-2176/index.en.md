---
title: "LeetCode 2176: Count Equal and Divisible Pairs in an Array"
summary: "LeetCode 2176 note: n is only 100, so enumerate all pairs; the condition is equal values and the index product i * j divisible by k"
description: "LeetCode 2176 record from 2025-04-17"
date: 2025-04-17
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-17
- Submissions: Wrong Answer → Accepted

## Approach

With `n <= 100`, enumerate every pair `i < j` ([Array]({{< relref "/algorithm/Array" >}}) Template 4). Two conditions: `nums[i] == nums[j]`, and the **index** product `i * j` divisible by `k`.

## My Attempts

Attempt 1 wrote `(nums[i] * nums[j]) // 2`, **using values and integer division by 2 as the condition**. For `nums = [1, 1]`, `k = 4`, `0 × 1 = 0` is divisible by 4, so the answer is 1; it computed `1 × 1 // 2 = 0`, which is falsy, and returned 0. Changing to `not (i * j) % k` passed.

## Solution

```python
class Solution:
    def countPairs(self, nums: List[int], k: int) -> int:
        n = len(nums)
        return sum(nums[i] == nums[j] and i * j % k == 0
                   for i in range(n) for j in range(i + 1, n))
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- The product uses indices, not values.
- "Divisible by `k`" is `% k == 0`.

## Interview Explanation

With `n` small, I enumerate all pairs and check equal values and an index product divisible by `k`. Time `O(n²)`.
