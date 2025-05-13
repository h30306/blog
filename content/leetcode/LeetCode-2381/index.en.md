---
title: "LeetCode 2381: Shifting Letters II"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-20
tags: ["LeetCode", "medium", "difference array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-20
- Total time: 30:00.00

## Intuition

This is a prefix sum problem. My first thought was to create a prefix sum array of the same length as `s` and iterate through the `shifts`, storing the forward or backward shift information into `ps` at each position. It looked like this:

```
for (start, end, direction) in shifts:
    for i in range(start, end+1):
        if direction: # forward
            ps[i] += 1
        else:
            ps[i] -= 1
```

But this is an `O(n^2)` operation. When the length of `s` is large (up to `5 * 10^4` per the constraints), it will cause a TLE. Then I realized this is actually a **difference array** problem. I can just store the index changes for forward or backward shifts to avoid the `O(n^2)` time complexity.

## Approach

### TLE Solution

```python
class Solution:
    def shiftingLetters(self, s: str, shifts: List[List[int]]) -> str:

        n = len(s)
        ps = [0]*n

        for (start, end, direction) in shifts:
            for i in range(start, end+1):
                if direction: # forward
                    ps[i] += 1
                else:
                    ps[i] -= 1

        result = []
        for i in range(n):
            diff_with_a = ord(s[i]) - ord('a')
            diff = (ps[i] % 26 + diff_with_a) % 26
            
            result.append(chr(ord('a') + diff))

        return "".join(result)
```

### Optimized Solution Using Difference Array

```python
class Solution:
    def shiftingLetters(self, s: str, shifts: List[List[int]]) -> str:

        n = len(s)
        ps = [0]*(n+1)

        for (start, end, direction) in shifts:
            if direction: # forward
                ps[start] += 1
                if end < n:
                    ps[end+1] -= 1
            else: # backward
                ps[start] -= 1
                if end < n:
                    ps[end+1] += 1

        result = []
        count = 0
        for i in range(n):
            count += ps[i]
            diff_with_a = ord(s[i]) - ord('a')
            diff = (count % 26 + diff_with_a) % 26
            
            result.append(chr(ord('a') + diff))

        return "".join(result)
```

## Findings
First time solving difference array problem

## Encountered Problems

I encountered a problem when handling the `ord()` values. I initially didn’t separate `'a'` from the difference, which caused the character to go beyond `'z'` after applying the shift.
