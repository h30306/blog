---
title: "LeetCode 973: K Closest Points to Origin"
summary: "LeetCode 973 note: as in Top-K, keep a size-k max-heap (negated distances) holding the k closest points"
description: "LeetCode 973 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "array", "math", "divide-and-conquer", "geometry"]
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
- Submissions: Runtime Error → Accepted

## Approach

For the `k` closest, keep a size-`k` heap whose top is the farthest so far ([Heap]({{< relref "/algorithm/Heap" >}}) Template 1). Python offers only a min-heap, so store `-(x² + y²)`. Once full, `heappushpop` discards anything farther than the top. Compare squared distances; no square roots needed.

## My Attempts

Attempt 1 used the old parameter name `K` (NameError); renaming it to `k` passed.

## Solution

```python
class Solution:
    def kClosest(self, points: List[List[int]], k: int) -> List[List[int]]:
        heap = []
        for x, y in points:
            item = (-(x * x + y * y), x, y)
            if len(heap) < k:
                heapq.heappush(heap, item)
            else:
                heapq.heappushpop(heap, item)
        return [[x, y] for _, x, y in heap]
```

## Complexity

Time `O(n log k)`, space `O(k)`.

## Mistakes to Avoid

- To keep the closest, the top must be the farthest: store negated distances.
- Squared distances suffice.

## Interview Explanation

A size-k heap of negated squared distances keeps the farthest point on top; once full, each new point is pushpopped, leaving the k closest. Time `O(n log k)`.
