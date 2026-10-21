---
title: "LeetCode 888: Fair Candy Swap"
summary: "LeetCode 888 note: equal sums after swapping x and y means y = x + (sumB - sumA) / 2; put B in a set and check each x from A"
description: "LeetCode 888 record from 2022-09-21"
date: 2022-09-21
tags: ["easy", "array", "hash-table", "binary-search", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-21
- Submissions: Time Limit Exceeded → Wrong Answer ×5 → Runtime Error → Time Limit Exceeded ×2 → Wrong Answer → Accepted → Wrong Answer ×3 → Accepted → Wrong Answer → Runtime Error → Accepted

## Approach

After Alice gives `x` and receives `y`, the totals match: `sumA - x + y = sumB - y + x`, so `y = x + (sumB - sumA) / 2` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Put Bob's boxes in a set and check `y` for each `x`.

## My Attempts

This took 18 submissions:

- Attempt 1 recomputed `sum(bobSizes)` on every iteration and searched a list with `in`, hitting TLE.
- Later attempts walked two pointers and adjusted them, never getting the conditions right: indices went out of range or no answer was found, e.g. `[4, 8]` and `[4]` (answer `[8, 4]`). Deriving the formula with a set finally worked.

## Solution

```python
class Solution:
    def fairCandySwap(self, aliceSizes: List[int], bobSizes: List[int]) -> List[int]:
        delta = (sum(bobSizes) - sum(aliceSizes)) // 2
        bob = set(bobSizes)
        for x in aliceSizes:
            if x + delta in bob:
                return [x, x + delta]
```

## Complexity

Time `O(m + n)`, space `O(n)`.

## Mistakes to Avoid

- Derive the formula first instead of recomputing sums inside the loop (`O(n)` each).
- An answer is guaranteed, so the difference is even.

## Interview Explanation

Equal totals after the swap give `y = x + (sumB - sumA) / 2`, so I put Bob's sizes in a set and look up `y` for each `x`. Time `O(m + n)`.
