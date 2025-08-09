---
title: "LeetCode 3439: Reschedule Meetings for Maximum Free Time (Sliding Window)"
summary: "Sliding window over meetings; track total duration in a k-sized window and compute free span between boundaries."
description: "LeetCode Daily"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "sliding-window", "two-pointers", "intervals", "array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Medium
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

Meetings are sorted and non-overlapping. Removing (rescheduling) a block of up to k consecutive meetings creates a potential free span bounded by the end of the meeting just before the block and the start of the meeting just after the block (or the day edges). The length of that free span equals:

right boundary − left boundary − (sum of durations inside the removed block)

This leads to a sliding-window formulation over consecutive meetings:
- Precompute the total duration of the first k meetings as the initial window sum.
- Slide the window one meeting at a time, updating the running sum in O(1) by adding the incoming meeting’s duration and subtracting the outgoing one.
- For each window ending at index i, set `left = endTime[i - k]` and `right = startTime[i + 1]` (with edges `left = 0` if no prior meeting and `right = eventTime` if no next meeting), and compute `right - left - meeting_time`.
- Edge case: when n ≤ k, all meetings can be moved away, so the entire day minus the total meeting time is free, i.e., `eventTime - sum(endTime) + sum(startTime)`.

## Approach

- Iterate meetings with a sliding window representing the k meetings to reschedule.
- Maintain `meeting_counts` and `meeting_times` (sum of durations) for the current window.
- If the window exceeds size k, shrink it by removing the oldest meeting from the sums.
- Boundaries: left is `0` or `endTime[idx - k]`; right is `eventTime` or `startTime[idx + 1]`.
- For each step, update `max_free` with `right - left - meeting_times`.

### Directly iterate the meeting times
```python
class Solution:
    def maxFreeTime(self, eventTime: int, k: int, startTime: List[int], endTime: List[int]) -> int:

        meeting_times = meeting_counts = max_free = 0
        for idx, (s, e) in enumerate(zip(startTime, endTime)):
            meeting_times += e - s
            meeting_counts += 1
            
            if meeting_counts > k:
                meeting_counts -= 1
                meeting_times -= endTime[idx - k] - startTime[idx - k]

            left = 0 if (idx - k + 1) <= 0 else endTime[idx - k]
            right = eventTime if idx == len(startTime) - 1 else startTime[idx + 1]
            max_free = max(max_free, right - left - meeting_times)

        return max_free
```

### Count the first window and slide the window
```python
class Solution:
    def maxFreeTime(self, eventTime: int, k: int, startTime: List[int], endTime: List[int]) -> int:
        n = len(startTime)
        if n <= k:
            return eventTime - sum(endTime) + sum(startTime)

        meeting_time = 0
        for i in range(k):
            meeting_time += endTime[i] - startTime[i]
        
        max_free = startTime[k] - meeting_time

        for i in range(k, n):
            meeting_time += endTime[i] - startTime[i]
            meeting_time -= endTime[i - k] - startTime[i - k]

            right = startTime[i + 1] if i < n - 1 else eventTime
            left = endTime[i - k]

            max_free = max(max_free, right - left - meeting_time)

        return max_free
```

## Complexity

- Time: O(n)
- Space: O(1)

## Findings

- Maintaining a running sum of durations lets the window move in O(1) per step.
- The free interval is determined by the boundaries around the window minus the window’s internal durations.

## Encountered Problems 