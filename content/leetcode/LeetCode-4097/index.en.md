---
title: "LeetCode 4097: Minimum Value of Merged Integers"
summary: "LeetCode 4097 note: only merge the fixed pairs (0,1), (2,3), …, stepping by 2, not every adjacent pair"
description: "LeetCode 4097 record from 2026-11-02"
date: 2026-11-02
tags: ["easy", "array", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-11-02
- Submissions: Wrong Answer → Accepted

## Approach

The pairing is fixed by the problem: `nums[0]` with `nums[1]`, `nums[2]` with `nums[3]`, and so on. Concatenate each pair's decimal digits and take the minimum. Just do that: step `i` by 2 and compare `int(str(nums[i]) + str(nums[i + 1]))`.

Without strings: if `b` has `d` digits, the merge is `a * 10^d + b`.

## My Attempts

1. Stepped `i` by 1 and merged **every adjacent pair**, adding pairs the problem does not have: `[70,41,91,11]` returned 4191 (41 merged with 91), the answer is 7041.
2. Stepping by 2 passed.

## Solution

```python
class Solution:
    def minMergedInteger(self, nums: List[int]) -> int:
        return min(int(str(nums[i]) + str(nums[i + 1])) for i in range(0, len(nums), 2))
```

## Complexity

Time `O(n)` (each number has at most 4 digits), space `O(1)`.

## Mistakes to Avoid

- Read carefully: the pairs are the fixed `(0,1)`, `(2,3)`, …, not every two neighbours.

## Interview Explanation

The pairs are fixed, so I walk the array with step 2, merge each pair into one integer, and take the minimum. Time `O(n)`.
