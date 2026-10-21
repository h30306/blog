---
title: "LeetCode 292: Nim Game"
summary: "LeetCode 292 note: whoever faces a multiple of 4 stones loses, so the first player wins when n % 4 != 0"
description: "LeetCode 292 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "brainteaser", "minimax-algorithm", "game-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted (first try)

## Approach

Look at small cases first ([Math]({{< relref "/algorithm/Math" >}}) Template 4): with 1 to 3 stones you take them all and win; with 4, any move leaves the opponent 1 to 3, so you lose. In general, facing a multiple of 4, whatever `x` you take the opponent takes `4 - x`, keeping you on multiples of 4; otherwise you can take enough to leave the opponent on one.

## My Solution

```python
class Solution:
    def canWinNim(self, n: int) -> bool:
        return n % 4 != 0
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `n` reaches `2^31`, too large for DP in time or memory; find the pattern.

## Interview Explanation

Small cases show that facing a multiple of 4 loses, since the opponent can always make each round total 4, so the first player wins exactly when n is not a multiple of 4. Time `O(1)`.
