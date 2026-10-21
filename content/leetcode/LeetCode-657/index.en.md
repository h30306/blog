---
title: "LeetCode 657: Robot Return to Origin"
summary: "LeetCode 657 note: returning to the origin means as many U as D and as many L as R"
description: "LeetCode 657 record from 2022-08-29"
date: 2022-08-29
tags: ["easy", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-29
- Submissions: Accepted ×3

## Approach

Up cancels down and left cancels right, so it suffices that `U` and `D` counts match and `L` and `R` counts match ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) counting). Order does not matter.

## My Solution

```python
class Solution:
    def judgeCircle(self, moves: str) -> bool:
        return moves.count("U") == moves.count("D") and moves.count("L") == moves.count("R")
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Only the final position matters, not the order of moves.

## Interview Explanation

Returning home means vertical and horizontal moves cancel, so I compare the counts of U with D and L with R. Time `O(n)`.
