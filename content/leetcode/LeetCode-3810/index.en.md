---
title: "LeetCode 3810: Minimum Operations to Reach Target Array"
summary: "LeetCode 3810 note: one operation fixes every position holding a value, so the answer is the number of distinct values at mismatched positions"
description: "LeetCode 3810 record from 2026-01-17"
date: 2026-01-17
tags: ["medium", "greedy", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-17
- Submissions: Accepted (first try)

## Approach

Choosing `x` changes every position whose value is `x` to `target`, whether or not they are contiguous.

- **Upper bound**: one operation for each value appearing at a mismatched position fixes every mismatch. Touching an already-correct position is harmless (it becomes `target` again).
- **Lower bound**: a mismatched position changes only when its **current value** is chosen. That value is `nums[i]` until the position changes, so every value at a mismatched position must be chosen at least once.

They match, so the answer is the count of distinct values ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 4).

## My Solution

```python
class Solution:
    def minOperations(self, nums: List[int], target: List[int]) -> int:
        return len({a for a, b in zip(nums, target) if a != b})
```

I originally wrote `len(diff) - (len(diff) - len(set(diff)))`, which simplifies to `len(set(diff))`.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The "contiguous segments" wording only describes which positions change; all segments of one value change together in one operation.

## Interview Explanation

Choosing a value rewrites every position holding it, so one operation per value at a mismatched position is enough. A mismatched position only changes when its current value is chosen, so each such value needs at least one operation. The answer is the number of distinct values at mismatched positions. Time `O(n)`.
