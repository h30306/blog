---
title: "LeetCode 2972: Count the Number of Incremovable Subarrays II"
summary: "LeetCode 2972 note: what remains is a strictly increasing prefix plus suffix; for each valid prefix end, a right-only pointer finds the first suffix start that can follow it, and every later start works too"
description: "LeetCode 2972 record from 2026-01-26"
date: 2026-01-26
tags: ["hard", "two-pointers", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-26
- Submissions: Accepted ×2

## Approach

The same structure as [LeetCode 1574]({{< relref "/leetcode/LeetCode-1574" >}}), except here we **count the ways to remove**, and the result must be strictly increasing.

After removing `nums[l..r]`, the prefix `nums[0..l-1]` and suffix `nums[r+1..]` must both be strictly increasing, and `nums[l-1] < nums[r+1]` (no comparison if either side is empty).

1. Find the longest strictly increasing suffix from the right, starting at `right`. If it is the whole array, any non-empty subarray can be removed: `n(n + 1) / 2`.
2. **Empty prefix**: the suffix can start at `right, right + 1, ..., n` (`n` means the suffix is empty too): `n - right + 1` ways.
3. **Prefix up to `left`** (`nums[0..left]` strictly increasing): the suffix start must be `> left` with `nums[start] > nums[left]`. Move `right` to the first `nums[right] > nums[left]`; every start from there works: `n - right + 1` ways.

As `left` grows, `nums[left]` grows, so valid suffix starts only move right and `right` never moves back.

## My Solution

```python
class Solution:
    def incremovableSubarrayCount(self, nums: List[int]) -> int:
        n = len(nums)
        right = n - 1
        while right > 0 and nums[right - 1] < nums[right]:
            right -= 1
        if right == 0:
            return n * (n + 1) // 2                # the whole array is strictly increasing

        ans = n - right + 1                        # empty prefix
        for left in range(n):
            if left > 0 and nums[left - 1] >= nums[left]:
                break                              # prefix no longer strictly increasing
            while right < n and nums[right] <= nums[left]:
                right += 1
            ans += n - right + 1                   # suffix may start anywhere in right..n
        return ans
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Forgetting the empty-prefix and empty-suffix cases (the `+1` in `n - right + 1` is the empty suffix).
- This one is **strictly** increasing, so compare with `<`, unlike `<=` in 1574.
- Handle an already increasing array separately, or `right` and `left` overlap.

## Interview Explanation

After removing one block, a prefix and a suffix remain; both must be strictly increasing and so must the join. I find the longest strictly increasing suffix; with an empty prefix there are `n - right + 1` suffix starts. Then I extend the prefix to each `left` and move the suffix pointer right to the first value greater than `nums[left]`; every start from there works, again `n - right + 1` ways. Neither pointer moves back, so time is `O(n)`.
