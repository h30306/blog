---
title: "LeetCode 868: Binary Gap"
summary: "LeetCode 868 note: remember the last 1's position and take the maximum distance at each new 1"
description: "LeetCode 868 record from 2022-09-17"
date: 2022-09-17
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-17
- Submissions: Runtime Error ×2 → Wrong Answer ×5 → Accepted

## Approach

Scan from the lowest bit ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})), remembering the last 1's position `last`; at each new 1 the distance is `i - last`, and keep the maximum. With a single 1 the answer is 0.

## My Attempts

The early versions found the longest run of 0s via `s.split('1')` and added 1:

- **Trailing zeros were counted**, though no 1 follows them: `24` (`11000`) returned 4 instead of 1.
- After `strip('0')`, **adjacent 1s** are 1 apart but split into an empty string of length 0: `7` (`111`) returned 0, and `5` (`101`) stayed off by one.

Recording the positions of the 1s passed.

## Solution

```python
class Solution:
    def binaryGap(self, n: int) -> int:
        last, best, i = -1, 0, 0
        while n:
            if n & 1:
                if last >= 0:
                    best = max(best, i - last)
                last = i
            n >>= 1
            i += 1
        return best
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- The distance is the difference of positions: adjacent 1s are 1 apart, not 0.
- Trailing zeros have no 1 after them and form no gap.

## Interview Explanation

Scanning bits from the lowest, I remember the previous 1's position and update the maximum distance at each new 1. Time `O(log n)`, space `O(1)`.
