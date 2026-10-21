---
title: "LeetCode 167: Two Sum II - Input Array Is Sorted"
summary: "LeetCode 167 note: sorted, so move two pointers inward, shifting right when the sum is too large and left when too small; indices are 1-based"
description: "LeetCode 167 record from 2022-10-27"
date: 2022-10-27
tags: ["medium", "array", "two-pointers", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-27
- Submissions: Runtime Error ×2 → Wrong Answer → Runtime Error ×2 → Wrong Answer ×5 → Accepted → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted

## Approach

The array is sorted ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): the left pointer at the smallest value and the right at the largest. If the sum is too large move the right pointer left (a smaller value), if too small move the left pointer right. Each step rules out one value, `O(n)`. Indices are 1-based.

## My Attempts

This took 18 submissions in 2022:

- At first both pointers started on the left and moved together when the sum was too large, never finding the answer or running out of range, e.g. `[2, 3, 5]`, `target = 8`.
- After starting from both ends, one version wrote `l -= 1` when the sum was too small, the wrong direction: `[1, 4]`, `target = 5` was not found. A 2026 rewrite forgot that indices are 1-based and returned `[0, 1]`.

## Solution

```python
class Solution:
    def twoSum(self, numbers: List[int], target: int) -> List[int]:
        l, r = 0, len(numbers) - 1
        while l < r:
            s = numbers[l] + numbers[r]
            if s == target:
                return [l + 1, r + 1]
            if s > target:
                r -= 1
            else:
                l += 1
```

## Complexity

Time `O(n)`, space `O(1)`. Binary searching the complement of each value is `O(n log n)`.

## Mistakes to Avoid

- When the sum is too small, the left pointer moves **right** (`l += 1`), not left.
- Add 1 to the returned indices.

## Interview Explanation

With a sorted array I start at both ends, moving the right pointer left when the sum is too large and the left pointer right when too small, returning the 1-based indices on a match. Time `O(n)`, space `O(1)`.
