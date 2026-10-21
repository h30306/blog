---
title: "LeetCode 215: Kth Largest Element in an Array"
summary: "LeetCode 215 note: keep a min-heap of size k whose top is the k-th largest, or use quickselect for O(n) on average"
description: "LeetCode 215 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "array", "divide-and-conquer", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Wrong Answer ×3 → Output Limit Exceeded → Accepted ×3

## Approach

Top-K ([Heap]({{< relref "/algorithm/Heap" >}}) Template 1): a min-heap holds the `k` largest values so far. Push while it is not full; once full, `heappushpop`, which immediately discards a value smaller than the top and otherwise replaces the top. After the scan the top is the `k`-th largest, in `O(n log k)`. Alternatively quickselect recurses only into the side containing the answer, `O(n)` on average.

## My Attempts

The first three wrote `if len(heap) > k: heappop else: heappush`: the heap first grew to `k + 1` elements, and afterward **a new value triggered a pop without being inserted**, so the final top was not the `k`-th largest: `[1, 7]`, `k = 1` returned 1 instead of 7. One more left a `print` (Output Limit Exceeded); `heappushpop` when `len(heap) == k` passed.

## Solution

```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        heap = []
        for x in nums:
            if len(heap) < k:
                heapq.heappush(heap, x)
            else:
                heapq.heappushpop(heap, x)
        return heap[0]
```

## Complexity

Time `O(n log k)`, space `O(k)`.

## Mistakes to Avoid

- Once the heap is full, still process each new value: push it and pop the smallest, never skip it.
- The size cap is `k`; testing `> k` keeps one too many.

## Interview Explanation

A size-k min-heap holds the k largest values; once full, each new value is pushpopped, so the top, the smallest of those k, is the k-th largest. Time `O(n log k)`; quickselect averages `O(n)`.
