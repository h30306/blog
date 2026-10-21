---
title: "LeetCode 189: Rotate Array"
summary: "LeetCode 189 note: take k %= n, then reverse three times: the whole array, the first k, and the last n - k, with O(1) extra space"
description: "LeetCode 189 record from 2022-11-11"
date: 2022-11-11
tags: ["medium", "array", "math", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-11
- Submissions: Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## Approach

Rotating right by `k` moves the last `k` elements to the front. `k` may exceed the length, so take `k %= n` first. Without extra space, reverse three times ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1):

1. Reverse everything: the last `k` come first, reversed.
2. Reverse the first `k` back.
3. Reverse the last `n - k` back.

## My Attempts

The early slicing versions did not reduce `k`: when `k` exceeded the length the slices were wrong, so `[7, 8]` with `k = 7` stayed `[7, 8]` instead of `[8, 7]`; one computed `n % k`, dividing by zero when `k = 0`.

## Solution

```python
class Solution:
    def rotate(self, nums: List[int], k: int) -> None:
        def rev(l, r):
            while l < r:
                nums[l], nums[r] = nums[r], nums[l]
                l, r = l + 1, r - 1
        n = len(nums)
        k %= n
        rev(0, n - 1)
        rev(0, k - 1)
        rev(k, n - 1)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Reduce `k` modulo the length first.
- With slices, `nums[-k:]` is the whole array when `k = 0`.

## Interview Explanation

I reduce `k` modulo the length, then reverse the whole array, the first `k`, and the rest, which rotates it right. Time `O(n)`, extra space `O(1)`.
