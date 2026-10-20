---
title: "LeetCode 1838: Frequency of the Most Frequent Element"
summary: "LeetCode 1838 note: after sorting, raising the whole window to nums[right] costs nums[right] × length − window sum; shrink the left while that exceeds k"
description: "LeetCode 1838 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "sorting", "greedy", "prefix-sum", "binary-search", "array"]
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
- Submissions: Accepted (first try)

## Approach

Values can only increase, so the target is always some existing value `nums[right]`, and the numbers raised to it should be **the ones just below it** (fewest increments).

After sorting, raising the window `[left, right]` to `nums[right]` costs:

```text
cost = nums[right] × (right - left + 1) − sum(nums[left..right])
```

For fixed `right`, a larger window costs more; for fixed `left`, moving `right` right only costs more. The condition is monotonic: use the "longest" sliding window.

## My Solution

```python
class Solution:
    def maxFrequency(self, nums: List[int], k: int) -> int:
        nums.sort()
        left = total = best = 0
        for right, x in enumerate(nums):
            total += x
            while x * (right - left + 1) - total > k:
                total -= nums[left]
                left += 1
            best = max(best, right - left + 1)
        return best
```

My first accepted version tracked a "current target" and a running cost, topping up the difference when the target grew, which was convoluted. Computing "target × length − sum" directly is clearer.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- The target is not arbitrary: it is the window's rightmost (largest) value.
- Costs get large; fine in Python, but other languages need 64-bit integers.

## Interview Explanation

Only increments are allowed, so the target is an existing value, raised to from the closest smaller values. I sort and slide a window with the right end as the target; the cost is the right end times the length minus the sum, and I shrink the left when it exceeds `k`, tracking the longest length. Time `O(n log n)`.
