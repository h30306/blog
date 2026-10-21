---
title: "LeetCode 3842: Toggle Light Bulbs"
summary: "LeetCode 3842 note: toggle membership in a set, or keep bulbs appearing an odd number of times, then sort"
description: "LeetCode 3842 record from 2026-02-16"
date: 2026-02-16
tags: ["easy", "hash-table", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-02-16
- Submissions: Wrong Answer → Accepted

## Approach

Each appearance toggles once, so the bulbs left on are those appearing an **odd** number of times. Simulate with a set: remove if present, add if not ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). The answer must be ascending.

## My Attempts

Attempt 1 returned `list(light)`, but **a set has no order**. For `[8, 1]` the answer is `[1, 8]`; it returned `[8, 1]`. Adding `sorted` passed.

## Solution

```python
class Solution:
    def toggleLightBulbs(self, bulbs: List[int]) -> List[int]:
        on = set()
        for b in bulbs:
            on ^= {b}                      # remove if present, add if not
        return sorted(on)
```

## Complexity

Time `O(n + k log k)` with `k` bulbs on at the end, space `O(k)`.

## Mistakes to Avoid

- Converting a set to a list does not guarantee order; sort when the problem asks.

## Interview Explanation

Every appearance toggles, so bulbs appearing an odd number of times stay on. I toggle with a symmetric difference on a set and return it sorted. Time `O(n log n)`.
