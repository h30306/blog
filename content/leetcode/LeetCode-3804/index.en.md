---
title: "LeetCode 3804: Number of Centered Subarrays"
summary: "LeetCode 3804 note: fix the left end and extend right, adding to the sum and to a set; count the subarray when the sum is in the set"
description: "LeetCode 3804 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "hash-table", "enumeration", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Accepted (first try, 2.8 s)

## Approach

With `n <= 500` there are `O(n²)` subarrays. Fix the left end `i` and extend the right end `j`:

- Add to the sum as it extends.
- Keep the subarray's values in a set, also extended incrementally, for `O(1)` lookups.

## My Solution

I originally checked `curr_sum in nums[i: j + 1]`, slicing and scanning every time, `O(n³)` overall, 2.8 s. With an incremental set:

```python
class Solution:
    def centeredSubarrays(self, nums: List[int]) -> int:
        n, res = len(nums), 0
        for i in range(n):
            seen, total = set(), 0
            for j in range(i, n):
                total += nums[j]
                seen.add(nums[j])
                res += total in seen
        return res
```

## Complexity

Time `O(n²)`, space `O(n)`.

## Mistakes to Avoid

- Do not slice and search each time; that adds an `O(n)` factor.

## Interview Explanation

I fix the left end and extend right, keeping the running sum and a set of values seen; whenever the sum is in the set, the subarray counts. Each extension is `O(1)`, so `O(n²)` total.
