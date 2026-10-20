---
title: "LeetCode 2875: Minimum Size Subarray in Infinite Array"
summary: "LeetCode 2875 note: strip target // sum full cycles; the remainder is smaller than one cycle, so a sliding window over two copies of nums always finds it"
description: "LeetCode 2875 record from 2026-01-18"
date: 2026-01-18
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-18
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Let `total = sum(nums)` and `full, rest = divmod(target, total)`.

- A subarray of length at least `n` contains a whole cycle (sum `total`); removing it still leaves a contiguous subarray of the infinite array. So the answer = `full × n` + **the shortest subarray summing to exactly `rest`**.
- `rest < total` with positive numbers, so that subarray is shorter than `n` and **spans at most two copies of `nums`**; a sliding window over `nums + nums` is enough.
- When `rest == 0`, the answer is `full × n`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Replaced `target` with `target % sum` and forgot to add the full cycles back. For `nums = [1]`, `target = 6`, the answer is 6; it returned 0 |
| Attempt 2 | Added `n * divisor` back, but computed `sum` **after** doubling `nums`, so the total was twice too large. For `nums = [1, 4, 2]`, `target = 24`, the answer is 11; it returned -1 |
| AC | Computed the original sum and cycle count first, then doubled `nums` |

## Solution

```python
class Solution:
    def minSizeSubarray(self, nums: List[int], target: int) -> int:
        n = len(nums)
        full, rest = divmod(target, sum(nums))     # use the original sum
        if rest == 0:
            return full * n

        arr = nums + nums                          # the remainder spans at most two copies
        left = window = 0
        best = float("inf")
        for right, x in enumerate(arr):
            window += x
            while window > rest:
                window -= arr[left]
                left += 1
            if window == rest:
                best = min(best, right - left + 1)
        return -1 if best == float("inf") else full * n + best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Handling only the remainder and forgetting the full cycles.
- Doubling the array before summing: the total doubles too.

## Interview Explanation

A long subarray must contain full cycles, so I divide `target` by the sum to strip them, each worth `n` elements. The remainder is less than one cycle and all numbers are positive, so it fits within two copies of `nums`, where a sliding window finds the shortest stretch summing exactly to the remainder. Time `O(n)`.
