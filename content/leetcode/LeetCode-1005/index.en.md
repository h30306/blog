---
title: "LeetCode 1005: Maximize Sum Of Array After K Negations"
summary: "LeetCode 1005 note: negate the smallest value each time; once the smallest is positive, only the parity of the remaining count matters"
description: "LeetCode 1005 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-27
- Submissions: Runtime Error → Accepted

## Approach

Greedy ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1): negating the current minimum increases the sum the most. A min-heap doing `k` rounds of `heappop` and `heappush(-x)` suffices, `O(k log n)`. Alternatively sort, flip negatives from smallest up, and if an odd number of flips remain, flip the value with the smallest absolute value once more.

## My Attempts

Attempt 1 had an indentation error (Runtime Error); the same min-heap code then passed.

## Solution

```python
class Solution:
    def largestSumAfterKNegations(self, nums: List[int], k: int) -> int:
        heapq.heapify(nums)
        for _ in range(k):
            heapq.heappush(nums, -heapq.heappop(nums))
        return sum(nums)
```

## Complexity

Time `O(n + k log n)`, space `O(1)`.

## Mistakes to Avoid

- One value may be negated many times; once the minimum is positive it flips back and forth, which the heap handles naturally.

## Interview Explanation

Negating the minimum gains the most each time, so I do it k times with a min-heap and sum at the end; once the minimum is positive the same value flips back and forth, so only parity matters. Time `O(n + k log n)`.
