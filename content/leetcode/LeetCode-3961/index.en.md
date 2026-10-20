---
title: "LeetCode 3961: Maximize Sum of Device Ratings"
summary: "LeetCode 3961 note: every device but one donates its smallest unit to the same device; that device's rating becomes the global minimum, so pick the one with the smallest second-smallest value"
description: "LeetCode 3961 record from 2026-06-18"
date: 2026-06-18
tags: ["medium", "greedy", "sorting", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-18
- Submissions: Wrong Answer → Accepted

## Approach

A device's rating is its smallest unit. Donating that unit raises the rating to the second-smallest value, never lowering it.

- Each device donates at most once, so it can rise at most to its second-smallest value.
- Received units drag the receiver's rating down. Send **every** donation to the same device and sacrifice only that one: its rating becomes the smallest of all minimums (the global minimum).
- Which one to sacrifice? Every other device gets its second-smallest value, so sacrifice the one whose second-smallest is smallest.

The answer is `sum of second-smallest values - smallest second-smallest + global minimum`. With one unit per device, donating empties the device (rating 0), so do nothing and return the sum of all units. This is the pairing idea from [Greedy]({{< relref "/algorithm/Greedy" >}}) Template 4.

## My Attempts

Attempt 1 took `unit[0]` as the minimum and `unit[1]` as the second-smallest, **assuming each row was sorted**. For `[[4, 3]]` a single device cannot donate, so the answer is 3; it returned 4.

Finding each row's minimum, removing it, then finding the second-smallest passed.

## Solution

```python
class Solution:
    def maxRatings(self, units: List[List[int]]) -> int:
        if len(units[0]) == 1:
            return sum(u[0] for u in units)
        global_min, total, min_second = inf, 0, inf
        for u in units:
            a, b = heapq.nsmallest(2, u)
            global_min = min(global_min, a)
            total += b
            min_second = min(min_second, b)
        return total - min_second + global_min
```

With a single device the formula gives `b - b + a = a`, exactly the do-nothing answer.

## Complexity

Time `O(m · n)`, space `O(1)`.

## Mistakes to Avoid

- Rows are not sorted; find the smallest and second-smallest yourself.
- Special-case one unit per device.

## Interview Explanation

Donating the smallest unit lifts a rating to the second-smallest value, so all devices but one donate, all to the same device, sacrificing only it. The sacrificed device ends at the global minimum, so choose the one with the smallest second-smallest value. The answer is the sum of second-smallest values minus the smallest of them plus the global minimum. Time `O(m · n)`.
