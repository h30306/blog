---
title: "LeetCode 3800: Minimum Cost to Make Two Binary Strings Equal"
summary: "LeetCode 3800 note: split mismatches into two kinds; pair different kinds with a swap, same kinds with cross + swap, flip any leftover, and compare each against two flips"
description: "LeetCode 3800 record from 2026-01-04"
date: 2026-01-04
tags: ["medium", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-04
- Submissions: Accepted (first try)

## Approach

Only positions with `s[i] != t[i]` matter, in two kinds:

- `c0`: `s[i] = 0, t[i] = 1`.
- `c1`: `s[i] = 1, t[i] = 0`.

Fixes ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 4, pairing and parity):

| Case | How | Cost |
|---|---|---|
| One `c0` with one `c1` | swap the two cells within `s` | `min(swap, 2 × flip)` |
| Two of the same kind | cross one so it becomes the other kind, then swap | `min(cross + swap, 2 × flip)` |
| One left over | flip | `flip` |

Use as many different-kind pairs as possible (`min(c0, c1)`); the remaining `|c0 - c1|` same-kind cells pair up, and an odd one is flipped.

## My Solution

I originally listed three whole plans and took the minimum: flip everything; swap different kinds and flip the rest; swap different kinds, cross + swap same kinds, flip the leftover. Here it is reorganized as the cheapest option per pair type:

```python
class Solution:
    def minimumCost(self, s: str, t: str, flipCost: int, swapCost: int, crossCost: int) -> int:
        c = [0, 0]
        for a, b in zip(s, t):
            if a != b:
                c[int(a)] += 1
        pairs = min(c)                 # different-kind pairs
        rest = abs(c[0] - c[1])        # the rest are all one kind
        return (pairs * min(swapCost, 2 * flipCost)
                + rest // 2 * min(crossCost + swapCost, 2 * flipCost)
                + rest % 2 * flipCost)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Two same-kind cells cannot simply be swapped (swapping equal values does nothing); cross one first.
- Compare every pair type against two flips; flipping may be cheaper.

## Interview Explanation

I split mismatches by whether `s` holds 0 or 1. A pair of different kinds is fixed by one swap, a same-kind pair by crossing one then swapping, and a leftover by a flip; each option is compared with two flips. Time `O(n)`.
