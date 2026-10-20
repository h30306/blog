---
title: "LeetCode 2968: Apply Operations to Maximize Frequency Score"
summary: "LeetCode 2968 note: after sorting, the cheapest common target for a block is its median; prefix sums give the cost in O(1), and it grows with the window, so slide"
description: "LeetCode 2968 record from 2026-01-18"
date: 2026-01-18
tags: ["hard", "sliding-window", "sorting", "prefix-sum", "binary-search", "array"]
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

Much like [LeetCode 1838]({{< relref "/leetcode/LeetCode-1838" >}}), except values can move both up and down.

1. The numbers made equal always form **a contiguous block** after sorting.
2. Making a block equal costs `Σ |x - target|`, and **the cheapest `target` is the median**.
3. With prefix sums the cost is `O(1)`, using `mid = (left + right) // 2`:

```text
left half:  nums[mid] × (mid - left + 1) − sum(nums[left..mid])
right half: sum(nums[mid+1..right]) − nums[mid] × (right - mid)
```

The cost never decreases as the window grows, so use the "longest" sliding window: shrink the left while the cost is `> k`.

## My Solution

```python
class Solution:
    def maxFrequencyScore(self, nums: List[int], k: int) -> int:
        nums.sort()
        prefix = [0]
        for x in nums:
            prefix.append(prefix[-1] + x)

        def cost(lo: int, hi: int) -> int:         # make nums[lo..hi] equal to the median
            mid = (lo + hi) // 2
            target = nums[mid]
            left_cost = target * (mid - lo + 1) - (prefix[mid + 1] - prefix[lo])
            right_cost = (prefix[hi + 1] - prefix[mid + 1]) - target * (hi - mid)
            return left_cost + right_cost

        left = best = 0
        for right in range(len(nums)):
            while cost(left, right) > k:
                left += 1
            best = max(best, right - left + 1)
        return best
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Targeting the mean: the sum of absolute differences is minimized at the median, not the mean.
- Re-summing the window each time: use prefix sums.

## Interview Explanation

The numbers made equal form a contiguous block after sorting, and the target minimizing the sum of absolute differences is the median. Prefix sums give the cost of moving a block to its median in `O(1)`; that cost grows with the window, so I slide and shrink the left when it exceeds `k`. Sorting dominates: `O(n log n)`.
