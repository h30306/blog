---
title: "LeetCode 821: Shortest Distance to a Character"
summary: "LeetCode 821 note: one left-to-right pass for the distance to the nearest c on the left, then a right-to-left pass taking the minimum"
description: "LeetCode 821 record from 2022-09-15"
date: 2022-09-15
tags: ["easy", "array", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-15
- Submissions: Wrong Answer → Accepted

## Approach

Each answer is the smaller of the distances to the nearest `c` on the left and on the right. Scan left to right remembering the last `c` seen, then right to left doing the same and taking the minimum. Before any `c` is seen, treat its position as infinitely far.

## My Attempts

Attempt 1's second pass (right to left) **forgot the `+ 1`** and also lacked the `return`, so it returned `None`; fixing both passed.

## Solution

```python
class Solution:
    def shortestToChar(self, s: str, c: str) -> List[int]:
        n = len(s)
        res = [0] * n
        last = float("-inf")
        for i in range(n):
            if s[i] == c:
                last = i
            res[i] = i - last
        last = float("inf")
        for i in range(n - 1, -1, -1):
            if s[i] == c:
                last = i
            res[i] = min(res[i], last - i)
        return res
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- Scan both directions; one pass misses a closer `c` on the other side.
- Distances carried from the right need `+ 1`.

## Interview Explanation

One left-to-right pass gives the distance to the nearest `c` on the left, a right-to-left pass the nearest on the right, and I keep the smaller. Time `O(n)`.
