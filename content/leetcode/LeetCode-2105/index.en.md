---
title: "LeetCode 2105: Watering Plants II"
summary: "LeetCode 2105 note: Alice from the left and Bob from the right, simulated with converging pointers; when they meet at the same plant, whoever has more water waters it"
description: "LeetCode 2105 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: Accepted (first try)

## Approach

Both start together and every plant takes the same time, so at step `t` Alice is at `t` and Bob at `n - 1 - t`: converging pointers.

Each step:

- With enough water, water the plant; otherwise refill first (count +1), then water.
- `left == right` (the middle plant of an odd-length row): whoever has more water waters it, Alice on a tie. If that person has enough there is no refill; otherwise one refill.

## My Solution

```python
class Solution:
    def minimumRefill(self, plants: List[int], capacityA: int, capacityB: int) -> int:
        a, b = capacityA, capacityB
        left, right = 0, len(plants) - 1
        refills = 0
        while left < right:
            if a < plants[left]:
                a = capacityA
                refills += 1
            a -= plants[left]
            if b < plants[right]:
                b = capacityB
                refills += 1
            b -= plants[right]
            left += 1
            right -= 1
        if left == right and max(a, b) < plants[left]:
            refills += 1                       # middle plant: refill only if the fuller can is short
        return refills
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Refilling with `a = capacityA` and forgetting to subtract this plant's water.
- Letting both water the middle plant, or always giving it to Alice.

## Interview Explanation

They move at the same speed, so Alice from the left and Bob from the right are converging pointers. At each step, if the water is not enough, refill first and count it. With an odd length they meet in the middle, where the one with more water waters it, and a refill is needed only if even that is not enough. Time `O(n)`.
