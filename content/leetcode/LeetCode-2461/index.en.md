---
title: "LeetCode 2461: Maximum Sum of Distinct Subarrays With Length K"
summary: "LeetCode 2461 note: in a fixed window of length k, all values are distinct exactly when the number of distinct values equals k"
description: "LeetCode 2461 record from 2025-12-24"
date: 2025-12-24
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
First Attempt: 2025-12-24
- Submissions: Accepted ×2

## Approach

The same template as [LeetCode 2841]({{< relref "/leetcode/LeetCode-2841" >}}): a fixed window of length `k` with a sum and a count map. **A distinct count equal to `k`** means no duplicates in the window.

Another way, which both of my accepted versions used, is a variable window: shrink the left on a duplicate or when the window exceeds `k`, and update the answer when the length is exactly `k`.

## My Solution

```python
class Solution:
    def maximumSubarraySum(self, nums: List[int], k: int) -> int:
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
                    del cnt[out]
            if right >= k - 1 and len(cnt) == k:   # all k values distinct
                best = max(best, window)
        return best
```

My second accepted version used a `set` with a variable window (lightly reordered here):

```python
class Solution:
    def maximumSubarraySum(self, nums: List[int], k: int) -> int:
        seen = set()
        left = window = best = 0
        for right, x in enumerate(nums):
            while x in seen or right - left >= k:
                seen.remove(nums[left])
                window -= nums[left]
                left += 1
            seen.add(x)
            window += x
            if right - left + 1 == k:
                best = max(best, window)
        return best
```

## Complexity

Time `O(n)`, space `O(k)`.

## Mistakes to Avoid

- Using `len(cnt) >= k` with a fixed window: a length-`k` window has at most `k` distinct values, so it must equal `k`.
- With the variable window, finish shrinking before adding the new element to the `set`.

## Interview Explanation

This is a fixed sliding window of length `k` with a sum and a count map, deleting keys at zero. The map's size equals `k` exactly when everything in the window is distinct, and then I update the best sum. A `set` with a variable window also works: shrink the left on a duplicate or past length `k`. Time `O(n)`.
