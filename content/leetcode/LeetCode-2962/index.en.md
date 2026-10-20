---
title: "LeetCode 2962: Count Subarrays Where Max Element Appears at Least K Times"
summary: "LeetCode 2962 note: an \"at least k\" counting window: keep shrinking while the max appears k times, after which every left end in [0, left) is valid, so count += left"
description: "LeetCode 2962 record from 2026-01-19"
date: 2026-01-19
tags: ["medium", "sliding-window", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-19
- Submissions: Accepted (first try)

## Approach

`mx` is the maximum of the whole array and never changes. More copies of `mx` in the window only help, so "at least `k` times" is monotonic: a valid window stays valid when extended left.

The "at least K" counting pattern:

- Add on the right; while `mx` appears `k` times, **keep shrinking the left** until it just drops below `k`.
- Then any left end in `[0, left)` gives a subarray with at least `k` copies of `mx`, so `count += left`.

## My Solution

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        mx = max(nums)
        left = seen = count = 0
        for x in nums:
            seen += x == mx
            while seen >= k:                       # shrink while valid, until just invalid
                seen -= nums[left] == mx
                left += 1
            count += left                          # left ends in [0, left) are valid
        return count
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Using `right - left + 1`: that is the "at most" count; this one is "at least".
- The maximum is that of the **whole array**, not the window.

## Interview Explanation

The maximum is fixed as the whole array's maximum, and appearing at least `k` times is monotonic. I slide a window and, while the max appears `k` times, keep shrinking the left until it is just short; then every left end from 0 to `left - 1` works, so I add `left`. Time `O(n)`.
