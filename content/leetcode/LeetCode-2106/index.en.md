---
title: "LeetCode 2106: Maximum Fruits Harvested After at Most K Steps"
summary: "LeetCode 2106 note: the harvest is always a contiguous block of fruits; covering [L, R] takes (R - L) + min(|start - L|, |R - start|) steps, so slide a window over the fruits array"
description: "LeetCode 2106 record from 2026-01-12"
date: 2026-01-12
tags: ["hard", "sliding-window", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-12
- Submissions: Wrong Answer → Accepted ×2

## Approach

The walked range is always a contiguous interval `[L, R]`, and the harvest is every fruit in it.

The fewest steps to cover `[L, R]`: go to one side first, then turn back to the other,

```text
steps = (R - L) + min(|start - L|, |R - start|)
```

This also holds when `start` is outside the interval (for `start < L` it gives `R - start`).

Steps never decrease as `R` grows, so slide a window over the **fruits array**: add `fruits[right]` on the right, shrink the left while steps exceed `k`, and track the largest window total.

## My Attempts

My version slid over **coordinates**: from `startPos - k` to `startPos + k`, then once more in reverse, each time computing how far the other side could reach after turning back. Attempt 1 shrank only one step with an `if` when turning back, not far enough. For `fruits = [[3, 1], [7, 3]]`, `startPos = 5`, `k = 5`, taking both sides needs 6 steps, so only the 3 on the right can be taken and the answer is 3; this returned 4.

Switching to `while` passed, but the coordinate range is `2k`, slower than sliding over the fruits (1.4 seconds).

## Solution

```python
class Solution:
    def maxTotalFruits(self, fruits: List[List[int]], startPos: int, k: int) -> int:
        def steps(lo: int, hi: int) -> int:        # fewest steps to cover [lo, hi]
            return (hi - lo) + min(abs(startPos - lo), abs(hi - startPos))

        left = total = best = 0
        for right, (pos, amount) in enumerate(fruits):
            total += amount
            while left <= right and steps(fruits[left][0], pos) > k:
                total -= fruits[left][1]
                left += 1
            best = max(best, total)
        return best
```

`left` may pass `right` (even `fruits[right]` alone is unreachable); the window is then empty and `total` is 0.

## Complexity

Time `O(n)` for `n` fruit positions, space `O(1)`.

## Mistakes to Avoid

- Considering only "left first" or only "right first": take the smaller of the two.
- Sliding over coordinates: the range is `2k`, unrelated to the number of fruits.

## Interview Explanation

The harvest is always a contiguous block of fruits. Covering `[L, R]` takes the interval length plus the distance from the start to the nearer end, going there first and turning back. That cost never decreases as the right end grows, so I slide a window over the fruits array, shrinking the left when steps exceed `k`, and track the largest total. Time `O(n)`.
