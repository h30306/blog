---
title: "LeetCode 2357: Make Array Zero by Subtracting Equal Amounts"
summary: "LeetCode 2357 note: each operation zeroes the group of the smallest positive value, so the answer is the number of distinct positive values"
description: "LeetCode 2357 record from 2022-11-21"
date: 2022-11-21
tags: ["easy", "array", "hash-table", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-21
- Submissions: Runtime Error → Accepted

## Approach

Each operation subtracts the smallest positive `x`: every value equal to `x` becomes 0 and the differences among larger values stay the same, so distinct values never merge. Each distinct positive value takes exactly one operation: `len(set(nums) - {0})` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})).

## My Attempts

Attempt 1 wrote `len(set(nums)) - {0}`, **misplacing the parenthesis** and subtracting a set from an integer (TypeError). `len(set(nums) - {0})` passed.

## Solution

```python
class Solution:
    def minimumOperations(self, nums: List[int]) -> int:
        return len(set(nums) - {0})
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Zeros need no operation; remove 0 from the set.
- Parenthesize the whole set expression: `len(set(nums) - {0})`.

## Interview Explanation

Subtracting the smallest positive value zeroes its group while preserving the gaps among the rest, so each distinct positive value takes one operation and the answer is their count. Time `O(n)`.
