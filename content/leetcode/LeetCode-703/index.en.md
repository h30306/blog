---
title: "LeetCode 703: Kth Largest Element in a Stream"
summary: "LeetCode 703 note: keep a min-heap of size k; its top is the k-th largest"
description: "LeetCode 703 record from 2022-08-31"
date: 2022-08-31
tags: ["easy", "tree", "design", "binary-search-tree", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-31
- Submissions: Accepted (first try)

## Approach

Only the `k` largest numbers matter. Keep a min-heap ([Heap]({{< relref "/algorithm/Heap" >}}) Template 1), popping the smallest whenever it exceeds `k`; the top is the smallest of those `k`, i.e. the k-th largest.

## My Solution

```python
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k, self.heap = k, []
        for x in nums:
            self.add(x)

    def add(self, val: int) -> int:
        heapq.heappush(self.heap, val)
        if len(self.heap) > self.k:
            heapq.heappop(self.heap)
        return self.heap[0]
```

## Complexity

Each `add` is `O(log k)`, space `O(k)`.

## Mistakes to Avoid

- The initial `nums` may have fewer than `k` items, so the heap may not be full at construction.

## Interview Explanation

I keep a min-heap of at most `k` items, popping the smallest after an insert pushes it past `k`; the top is the k-th largest. `O(log k)` each.
