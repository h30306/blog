---
title: "LeetCode 410: Split Array Largest Sum"
summary: "LeetCode 410 note: binary search the answer; for a cap mid, greedily fill each segment to count the fewest segments, and mid works if that count is <= k"
description: "LeetCode 410 record from 2026-08-26"
date: 2026-08-26
tags: ["hard", "dynamic-programming", "binary-search", "greedy", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-26
- Submissions: Accepted (first try)

## Approach

Partition DP into `k` segments works (`O(k · n^2)`), but there is a faster way: **binary search on the answer**.

The answer (the largest segment sum) is monotonic: a larger cap `mid` makes it easier to stay within `k` segments. For a given `mid`:

- **Greedy**: going left to right, add to the current segment while it fits, otherwise start a new one. This gives the fewest segments.
- Segments `<= k`: `mid` works, so search lower. Otherwise search higher.

The range runs from `max(nums)` (every segment must hold the largest value) to `sum(nums)` (one segment).

Fewer than `k` segments is fine: some can be split further without raising the maximum (all values are non-negative).

## My Solution

```python
class Solution:
    def splitArray(self, nums: List[int], k: int) -> int:
        def pieces(limit: int) -> int:             # fewest segments with sums <= limit
            count, cur = 1, 0
            for x in nums:
                if cur + x > limit:
                    count += 1
                    cur = 0
                cur += x
            return count

        lo, hi = max(nums), sum(nums)
        while lo < hi:
            mid = (lo + hi) // 2
            if pieces(mid) <= k:
                hi = mid                           # works, try smaller
            else:
                lo = mid + 1
        return lo
```

## Complexity

Time `O(n log(sum))`, space `O(1)`.

## Mistakes to Avoid

- A lower bound of 0 or 1: with a cap below the largest value, that value fits nowhere and the greedy count is wrong.
- When feasible use `hi = mid`, not `mid - 1`: `mid` itself may be the answer.

## Interview Explanation

The largest segment sum is monotonic: a higher cap makes it easier to use at most `k` segments, so I binary-search the answer. For a cap, I fill segments left to right and start a new one when the next value does not fit, giving the fewest segments; if that is at most `k`, I search lower. The range is from the largest value to the total. Time `O(n log(sum))`. A `k`-segment DP works too, but more slowly.
