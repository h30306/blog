---
title: "LeetCode 1040: Moving Stones Until Consecutive II"
summary: "LeetCode 1040 note: max moves = total gaps minus the edge gap the first move wastes; min moves uses a length-n window holding the most stones, with a special case of 2 when n - 1 stones are already consecutive and one is far away"
description: "LeetCode 1040 record from 2026-01-18"
date: 2026-01-18
tags: ["medium", "sliding-window", "math", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-18
- Submissions: Accepted (first try)

## Approach

Sort first. Only endpoint stones may move, and a moved stone must not remain an endpoint.

### Maximum moves

The stones end up consecutive, so ideally each move fills one gap. The first move must take the leftmost or rightmost stone:

- Moving the leftmost wastes every gap between `stones[0]` and `stones[1]` for good.
- Moving the rightmost wastes the gaps between `stones[-1]` and `stones[-2]`.

After that, every move can fill just one slot inward. So max moves = `total gaps − min(left edge gap, right edge gap)`, with total gaps `(stones[-1] - stones[0] + 1) - n`.

### Minimum moves

The stones end up occupying `n` consecutive positions. A sliding window finds **the length-`n` range that already holds the most stones**; everything else moves in, `n - count` moves.

Special case: if the window has `n - 1` stones that are **already consecutive** (filling a length of exactly `n - 1`) and the last stone is far away, e.g. `[1, 2, 3, 4, 10]`. Moving 10 to 5 directly is illegal (it would still be an endpoint), so it takes 2 moves: 1 to 6, then 10 to 5.

## My Solution

```python
class Solution:
    def numMovesStonesII(self, stones: List[int]) -> List[int]:
        stones.sort()
        n = len(stones)

        total_gap = (stones[-1] - stones[0] + 1) - n
        max_moves = total_gap - min(stones[1] - stones[0] - 1, stones[-1] - stones[-2] - 1)

        min_moves = n
        left = 0
        for right in range(n):
            while stones[right] - stones[left] + 1 > n:
                left += 1                          # window width at most n
            count = right - left + 1
            if count == n - 1 and stones[right] - stones[left] + 1 == n - 1:
                min_moves = min(min_moves, 2)      # n - 1 consecutive, one far away
            else:
                min_moves = min(min_moves, n - count)
        return [min_moves, max_moves]
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Not subtracting the edge gap the first move wastes for the maximum.
- Missing the "`n - 1` already consecutive" special case for the minimum.

## Interview Explanation

For the maximum, the first move must take the leftmost or rightmost stone, wasting the gap beside it, and each later move fills one slot, so it is total gaps minus the smaller edge gap. For the minimum, a length-`n` sliding window finds the range already holding the most stones and the rest move in; but when `n - 1` stones are consecutive and one is far away, it takes 2 moves. Time `O(n log n)`.
