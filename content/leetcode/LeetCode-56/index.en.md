---
title: "LeetCode 56: Merge Intervals"
summary: "LeetCode 56 note: sort by start; if a new interval starts at or before the last merged end, merge (taking the max end), otherwise open a new one"
description: "LeetCode 56 record from 2022-10-22"
date: 2022-10-22
tags: ["medium", "array", "sorting", "quicksort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-22
- Submissions: Wrong Answer ×3 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted ×3 → Runtime Error ×2 → Accepted ×3

## Approach

After sorting by start, mergeable intervals are adjacent ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 2). Track the last merged interval: if `start <= res[-1][1]`, merge with the end set to the **`max`** (the new one may lie inside); otherwise open a new one. Compare against the **merged** last interval, not the original previous one.

## My Attempts

I wrote this from 2022 to 2026 and failed 9 times, each on one condition:

- Comparing with **the original previous interval** rather than the merged result: `[[2, 2], [1, 5], [4, 7]]` sorts to `[1, 5], [2, 2], [4, 7]`, and `4` versus `[2, 2]` shows no overlap, returning `[[1, 5], [4, 7]]`.
- `<` instead of `<=`: `[[0, 2], [2, 3]]` stayed apart.
- Looping from 1 left out the first interval: `[[5, 5]]` returned `[]`; `append(intervals)` inserted the whole list.
- A 2022-10-31 rewrite took the new interval's end directly, **so a contained interval shortened the end**: `[[6, 9], [7, 8]]` returned `[[6, 8]]`.

## Solution

```python
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort()
        res = []
        for s, e in intervals:
            if res and s <= res[-1][1]:
                res[-1][1] = max(res[-1][1], e)
            else:
                res.append([s, e])
        return res
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Touching endpoints merge: use `<=` for `[0, 2]` and `[2, 3]`.
- Take the `max` end so a contained interval never shortens it.
- Compare with the last merged interval, not the previous input interval.

## Interview Explanation

Sorted by start, mergeable intervals are adjacent, so I keep the last merged interval and merge when the next start does not exceed its end, taking the larger end, or else open a new one. Time `O(n log n)`.
