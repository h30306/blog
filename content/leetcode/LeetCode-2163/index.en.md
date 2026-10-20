---
title: "LeetCode 2163: Minimum Difference in Sums After Removal of Elements"
summary: "LeetCode 2163 note: try every boundary k between the two parts; the left takes the n smallest of nums[:k] (a max-heap) and the right the n largest of nums[k:] (a min-heap), one prefix and one suffix pass"
description: "LeetCode 2163 record from 2026-09-05"
date: 2026-09-05
tags: ["hard", "dynamic-programming", "heap", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-05
- Submissions: Accepted (first try)

## Approach

After removing `n` elements, the first `n` remaining form part one and the last `n` part two. Equivalently, **choose a boundary `k`** (`n <= k <= 2n`): part one takes `n` elements from `nums[:k]` and part two `n` from `nums[k:]`.

To minimize `sum_first - sum_second`:

- Part one takes **the `n` smallest** of `nums[:k]`: scan left to right with a max-heap of the current smallest `n`, dropping the largest when there are too many. `left_min[k - 1]` = the sum of the smallest `n` among the first `k`.
- Part two takes **the `n` largest** of `nums[k:]`: scan right to left with a min-heap, dropping the smallest. `right_max[k]` = the sum of the largest `n` from `k` on.

The answer is `min(left_min[k - 1] - right_max[k])`.

## My Solution

```python
import heapq

class Solution:
    def minimumDifference(self, nums: List[int]) -> int:
        n = len(nums) // 3

        left_min = [0] * (3 * n)                   # left_min[i]: sum of the n smallest in nums[:i+1]
        heap, total = [], 0                        # max-heap (negated values)
        for i in range(2 * n):
            heapq.heappush(heap, -nums[i])
            total += nums[i]
            if len(heap) > n:
                total += heapq.heappop(heap)       # drop the largest (stored negated)
            left_min[i] = total

        right_max = [0] * (3 * n)                  # right_max[i]: sum of the n largest in nums[i:]
        heap, total = [], 0                        # min-heap
        for i in range(3 * n - 1, n - 1, -1):
            heapq.heappush(heap, nums[i])
            total += nums[i]
            if len(heap) > n:
                total -= heapq.heappop(heap)       # drop the smallest
            right_max[i] = total

        return min(left_min[k - 1] - right_max[k] for k in range(n, 2 * n + 1))
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- The boundary runs from `n` to `2n`: both sides need at least `n` elements to choose from.
- Python only has a min-heap; a max-heap stores negated values, and popped values are negated too.

## Interview Explanation

Removing `n` elements amounts to choosing a boundary, with part one taking `n` from the left and part two `n` from the right. To minimize the difference, the left takes its `n` smallest and the right its `n` largest. A left-to-right max-heap gives each prefix's smallest-`n` sum, a right-to-left min-heap each suffix's largest-`n` sum, and I try every boundary. Time `O(n log n)`.
