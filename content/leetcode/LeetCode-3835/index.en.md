---
title: "LeetCode 3835: Count Subarrays With Cost Less Than or Equal to K"
summary: "LeetCode 3835 note: cost = (max - min) × length only grows as the window grows, so a sliding window counts subarrays; two monotonic deques keep the window's max and min"
description: "LeetCode 3835 record from 2026-02-08"
date: 2026-02-08
tags: ["medium", "sliding-window", "monotonic-queue", "queue", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-08
- Submissions: Wrong Answer → Accepted

## Approach

`cost = (max - min) × length`. As the window grows, `max - min` never shrinks and the length grows, so **cost only increases**, which makes the condition monotonic:

- Add on the right; shrink the left while the cost is `> k`.
- There are `right - left + 1` valid subarrays ending at `right`.

The window's max and min come from **two monotonic deques** of indices:

- The max deque has decreasing values: before adding, pop back entries `<=` the new value.
- The min deque has increasing values: pop back entries `>=` it.
- After the left boundary moves, pop front indices `< left` (expired).

## My Attempts

Attempt 1 used lists as queues and mixed the "expired" check into the loop that pops from the **back** (`max_stack[0] < left`), with the min side written as `min_stack[0] > left`. Expired entries belong at the **front**, which is a separate job from popping dominated entries at the back. For `nums = [6, 2, 3]`, `k = 9`, the answer is 5; it returned 6.

Two `deque`s, with the back handling only dominated entries and the front handling only expired ones, passed.

## Solution

```python
from collections import deque

class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        max_q, min_q = deque(), deque()            # indices
        left = count = 0
        for right, x in enumerate(nums):
            while max_q and nums[max_q[-1]] <= x:
                max_q.pop()
            max_q.append(right)
            while min_q and nums[min_q[-1]] >= x:
                min_q.pop()
            min_q.append(right)

            while (nums[max_q[0]] - nums[min_q[0]]) * (right - left + 1) > k:
                left += 1
                if max_q[0] < left:
                    max_q.popleft()                # expired
                if min_q[0] < left:
                    min_q.popleft()
            count += right - left + 1
        return count
```

With `left == right` the cost is 0 and `k >= 0`, so the shrinking loop never empties the deques.

## Complexity

Time `O(n)`: each index enters and leaves each deque once. Space `O(n)`.

## Mistakes to Avoid

- Mixing "expired" and "dominated" into one condition: one pops from the front, the other from the back.
- Using `list.pop(0)` as a queue: `O(n)` each time.

## Interview Explanation

Cost is max minus min times length, and it only grows with the window, so a sliding window works: shrink the left while the cost exceeds `k`, and `right - left + 1` valid subarrays end at the right boundary. Two monotonic deques give the window's max and min, popping dominated entries at the back and expired ones at the front. Each index enters and leaves once, so time is `O(n)`.
