---
title: "LeetCode 3323: Minimize Connected Groups by Inserting Interval"
summary: "LeetCode 3323 note: merge first; a new interval can join groups l through r ⇔ start of group r − end of group l <= k, so a sliding window finds the most groups one interval can connect"
description: "LeetCode 3323 record from 2026-01-28"
date: 2026-01-28
tags: ["medium", "sliding-window", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-28
- Submissions: Accepted (first try)

## Approach

1. **Merge first**: sort and merge overlapping or touching intervals into `m` separate groups.
2. The new interval has length at most `k`. To join groups `l` through `r`, it must span from the end of group `l` to the start of group `r`: **`merged[r].start - merged[l].end <= k`**.
3. A sliding window finds the most groups `cnt` one interval can join; the answer is `m - (cnt - 1)`.

As `r` moves right its start grows, so the reachable `l` only moves right: the condition is monotonic.

## My Solution

```python
class Solution:
    def minConnectedGroups(self, intervals: List[List[int]], k: int) -> int:
        intervals.sort()
        merged = []
        for start, end in intervals:
            if merged and start <= merged[-1][1]:
                merged[-1][1] = max(merged[-1][1], end)
            else:
                merged.append([start, end])

        best = left = 0
        for right in range(len(merged)):
            while merged[right][0] - merged[left][1] > k:
                left += 1                          # the new interval cannot reach
            best = max(best, right - left + 1)
        return len(merged) - (best - 1)
```

With `right == left`, `merged[right][0] - merged[left][1]` is negative, so `left` never passes `right` and `best` is at least 1.

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Sliding over the raw intervals without merging: overlapping intervals would count as several groups.
- Joining `cnt` groups removes `cnt - 1` groups, not `cnt`.

## Interview Explanation

I sort and merge the intervals into separate groups. The new interval is at most `k` long, so joining groups `l` through `r` needs group `r`'s start minus group `l`'s end to be at most `k`. That is monotonic in `r`, so a sliding window finds the most groups one interval can join, and the group count drops by that number minus one. Time `O(n log n)`.
