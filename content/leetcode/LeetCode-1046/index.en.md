---
title: "LeetCode 1046: Last Stone Weight"
summary: "LeetCode 1046 note: from a max-heap (negated values) take the two heaviest each round, push back their difference if unequal, and return the last stone or 0"
description: "LeetCode 1046 record from 2022-09-30"
date: 2022-09-30
tags: ["easy", "array", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-30
- Submissions: Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted → Runtime Error → Accepted ×2

## Approach

Each round needs the two heaviest stones, so use a max-heap ([Heap]({{< relref "/algorithm/Heap" >}}); negate values in Python). Take `y >= x` and push back `y - x` if they differ. With negated values, **mind the sign**: for the popped negatives `a` (heavier, popped first) and `b`, `a - b` is negative, exactly the negated difference to push. Return 0 if the heap empties.

## My Attempts

I wrote this four times (2022-09, twice in 2022-11, 2025) and failed 5 times:

- The first 2022-09 version pushed back `x - y`, **which is positive since the values are negated**, so it became a very light stone: `[2, 7]` returned -5 instead of 5. With `y - x`, two equal stones cancelling everything made `h[0]` go out of range (IndexError).
- A 2022-11 rewrite inverted the condition as `if heaviest != second_heaviest: continue`, **discarding exactly the unequal pairs**: `[2, 7]` returned 0. The other two failures were IndexErrors on an empty heap.

## Solution

```python
class Solution:
    def lastStoneWeight(self, stones: List[int]) -> int:
        h = [-s for s in stones]
        heapq.heapify(h)
        while len(h) > 1:
            a = heapq.heappop(h)
            b = heapq.heappop(h)
            if a != b:
                heapq.heappush(h, a - b)
        return -h[0] if h else 0
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- With negated values, push a negative difference.
- The heap may end up empty; return 0.

## Interview Explanation

Each round needs the two heaviest, so I pop two from a negated max-heap, push back their difference when unequal, and return the last stone or 0. Time `O(n log n)`.
