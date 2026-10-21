---
title: "LeetCode 435: Non-overlapping Intervals"
summary: "LeetCode 435 note: minimum removals = total minus the maximum kept; sort by right end and greedily keep the one ending earliest"
description: "LeetCode 435 record from 2022-11-16"
date: 2022-11-16
tags: ["medium", "array", "dynamic-programming", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-16
- Submissions: Wrong Answer → Accepted → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted

## Approach

Removing the fewest means keeping the most disjoint intervals ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 2). Sort by right end; scanning left to right, keep an interval whose start is `>=` the last kept end, otherwise remove it. Keeping the earliest end leaves the most room.

Sorting by start also works: on an overlap remove one, **keeping the smaller right end** (`end = min(end, b)`).

## My Attempts

I sorted by start:

- On 2022-11-16 attempt 1 kept the **larger** right end (`max`) on an overlap; keeping the smaller one makes later intervals collide less. `min` passed.
- A 2022-11-27 rewrite never updated the right end after an overlap and started from `[0, 0]`, failing with negative starts; four failures later I returned to the correct form.

## Solution

```python
class Solution:
    def eraseOverlapIntervals(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: x[1])
        end, kept = float("-inf"), 0
        for a, b in intervals:
            if a >= end:
                kept += 1
                end = b
        return len(intervals) - kept
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Touching endpoints do not overlap; use `>=`.
- When sorting by start, keep the shorter of two overlapping intervals (`min` of the right ends), not `max`.

## Interview Explanation

Removing the fewest means keeping the most disjoint intervals, so I sort by right end, keep each interval starting at or after the last kept end, and subtract. Keeping the earliest end leaves the most room. Time `O(n log n)`.
