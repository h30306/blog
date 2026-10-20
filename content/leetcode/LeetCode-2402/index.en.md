---
title: "LeetCode 2402: Meeting Rooms III"
summary: "LeetCode 2402 note: one heap for free rooms and one for busy rooms; a delayed meeting keeps its original length"
description: "LeetCode 2402 record from 2025-07-17"
date: 2025-07-17
tags: ["hard", "heap", "sorting", "simulation", "intervals"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-07-17
- Submissions: Wrong Answer ×3 → Runtime Error → Accepted

## Approach

Rules:

1. Process meetings by start time (all start times are distinct).
2. If a room is free, use the **lowest-numbered** one.
3. If none is free, wait for the room that frees up **earliest**; the meeting is delayed but **keeps its length**.

The two "smallest" choices use different keys, so use two heaps:

- `free`: numbers of free rooms.
- `busy`: `(end time, room number)`; on equal end times, the lower number comes out first.

Before each meeting, move every room in `busy` with end time `<= start` into `free`.

## My Attempts

### Attempt 1: a single heap

```python
free_times = [(0, room) for room in range(n)]
for start, end in meetings:
    free_time, room = heapq.heappop(free_times)
    meeting_end = max(end + free_time, end)
```

A single `(free time, room)` heap returns the room that freed up earliest, not the lowest-numbered room among those already free. If room 1 frees at time 0 and room 0 at time 3, a meeting at time 5 should get room 0, but this version picks room 1.

The delayed end time `end + free_time` is also wrong.

### Attempt 2: two heaps, wrong delayed end time

```python
free_time, room = heapq.heappop(free_times)
meeting_end = max(free_time + end, end)
```

A delayed meeting starts when the room frees up and **lasts its original length** `end - start`, so it ends at `free_time + (end - start)`.

### Runtime Error: a typo

While fixing the formula, `free_time` became `ree_time`.

## Solution

```python
import heapq

class Solution:
    def mostBooked(self, n: int, meetings: List[List[int]]) -> int:
        meetings.sort()
        free = list(range(n))            # free room numbers
        busy = []                        # (end time, room number)
        count = [0] * n

        for start, end in meetings:
            while busy and busy[0][0] <= start:
                _, room = heapq.heappop(busy)
                heapq.heappush(free, room)

            if free:
                room = heapq.heappop(free)
                heapq.heappush(busy, (end, room))
            else:
                free_time, room = heapq.heappop(busy)
                heapq.heappush(busy, (free_time + end - start, room))
            count[room] += 1

        return count.index(max(count))   # index returns the lowest number on ties
```

## Complexity

Time `O(m log m + m log n)`, where `m` is the number of meetings. Space `O(n)`.

## Mistakes to Avoid

- Using one heap for both "lowest number when free" and "earliest free when all busy".
- Not keeping the original length of a delayed meeting.
- End times can exceed 32 bits: use `long` in Java/C++.

## Interview Explanation

I use two heaps: free rooms by number, and busy rooms by end time then number. Before each meeting, I move finished rooms back to the free heap. If a room is free, I take the lowest number; if all are busy, I take the room that frees up earliest and start the meeting then, keeping its original length. Finally I return the most-used room, lowest number on ties. Time `O(m log m)`.
