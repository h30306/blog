---
title: "LeetCode 253: Meeting Rooms II"
summary: "LeetCode 253 note: a heap of end times for running meetings; half-open intervals need <="
description: "LeetCode 253 record from 2026-10-15"
date: 2026-10-15
tags: ["medium", "heap", "sorting", "intervals", "sweep-line"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-15
- Submissions: Wrong Answer → Accepted

## Approach

Rooms needed = **the largest number of meetings running at the same time**.

Sort by start time and keep a min-heap of end times for meetings in progress. Before each new meeting, pop the meetings that have ended, then push its own end time. The largest heap size along the way is the answer.

## My First Attempt: `<` should be `<=`

```python
while heap and heap[0] < start:      # not popped when end == start
    heapq.heappop(heap)
```

Meetings are half-open `[start, end)`: if one ends at 10 and another starts at 10, they can share a room. So pop when the end time **equals** the start time too; the condition must be `<=`.

## Solution

```python
import heapq

class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        intervals.sort()
        heap = []
        best = 0
        for start, end in intervals:
            while heap and heap[0] <= start:
                heapq.heappop(heap)
            heapq.heappush(heap, end)
            best = max(best, len(heap))
        return best
```

My original code tracked the heap size in a separate `count`; `len(heap)` already is that.

### Alternative: sort starts and ends separately

```python
class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        starts = sorted(s for s, _ in intervals)
        ends = sorted(e for _, e in intervals)
        rooms = best = j = 0
        for s in starts:
            while ends[j] <= s:          # release rooms that have ended
                rooms -= 1
                j += 1
            rooms += 1
            best = max(best, rooms)
        return best
```

## Complexity

Both solutions run in `O(n log n)` time and `O(n)` space.

## Mistakes to Avoid

- Using `<` with half-open intervals: a meeting ending exactly when another starts is treated as overlapping.
- Checking only whether adjacent meetings overlap: what matters is how many run at once.

## Interview Explanation

The number of rooms is the maximum number of meetings running at once. I sort by start time and keep a min-heap of end times for running meetings. Before each meeting, I pop meetings whose end is at most its start, since intervals are half-open and a room that just freed up can be reused. Then I push its end time; the largest heap size is the answer. Time `O(n log n)`.
