---
title: "LeetCode 2300: Successful Pairs of Spells and Potions"
summary: "LeetCode 2300 note: sort potions, bisect a threshold per spell, and compute the threshold with integer ceil to avoid float error"
description: "LeetCode 2300 record from 2025-10-08"
date: 2025-10-08
tags: ["medium", "binary-search", "sorting", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-10-08
- Submissions: Time Limit Exceeded → Accepted

## Approach

A spell of strength `s` and a potion of strength `p` succeed when `s * p >= success`, i.e. `p >= success / s`.

Sort the potions; for each spell, find the first position with value `>= threshold`. Every potion from there on succeeds, so the count is `m - position`.

## My Attempt: scanning every potion for every spell

```python
for spell in spells:
    min_potion = success / spell
    res.append(sum(map(lambda x: x >= min_potion, potions)))
```

`O(n * m)` with both up to `10^5`, so it timed out.

The accepted version sorted the potions and used a hand-written lower bound.

## Solution

```python
import bisect

class Solution:
    def successfulPairs(self, spells: List[int], potions: List[int], success: int) -> List[int]:
        potions.sort()
        m = len(potions)
        res = []
        for s in spells:
            need = (success + s - 1) // s            # ceil(success / s), integers only
            res.append(m - bisect.bisect_left(potions, need))
        return res
```

My original code used float division `success / spell` as the threshold. It happened to work within these limits, but `success` goes up to `10^10`, so **integer ceil is safer**: since `p` is an integer, `p >= success / s` is equivalent to `p >= ceil(success / s)`.

### Alternative: sort the spells too and use two pointers

Stronger spells have lower thresholds, so after sorting the spells, the potion boundary only moves left and one pointer can sweep it; sorting dominates the cost. Remember to put the answers back in the original order.

## Complexity

Time `O((n + m) log m)`, space `O(1)` excluding the output and the sort.

## Mistakes to Avoid

- Scanning all potions for each spell: `O(n * m)`.
- Using float division for the threshold: it can lose precision with large numbers.
- In Java/C++, `s * p` overflows: use `long`, or compare against the threshold instead.

## Interview Explanation

The condition is `p >= success / s`, so I sort the potions and, for each spell, compute the integer threshold `ceil(success / s)` and use `bisect_left` to find the first potion at or above it; every potion after that succeeds. The threshold is computed with integers to avoid float error. Time `O((n + m) log m)`.
