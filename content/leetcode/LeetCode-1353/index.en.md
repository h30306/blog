---
title: "LeetCode 1353: Maximum Number of Events That Can Be Attended"
summary: "LeetCode 1353 note: each day, attend the event that ends earliest, using a min-heap of end days"
description: "LeetCode 1353 record from 2025-07-07"
date: 2025-07-07
tags: ["medium", "heap", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-07
- Submissions: Wrong Answer → Accepted → Accepted (cleaned up)

## Approach

Each event can be attended on any one day in `[start, end]`, and only one event per day.

Greedy: **each day, among events that have started and not ended, attend the one that ends earliest.** Later-ending events still have chances; an early-ending one is lost if skipped.

Steps:

1. Sort by start day.
2. Keep a min-heap of end days for events that have started.
3. Each day, push events starting today, drop expired ones, and attend the top.

## My First Attempt: one event per day in order

```python
events.sort(key=lambda x: x[0])
for s, e in events:
    if time >= s and time <= e:
        res += 1
    time += 1
```

This forces the `i`-th event onto day `i`, with no choice at all. It happens to work for `[[1,5],[1,5],[1,5]]`, but when there are gaps between events, `time` never jumps to the next start day, so the result is wrong.

## Solution

```python
import heapq

class Solution:
    def maxEvents(self, events: List[List[int]]) -> int:
        events.sort()
        heap = []
        res = i = day = 0
        n = len(events)

        while i < n or heap:
            if not heap:
                day = events[i][0]                 # nothing available: jump to the next start
            while i < n and events[i][0] <= day:
                heapq.heappush(heap, events[i][1])
                i += 1

            heapq.heappop(heap)                    # attend the earliest-ending event
            res += 1
            day += 1

            while heap and heap[0] < day:          # drop events that have ended
                heapq.heappop(heap)
        return res
```

## Complexity

Time `O(n log n)`: sorting plus one push and pop per event. Space `O(n)`.

## Mistakes to Avoid

- Pairing events with days one-to-one after sorting by start, with no "earliest end first" choice.
- Not dropping expired events: the top could be an event that already ended.
- Walking day by day without jumping to the next start when the heap is empty; days go up to `10^5`, so skipping saves time.

## Interview Explanation

My greedy choice is to attend, each day, the started event that ends earliest, since later-ending events still have chances. I sort by start day and keep a min-heap of end days: each day I add events that start, drop expired ones, and attend the top. When the heap is empty, I jump to the next event's start day. Time `O(n log n)`.
