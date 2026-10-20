---
title: "LeetCode 1498: Number of Subsequences That Satisfy the Given Sum Condition"
summary: "LeetCode 1498 note: only the minimum and maximum matter, so order does not and we can sort; fixing nums[left] as the minimum, the elements between are free, giving 2^(right - left) choices"
description: "LeetCode 1498 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Accepted ×2 → Wrong Answer → Accepted ×2

## Approach

Whether a subsequence is valid depends only on **minimum + maximum**, not on the original order, so sort first.

Then use converging pointers:

- `nums[left] + nums[right] > target`: `nums[right]` does not work even with the current smallest value, let alone larger ones, so drop it: `right -= 1`.
- Otherwise, take `nums[left]` as the minimum. It must be chosen, and each of the `right - left` elements in `left + 1..right` is optional, with the maximum staying `<= nums[right]`: `2^(right - left)` subsequences. Then `left += 1`.

Powers of two need the modulo: use `pow(2, e, MOD)` or precompute a table.

## My Attempts

After the first pass I rewrote it a few times. One rewrite got WA: I switched to `while ... else` and the inner `while` had no `left <= right` guard, so `right` could drop below `left`. Then `right - left` is negative, and Python's `pow(2, -1, MOD)` **does not raise**; it returns the modular inverse of 2, `500000004`, which gets added to the answer.

For `nums = [3, 5, 6, 7]`, `target = 9`, the answer is 4; this version returned `500000008`.

Adding `left <= right` to the inner loop passed.

## Solution

```python
class Solution:
    def numSubseq(self, nums: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        nums.sort()
        left, right = 0, len(nums) - 1
        ans = 0
        while left <= right:
            if nums[left] + nums[right] > target:
                right -= 1                         # no minimum works with nums[right]
            else:
                ans = (ans + pow(2, right - left, MOD)) % MOD
                left += 1                          # all subsequences with minimum nums[left] counted
        return ans
```

## Complexity

Time `O(n log n)` (each `pow` is `O(log n)`; a precomputed table makes it `O(1)`), space `O(1)` apart from sorting.

## Mistakes to Avoid

- Assuming subsequences forbid sorting: only the minimum and maximum matter here.
- Letting `right` pass `left`: Python's `pow` with a negative exponent and a modulus does not raise, it silently gives a wrong value.
- It is `2^(right - left)`, not `2^(right - left + 1)`: the minimum `nums[left]` must be chosen.

## Interview Explanation

Validity depends only on minimum plus maximum, so I sort. With converging pointers, if the two ends sum too high, I drop the right end; otherwise the left end is the minimum, it must be chosen, and the `right - left` elements between are free, giving `2^(right - left)` subsequences, then the left end advances. Time `O(n log n)`.
