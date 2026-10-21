---
title: "LeetCode 1222: Queens That Can Attack the King"
summary: "LeetCode 1222 note: step outward from the king in eight directions; the first queen met in each direction can attack, with queens in a set for lookups"
description: "LeetCode 1222 record from 2025-07-30"
date: 2025-07-30
tags: ["medium", "array", "matrix", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-30
- Submissions: Accepted ×2

## Approach

Work backward from the king ([Array]({{< relref "/algorithm/Array" >}}) Template 5): walk each of the eight directions once; the first queen met can attack directly and anything beyond is blocked. Each direction takes at most 7 steps.

## My Solution

```python
class Solution:
    def queensAttacktheKing(self, queens: List[List[int]], king: List[int]) -> List[List[int]]:
        qs = set(map(tuple, queens))
        res = []
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                if dx == dy == 0:
                    continue
                x, y = king[0] + dx, king[1] + dy
                while 0 <= x < 8 and 0 <= y < 8:
                    if (x, y) in qs:
                        res.append([x, y])
                        break
                    x, y = x + dx, y + dy
        return res
```

I originally checked `[x, y] in queens` on a list; the second submission replaced a chain of `if i == -1` with adding the direction directly. The board is tiny, so both were fast; here it uses a set.

## Complexity

Time `O(q + 8 × 8)`, space `O(q)`.

## Mistakes to Avoid

- Stop at the first queen in each direction; the rest are blocked.

## Interview Explanation

I walk out from the king in eight directions; the first queen in each can attack and the rest are blocked. Queens go in a set for `O(1)` lookups. Time `O(q + 64)`.
