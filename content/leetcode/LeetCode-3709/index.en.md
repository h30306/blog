---
title: "LeetCode 3709: Design Exam Scores Tracker"
summary: "LeetCode 3709 note: times are increasing, so store prefix sums and answer queries with two bisects; always parenthesize mid"
description: "LeetCode 3709 record from 2025-10-11"
date: 2025-10-11
tags: ["medium", "binary-search", "prefix-sum", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-10-11
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Accepted

## Approach

`record` times are strictly increasing, so the time array is already sorted.

- `times`: the time of every record.
- `prefix`: prefix sums of scores, where `prefix[i]` is the total of the first `i` records and `prefix[0] = 0`.

For a query `[start, end]`:

```text
left  = first position with time >= start = bisect_left(times, start)
right = first position with time >  end   = bisect_right(times, end)
total = prefix[right] - prefix[left]
```

The leading 0 in `prefix` removes the special case where the left boundary is 0.

## My Attempts

### WA and RE: `mid` without parentheses

```python
mid = left + right // 2       # means left + (right // 2)
```

`//` binds tighter than `+`, so `mid` overshoots: sometimes it finds the wrong position (WA), sometimes it goes out of range (RE).

### WA: a query range with no records

After fixing `mid`, a range with no exams produced a left boundary larger than the right one, giving negative totals or bad indices. Several boundary checks were added before it passed.

**The root cause was a prefix array without a leading 0**, which forced special cases for "is the left boundary 0". With `prefix[0] = 0` and two half-open boundaries, none of those checks are needed: with no records the two boundaries are equal, so the difference is 0.

## Solution

```python
import bisect

class ExamTracker:

    def __init__(self):
        self.times = []
        self.prefix = [0]

    def record(self, time: int, score: int) -> None:
        self.times.append(time)
        self.prefix.append(self.prefix[-1] + score)

    def totalScore(self, startTime: int, endTime: int) -> int:
        lo = bisect.bisect_left(self.times, startTime)
        hi = bisect.bisect_right(self.times, endTime)
        return self.prefix[hi] - self.prefix[lo]
```

## Complexity

`record` is `O(1)`, `totalScore` is `O(log n)`. Space `O(n)`.

## Mistakes to Avoid

- `mid = left + right // 2`: missing parentheses.
- A prefix array without a leading 0, leading to many special cases.
- Not returning 0 when the range has no records.

## Interview Explanation

Record times are strictly increasing, so I store the times and prefix sums of scores, with a leading 0 in the prefix. A query uses `bisect_left` for the first time at or after the start and `bisect_right` for the first time after the end; the prefix difference is the total, and with no records the two positions coincide, giving 0. Records are `O(1)`, queries `O(log n)`.
