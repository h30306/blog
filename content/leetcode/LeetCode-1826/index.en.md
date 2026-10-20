---
title: "LeetCode 1826: Faulty Sensor"
summary: "LeetCode 1826 note: at the first mismatch, test both \"who dropped a value\" explanations; if both fit, it cannot be determined, so return -1"
description: "LeetCode 1826 record from 2026-04-05"
date: 2026-04-05
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-05
- Submissions: Wrong Answer ×2 → Accepted

## Approach

A faulty sensor drops one value, shifts the rest left by one, and fills the last slot with a random value (guaranteed not to equal the dropped value). At most one sensor is faulty.

Find the first `i` with `sensor1[i] != sensor2[i]`:

- If **sensor2 is faulty**, it dropped `sensor1[i]`, so `sensor2[i:-1]` should equal `sensor1[i+1:]`.
- If **sensor1 is faulty**, likewise `sensor1[i:-1]` should equal `sensor2[i+1:]`.

Only one explanation fitting identifies the sensor; **if both or neither fit**, it cannot be determined, so return `-1`. No mismatch at all also returns `-1`.

## My Attempts

1. **Attempt 1** compared only the next element: `sensor1[i + 1] == sensor2[i]` meant sensor2 was faulty.
2. **Attempt 2** compared the whole remaining tail but still **did not handle both explanations fitting**.

Both fail on `sensor1 = [3, 3, 2, 3]`, `sensor2 = [3, 2, 3, 2]`. Sensor2 could have dropped the second 3 (with 2 appended), and sensor1 could have dropped sensor2's first 2 (with 3 appended); both fit, so the answer is `-1`, but both versions returned 2.

## Solution

```python
class Solution:
    def badSensor(self, sensor1: List[int], sensor2: List[int]) -> int:
        n = len(sensor1)
        for i in range(n - 1):
            if sensor1[i] != sensor2[i]:
                sensor2_bad = sensor1[i + 1:] == sensor2[i:-1]
                sensor1_bad = sensor2[i + 1:] == sensor1[i:-1]
                if sensor1_bad == sensor2_bad:
                    return -1
                return 1 if sensor1_bad else 2
        return -1
```

The loop stops at `n - 2`: if only the last position differs, it is just the random fill value, and the faulty sensor cannot be identified.

## Complexity

Time `O(n)`, space `O(n)` (slices copy).

## Mistakes to Avoid

- Concluding from the next element alone.
- Not handling the case where both explanations fit.

## Interview Explanation

I find the first mismatch `i` and test each hypothesis: if sensor2 is faulty, its data from `i` should equal sensor1's data from `i + 1`, ignoring the last slot, and symmetrically for sensor1. Exactly one fitting identifies the sensor; if both or neither fit, I return `-1`. Time `O(n)`.
