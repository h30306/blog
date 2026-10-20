---
title: "LeetCode 757: Set Intersection Size At Least Two"
summary: "LeetCode 757 note: sort by right end (larger left end first on ties) and track only the two rightmost points; add the two right-end points when uncovered, or the right end when only one is covered"
description: "LeetCode 757 record from 2026-07-08"
date: 2026-07-08
tags: ["hard", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-08
- Submissions: Accepted ×2

## Approach

Process intervals by increasing right end ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 2). When a point is needed, **put it at the current interval's right end**: later intervals only have larger right ends, so points on the right are the most likely to be shared.

So track only the two rightmost points placed, `p1 < p2`:

- `s > p2`: neither is covered; place `e - 1` and `e`.
- `p1 < s <= p2`: only `p2` is covered; add `e`, and the new pair is `p2, e`.
- `s <= p1`: both are covered; add nothing.

**With the same right end, handle the larger left end (shorter interval) first.** Otherwise the `e` added in the "only one covered" case can be the `p2` already placed, counting one point twice. With `x[0]` (longer first) as the second key it fails on `[[0, 1], [1, 3], [2, 3], [3, 4]]`, whose answer is 5 (e.g. 0, 1, 2, 3, 4). Longer first, `[1, 3]` adds 3, then `[2, 3]` "adds" 3 again, so both tracked points are 3, and `[3, 4]` looks covered twice; it returns 4.

## My Solution

```python
class Solution:
    def intersectionSizeTwo(self, intervals: List[List[int]]) -> int:
        intervals.sort(key=lambda x: (x[1], -x[0]))
        p1 = p2 = -1                       # start >= 0, so -1 is never covered
        res = 0
        for s, e in intervals:
            if s > p2:
                res += 2
                p1, p2 = e - 1, e
            elif s > p1:
                res += 1
                p1, p2 = p2, e
        return res
```

I originally initialized `p1, p2` from the first interval; starting at -1 lets the first interval take the same branch.

## Complexity

Time `O(n log n)`, space `O(1)` besides sorting.

## Mistakes to Avoid

- Place points at the right end, not the left.
- The sort needs a second key: on equal right ends, larger left end first.

## Interview Explanation

I sort by right end and track only the two rightmost points. An uncovered interval gets its two rightmost points; one covered once gets its right end. Points further right are more likely to be shared by later intervals with larger right ends. On equal right ends the shorter interval goes first, so a needed point never duplicates one already placed. Time `O(n log n)`.
