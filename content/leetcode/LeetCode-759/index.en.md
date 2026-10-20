---
title: "LeetCode 759: Employee Free Time"
summary: "LeetCode 759 note: k-way merge all work intervals by start; any gap after the latest end so far is common free time"
description: "LeetCode 759 record from 2026-05-03"
date: 2026-05-03
tags: ["hard", "heap", "k-way-merge", "intervals", "sweep-line"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-05-03
- Submissions: Runtime Error (submitted an empty function) → Accepted (2026-09-06)

## Approach

Combine everyone's working time; **the finite gaps no one occupies** are the answer.

Scan all work intervals by start time while tracking `prev_end`, the latest end time so far:

- The next interval starts `> prev_end`: nobody works during `[prev_end, start]`, so it is common free time.
- Otherwise it overlaps; update `prev_end = max(prev_end, end)`.

Each employee's intervals are already sorted, so a k-way merge yields them in order without flattening and sorting everything.

## My Attempts

When I first opened this problem in May, I submitted only the empty function, hence the Runtime Error. I came back in September and solved it.

## Solution

```python
import heapq

class Solution:
    def employeeFreeTime(self, schedule: '[[Interval]]') -> '[Interval]':
        heap = [(emp[0].start, i, 0) for i, emp in enumerate(schedule) if emp]
        heapq.heapify(heap)
        if not heap:
            return []

        res = []
        prev_end = schedule[heap[0][1]][0].end
        while heap:
            start, i, j = heapq.heappop(heap)
            if start > prev_end:
                res.append(Interval(prev_end, start))
            prev_end = max(prev_end, schedule[i][j].end)
            if j + 1 < len(schedule[i]):
                heapq.heappush(heap, (schedule[i][j + 1].start, i, j + 1))
        return res
```

### Alternative: flatten and sort

```python
class Solution:
    def employeeFreeTime(self, schedule: '[[Interval]]') -> '[Interval]':
        intervals = sorted((iv.start, iv.end) for emp in schedule for iv in emp)
        res = []
        prev_end = intervals[0][1]
        for start, end in intervals[1:]:
            if start > prev_end:
                res.append(Interval(prev_end, start))
            prev_end = max(prev_end, end)
        return res
```

Shorter, at the cost of `O(N log N)` instead of `O(N log k)`.

## Complexity

K-way merge: time `O(N log k)`, space `O(k)`. Flatten and sort: time `O(N log N)`.

## Mistakes to Avoid

- Using the previous interval's end instead of the latest end so far: a short interval inside a long one creates a fake gap.
- Counting `start == prev_end` as a gap: zero-length gaps do not count.
- The output must be `Interval` objects, not lists.

## Interview Explanation

I scan everyone's work intervals by start time and track the latest end time so far. If the next interval starts after it, the gap in between is time when nobody works, so I add it; otherwise I extend the latest end. Each employee's intervals are already sorted, so a heap-based k-way merge gives `O(N log k)` time.
