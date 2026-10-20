---
title: "LeetCode 4067: Longest Subarray With Restricted Pair Sums"
summary: "LeetCode 4067 note: subarrays of a valid window stay valid, so slide; adding x only needs checks involving x: x as an addend (x + y in the window) or x as the sum (x - y in the window)"
description: "LeetCode 4067 record from 2026-09-27"
date: 2026-09-27
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
First Attempt: 2026-09-27
- Submissions: Accepted (first try)

## Approach

Trimming a valid window keeps it valid, so the "longest" sliding window applies.

Before adding a new `x` the window is valid, so **any new conflict involves `x`**. For each value `y` present in the window (values range only from 1 to 500):

- **`x` as an addend**: `x + y` is also in the window → conflict (`x + y > y`, so `x + y` and `y` are at different positions).
- **`x` as the sum**: `x - y` is in the window → conflict. If `x - y == y`, it needs two `y`s at different positions, so a count `>= 2`.

On a conflict, shrink the left and recheck until there is none, then add `x`.

All numbers are positive, so `y + 0 = y` never occurs.

## My Solution

```python
class Solution:
    def maxSubarray(self, nums: List[int]) -> int:
        cnt = [0] * 501
        active = set()                             # values present in the window

        def conflict(x: int) -> bool:
            for y in active:
                if x + y <= 500 and cnt[x + y]:
                    return True                    # x + y equals a number in the window
                z = x - y
                if z > 0 and cnt[z] > (1 if z == y else 0):
                    return True                    # y + z = x
            return False

        left = best = 0
        for right, x in enumerate(nums):
            while left < right and conflict(x):
                y = nums[left]
                cnt[y] -= 1
                if cnt[y] == 0:
                    active.remove(y)
                left += 1
            cnt[x] += 1
            active.add(x)
            best = max(best, right - left + 1)
        return best
```

## Complexity

Each check looks at most 500 values, and there are at most `2n` checks (one per right end plus one per left move), so time is `O(500 · n)`, space `O(500)`.

## Mistakes to Avoid

- When `x - y == y`, two copies of `y` are needed.
- Rechecking every triple in the window: only those involving the new element matter.

## Interview Explanation

Subarrays of a valid window are valid, so I slide. The window was valid before adding the new `x`, so I only check cases involving `x`: whether `x` plus some `y` in the window is also present, or whether `x` minus `y` is present (with two copies needed when it equals `y`). With values up to 500 each check is `O(500)`, and on a conflict I shrink the left.
