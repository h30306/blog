---
title: "LeetCode 1814: Count Nice Pairs in an Array"
summary: "LeetCode 1814 note: rearrange the condition into nums[i] - rev(nums[i]) == nums[j] - rev(nums[j]), count pairs per value, and remember the modulus"
description: "LeetCode 1814 record from 2024-04-17"
date: 2024-04-17
tags: ["medium", "array", "hash-table", "math", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-04-17
- Submissions: Wrong Answer → Accepted

## Approach

Rearranging `nums[i] + rev(nums[j]) == nums[j] + rev(nums[i])` gives `nums[i] - rev(nums[i]) == nums[j] - rev(nums[j])`: **each side depends on one index only**. Map every number to `x - rev(x)`; a value seen `c` times yields `c(c - 1) / 2` pairs ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1, the pair count of [Math]({{< relref "/algorithm/Math" >}}) Template 1). Return the answer modulo `10^9 + 7`.

## My Attempts

Attempt 1 had the right approach but **forgot the modulus**, failing on large answers; adding `% 1000000007` passed.

## Solution

```python
class Solution:
    def countNicePairs(self, nums: List[int]) -> int:
        cnt = Counter(x - int(str(x)[::-1]) for x in nums)
        return sum(c * (c - 1) // 2 for c in cnt.values()) % (10**9 + 7)
```

## Complexity

Time `O(n log M)`, space `O(n)`.

## Mistakes to Avoid

- The problem requires the modulus.
- Comparing all pairs is `O(n²)`; rearrange so each side involves one index.

## Interview Explanation

Rearranging the condition to nums[i] - rev(nums[i]) == nums[j] - rev(nums[j]) gives each number its own key; a key seen c times contributes c choose 2 pairs, and I take the modulus. Time `O(n log M)`.
