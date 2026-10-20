---
title: "LeetCode 632: Smallest Range Covering Elements from K Lists"
summary: "LeetCode 632 note: a heap of each list's current element plus the running maximum; always advance the smallest"
description: "LeetCode 632 record from 2026-01-18"
date: 2026-01-18
tags: ["hard", "heap", "k-way-merge", "sliding-window"]
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
- Submissions: Time Limit Exceeded → Wrong Answer → Accepted → Wrong Answer → Accepted (rewritten the same day)

## Approach

Find the smallest range `[a, b]` that contains at least one number from every list.

Take one "current element" from each list; the minimum and maximum of those k numbers form a valid range. To shrink it, **only advancing the list holding the minimum can help**: advancing the list with the maximum only widens the range.

This is the same as a k-way merge:

1. Put the first element of each list in a heap and track the current maximum.
2. Pop the minimum and update the answer with `[minimum, maximum]`.
3. Push the next element of that list and update the maximum.
4. Stop when a list runs out: no later range can include that list.

## My Attempts

### TLE: push everything and recompute min and max each time

All elements went into the heap; while popping, a dict kept the last value seen per list, and once all k lists were present, every step took `min` and `max` over the dict. Each step is `O(k)`, `O(N k)` in total.

### Wrong Answer: starting the maximum at 0

```python
current_max = 0
```

Values can be negative. If every value is negative, the maximum stays 0 and the range is wrong. Start at `float("-inf")`.

### Something odd

The first accepted version returned `[min_end, min_start]`, where `min_end` held the maximum and `min_start` the minimum. The order looks reversed, yet it was judged Accepted. The rewrite the same day returned `[best_min, best_max]`. I use the correct order going forward.

## Solution

```python
import heapq

class Solution:
    def smallestRange(self, nums: List[List[int]]) -> List[int]:
        heap = [(lst[0], i, 0) for i, lst in enumerate(nums)]
        heapq.heapify(heap)
        current_max = max(lst[0] for lst in nums)
        best_min, best_max = float("-inf"), float("inf")

        while True:
            current_min, i, j = heapq.heappop(heap)
            if current_max - current_min < best_max - best_min:
                best_min, best_max = current_min, current_max

            if j + 1 == len(nums[i]):
                break                                   # this list is used up
            nxt = nums[i][j + 1]
            heapq.heappush(heap, (nxt, i, j + 1))
            current_max = max(current_max, nxt)

        return [best_min, best_max]
```

Updating with `<` works because minimums are popped in increasing order: among equal widths, the first range found has the smaller start, which matches the tie rule.

## Complexity

Time `O(N log k)`, where `N` is the total number of elements. Space `O(k)`.

## Mistakes to Avoid

- Starting the maximum at 0.
- Advancing the list with the maximum: only advancing the minimum can shrink the range.
- Continuing after a list runs out: no later range can include it.

## Interview Explanation

Taking one current element per list, their minimum and maximum form a valid range, and only advancing the list with the minimum can make it smaller. So I keep each list's current element in a heap along with the running maximum: pop the minimum, update the answer, push the next element of the same list, and stop when a list is exhausted. Time `O(N log k)`.
