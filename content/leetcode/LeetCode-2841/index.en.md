---
title: "LeetCode 2841: Maximum Sum of Almost Unique Subarray"
summary: "LeetCode 2841 note: a fixed window of length k keeps a sum and a count map; the number of distinct values is the map's size, so delete keys that drop to zero"
description: "LeetCode 2841 record from 2025-12-23"
date: 2025-12-23
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-12-23
- Submissions: Wrong Answer → Accepted

## Approach

A fixed window of length `k` maintains two things:

- The window sum.
- A count map `cnt`: value → occurrences in the window. Delete a key when its count drops to 0, so `len(cnt)` is the number of distinct values.

When the window is full and `len(cnt) >= m`, update the best sum.

## My Attempts

Attempt 1 checked "each value appears `<= k - m` times", which is not the same as "at least `m` distinct values", and only checked the value just added. For `nums = [2]`, `m = 1`, `k = 1`, `k - m = 0`, so `2` appearing once failed the check and it returned 0; the answer is 2.

Checking `len(freq) >= m` directly and deleting keys at zero passed.

## Solution

```python
class Solution:
    def maxSum(self, nums: List[int], m: int, k: int) -> int:
        cnt = Counter()
        window = best = 0
        for right, x in enumerate(nums):
            cnt[x] += 1
            window += x
            if right >= k:
                out = nums[right - k]
                cnt[out] -= 1
                window -= out
                if cnt[out] == 0:
                    del cnt[out]                   # keeps len(cnt) = distinct count
            if right >= k - 1 and len(cnt) >= m:
                best = max(best, window)
        return best
```

## Complexity

Time `O(n)`, space `O(k)`.

## Mistakes to Avoid

- Inferring the distinct count from occurrence counts: use the map's size.
- Not deleting keys at zero: `len()` over-counts.

## Interview Explanation

A fixed sliding window of length `k` keeps the sum and a count map. When an element leaves, its count drops and the key is deleted at zero, so the map's size is the number of distinct values. When the window is full with at least `m` distinct values, update the answer. Time `O(n)`.
