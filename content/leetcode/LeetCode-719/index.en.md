---
title: "LeetCode 719: Find K-th Smallest Pair Distance"
summary: "LeetCode 719 note: binary search on the distance, counting pairs with distance <= mid using a sliding window"
description: "LeetCode 719 record from 2026-09-06"
date: 2026-09-06
tags: ["hard", "binary-search", "two-pointers", "sliding-window", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-06
- Submissions: Accepted → Accepted (renamed variables)

## Approach

There are `n(n-1)/2` pairs, about `5 * 10^7` at `n = 10^4`, too many to list and sort.

Instead, **binary search on the answer**:

- Distances lie in `[0, max - min]`.
- `count(d)` = the number of pairs with distance `<= d`; it grows with `d`, so it is monotonic.
- The first `d` with `count(d) >= k` is the k-th smallest distance.

Computing `count(d)`: sort, then slide a window. For each right end `right`, move the left end until `nums[right] - nums[left] <= d`; every index from `left` to `right - 1` pairs with `right` at distance `<= d`, which is `right - left` pairs.

## My Solution

```python
class Solution:
    def smallestDistancePair(self, nums: List[int], k: int) -> int:
        nums.sort()
        n = len(nums)

        def count_within(d: int) -> int:
            count = left = 0
            for right in range(n):
                while nums[right] - nums[left] > d:
                    left += 1
                count += right - left
            return count

        lo, hi = 0, nums[-1] - nums[0]
        while lo < hi:
            mid = (lo + hi) // 2
            if count_within(mid) < k:
                lo = mid + 1
            else:
                hi = mid
        return lo
```

### Why the answer is always a real distance

The search returns the first `d` with `count >= k`. If no pair had distance exactly `d`, then `count(d) == count(d - 1)`, so `d - 1` would also satisfy the condition, contradicting "first". So the answer is always some pair's distance.

## Complexity

Time `O(n log n + n log W)`, where `W` is the largest distance. Space `O(1)` excluding the sort.

## Mistakes to Avoid

- Listing every pair and sorting: `O(n^2 log n)`.
- Popping from a heap k times: `k` can reach `5 * 10^7`.
- Restarting `left` from the beginning for each `right` while counting: `left` must only move forward.

## Interview Explanation

There are too many pairs to list, so I binary search the distance: the number of pairs with distance at most `d` is monotonic in `d`, and the first `d` where it reaches `k` is the answer. To count, I sort and slide a window: for each right end, push the left end until the gap is at most `d`, and add `right - left`. Each count is `O(n)`, giving `O(n log n + n log W)` overall.
