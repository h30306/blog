---
title: "LeetCode 2762: Continuous Subarrays"
summary: "LeetCode 2762 note: a sliding window with two monotonic queues for the window maximum and minimum"
description: "LeetCode 2762 record from 2026-01-19"
date: 2026-01-19
tags: ["medium", "sliding-window", "monotonic-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-19
- Submissions: Accepted (first try)

## Approach

Every pair in the subarray differs by at most 2, which means **`max - min <= 2`**.

The condition is monotonic: if a subarray is valid, so is every subarray of it. So use a sliding window: each time the right end moves, push the left end right until the window is valid again. There are `right - left + 1` valid subarrays ending at `right`.

The window needs its maximum and minimum at all times. A heap gives `O(log n)`, but **two monotonic queues** give amortized `O(1)`:

- `max_q`: indices whose values are **decreasing**; the front is the window maximum.
- `min_q`: indices whose values are **increasing**; the front is the window minimum.

LeetCode tags this problem as heap, but monotonic queues are faster and simpler.

## My Solution

```python
from collections import deque

class Solution:
    def continuousSubarrays(self, nums: List[int]) -> int:
        max_q, min_q = deque(), deque()
        left = count = 0
        for right, x in enumerate(nums):
            while max_q and nums[max_q[-1]] < x:
                max_q.pop()
            max_q.append(right)
            while min_q and nums[min_q[-1]] > x:
                min_q.pop()
            min_q.append(right)

            while nums[max_q[0]] - nums[min_q[0]] > 2:
                if max_q[0] == left:
                    max_q.popleft()
                if min_q[0] == left:
                    min_q.popleft()
                left += 1

            count += right - left + 1
        return count
```

When `left` moves, only a front equal to `left` must be removed; every other index is larger than `left` and still in the window.

## Complexity

Time `O(n)`: each index enters and leaves each queue at most once. Space `O(n)`.

## Mistakes to Avoid

- Calling `max()` and `min()` on the window every step: `O(n^2)`.
- Storing values instead of indices in the queues: you cannot tell whether the front has left the window.
- Adding `1` instead of `right - left + 1`: count every subarray ending at `right`.

## Interview Explanation

The condition is "window max minus min at most 2", and subarrays of a valid subarray are valid, so a sliding window works. I keep two monotonic queues of indices, one decreasing and one increasing, whose fronts are the window max and min. After adding each number, I move the left end until the window is valid and add `right - left + 1` subarrays ending at `right`. Each index enters and leaves each queue once, so time is `O(n)`.
