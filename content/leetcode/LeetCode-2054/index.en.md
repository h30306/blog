---
title: "LeetCode 2054: Two Best Non-Overlapping Events"
summary: "LeetCode 2054 note: with at most two events, pair each event with the most valuable event that ends before it starts; sort by end time and use a prefix max with binary search"
description: "LeetCode 2054 record from 2026-02-04"
date: 2026-02-04
tags: ["medium", "dynamic-programming", "binary-search", "sorting", "heap"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-04
- Submissions: Accepted (first try)

## Approach

The same family as [LeetCode 1235]({{< relref "/leetcode/LeetCode-1235" >}}), but with **at most two** events, so no full DP is needed:

- Sort events by end time and compute a prefix max `prefix_best[j]` = the largest value among the first `j` events.
- Treat each event `(s, e, v)` as the second one: binary-search the last event with `end < s` (times are inclusive, so strictly less), and the candidate is `v + prefix_best`.
- Taking just one event also counts.

Another way is a sweep: split each event into "start" and "end + 1" points, sort them, keep the best value among finished events while sweeping, and update the answer at each start. The sweep is the version I submitted.

## My Solution

```python
from bisect import bisect_left

class Solution:
    def maxTwoEvents(self, events: List[List[int]]) -> int:
        events.sort(key=lambda e: e[1])            # by end time
        ends = [e for _, e, _ in events]
        prefix_best = []
        m = 0
        for _, _, v in events:
            m = max(m, v)
            prefix_best.append(m)

        ans = 0
        for s, _, v in events:
            i = bisect_left(ends, s) - 1           # last event with end < s
            ans = max(ans, v + (prefix_best[i] if i >= 0 else 0))
        return ans
```

Sweep version:

```python
class Solution:
    def maxTwoEvents(self, events: List[List[int]]) -> int:
        points = []
        for s, e, v in events:
            points.append((s, 1, v))               # 1: start
            points.append((e + 1, 0, v))           # 0: end (a new event may start at e + 1)
        points.sort()                              # ends come first at the same time
        ans = ended_best = 0
        for _, kind, v in points:
            if kind == 1:
                ans = max(ans, v + ended_best)
            else:
                ended_best = max(ended_best, v)
        return ans
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Times are inclusive: one event ending at `t` and another starting at `t` overlap, so the test is `end < start`.
- In the sweep, handle end points first at equal times; `(time, 0)` sorts before `(time, 1)`.

## Interview Explanation

With at most two events, for each event I only need the most valuable event that ends before it starts. I sort by end time, build a prefix max, and binary-search for each event the last one ending before its start, adding the two and taking the maximum. A sweep line works too. Time `O(n log n)`.
