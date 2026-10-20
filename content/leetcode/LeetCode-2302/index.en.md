---
title: "LeetCode 2302: Count Subarrays With Score Less Than K"
summary: "LeetCode 2302 note: score = sum × length with positive numbers grows with the window; shrink while the score is >= k, and right - left + 1 valid subarrays end at right"
description: "LeetCode 2302 record from 2026-01-18"
date: 2026-01-18
tags: ["hard", "sliding-window", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-18
- Submissions: Accepted (first try)

## Approach

`score = sum × length`, and every number is positive, so a larger window has a larger sum and length: **the score increases monotonically**.

Use the counting sliding window:

- Add on the right; shrink the left while the score is `>= k`.
- There are `right - left + 1` valid subarrays ending at `right`.

## My Solution

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        left = total = count = 0
        for right, x in enumerate(nums):
            total += x
            while total * (right - left + 1) >= k:
                total -= nums[left]
                left += 1
            count += right - left + 1
        return count
```

`left` may pass `right` (a single element already scores `>= k`); then `right - left + 1` is 0, the window is empty, and the next round starts again from `left`.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The problem says strictly less than `k`, so shrink while `>= k`.
- Brute-force enumeration: `n` reaches `10^5`.

## Interview Explanation

The score is sum times length with positive numbers, so it grows with the window. I slide a window that shrinks while the score is at least `k`, and add the `right - left + 1` valid subarrays ending at each right end. Time `O(n)`.
