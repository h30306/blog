---
title: "LeetCode 930: Binary Subarrays With Sum"
summary: "LeetCode 930 note: \"sum exactly goal\" = \"sum at most goal\" − \"sum at most goal - 1\"; or prefix sums with a hash map"
description: "LeetCode 930 record from 2026-01-20"
date: 2026-01-20
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-20
- Submissions: Accepted (first try)

## Approach

As in [LeetCode 1248]({{< relref "/leetcode/LeetCode-1248" >}}): the array contains 0s, so adding a 0 leaves the sum unchanged and "sum exactly `goal`" is not monotonic. Subtract two "at most" counts instead.

When `goal = 0`, `at_most(-1)` must return 0 (the window cannot shrink to a negative length).

## My Solution

```python
class Solution:
    def numSubarraysWithSum(self, nums: List[int], goal: int) -> int:
        def at_most(limit: int) -> int:
            if limit < 0:
                return 0
            left = total = count = 0
            for right, x in enumerate(nums):
                total += x
                while total > limit:
                    total -= nums[left]
                    left += 1
                count += right - left + 1
            return count

        return at_most(goal) - at_most(goal - 1)
```

The prefix-sum version sums `count[prefix - goal]`, exactly as in 1248.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- With `goal = 0`, special-case `at_most(-1)` to return 0.

## Interview Explanation

With 0s in the array, "exactly `goal`" is not monotonic, so I compute "sum at most `goal`" minus "sum at most `goal - 1`", each with a sliding window that adds `right - left + 1` per right end. When `goal` is 0, the at-most-minus-one count is 0. Prefix sums with a hash map also work. Time `O(n)`.
