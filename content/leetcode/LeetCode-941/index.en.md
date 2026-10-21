---
title: "LeetCode 941: Valid Mountain Array"
summary: "LeetCode 941 note: climb from the left to the peak, then descend; you must reach the end exactly, with the peak not at either end"
description: "LeetCode 941 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted ×4

## Approach

Walk the monotonic runs ([Array]({{< relref "/algorithm/Array" >}}) Template 1): from 0, advance while strictly rising; where it stops is the peak, and **the peak cannot be the first or last element** (no ascent or no descent). Then advance while strictly falling; you must land exactly on the last element. Equal neighbors stop both walks and fail naturally.

## My Attempts

- Attempt 1 looped over `range(len(arr))` while reading `arr[i + 1]`, overrunning the end.
- Attempt 2 only forbade rising after falling, **without requiring both an ascent and a descent**: `[3]` returned `True`.
- Attempt 3 returned `increase`, so the purely rising `[0, 2]` still returned `True`. Requiring a rise before any fall and returning `increase and decrease` passed.

## Solution

```python
class Solution:
    def validMountainArray(self, arr: List[int]) -> bool:
        n, i = len(arr), 0
        while i + 1 < n and arr[i] < arr[i + 1]:
            i += 1
        if i == 0 or i == n - 1:
            return False
        while i + 1 < n and arr[i] > arr[i + 1]:
            i += 1
        return i == n - 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Both an ascent and a descent must exist; purely rising or falling arrays fail.
- Arrays shorter than 3 never qualify.

## Interview Explanation

I climb from the left to the peak, which must not be at either end, then descend and require reaching the last element exactly. Time `O(n)`, space `O(1)`.
