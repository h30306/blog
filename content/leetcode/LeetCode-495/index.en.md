---
title: "LeetCode 495: Teemo Attacking"
summary: "LeetCode 495 note: each attack contributes min(gap to the next attack, duration), and the last one contributes the full duration"
description: "LeetCode 495 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted ×3

## Approach

Each new attack resets the poison. Attack `i` effectively lasts `min(t[i + 1] - t[i], duration)`: a gap longer than the duration gives the full duration, a shorter one only lasts until the next attack. The last attack is never cut short and adds the full `duration` ([Array]({{< relref "/algorithm/Array" >}}) Template 5).

## My Attempts

Attempt 1 read `i + 1` while looping over `range(len(timeSeries))`, overrunning the end. Attempt 2 **swapped the branches**, adding the gap when it exceeded the duration instead of the duration: `[2, 7]`, `duration = 0` returned 5 instead of 0. Subtracting the overlaps passed.

## Solution

```python
class Solution:
    def findPoisonedDuration(self, timeSeries: List[int], duration: int) -> int:
        total = duration
        for i in range(len(timeSeries) - 1):
            total += min(timeSeries[i + 1] - timeSeries[i], duration)
        return total
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Take the **smaller** of the gap and the duration; with a large gap the effect is the duration, not the gap.
- Add the last attack's duration separately.

## Interview Explanation

Each attack is cut short by the next, so it contributes the smaller of the gap and the duration, and the last attack adds the full duration. Time `O(n)`.
