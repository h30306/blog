---
title: "LeetCode 3679: Minimum Discards to Balance Inventory"
summary: "LeetCode 3679 note: the rule already decides what must be discarded, so simulate it; the length-w window counts only kept arrivals, and discarded ones must not be subtracted when they leave"
description: "LeetCode 3679 record from 2025-12-24"
date: 2025-12-24
tags: ["medium", "sliding-window", "hash-table", "simulation", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-12-24
- Submissions: Wrong Answer ×3 → Accepted ×2

## Approach

The problem says an arrival that would exceed `m` **must** be discarded, so there is no choice to make: simulating the rule gives the minimum.

A fixed window of length `w` with a count map that tracks only **kept** arrivals:

1. On day `i`, first move day `i - w` out of the window, **subtracting only if that arrival was kept**.
2. If this type already has `m` in the window, discard it: answer +1.
3. Otherwise keep it and increment its count.

## My Attempts

| Version | Problem |
|---|---|
| Attempts 1–2 | Added the arrival to the counts first and incremented the answer when it exceeded `m`, but **never removed the discarded item from the counts**. For `[2, 2, 2]`, `w = 2`, `m = 1`: day 2 is discarded, day 3's window is days 2–3 with day 2 already discarded, so day 3 is kept and the answer is 1; these versions still counted day 2 and returned 2 |
| Attempt 3 | Took the discarded item back out of the counts, but when day `i - w` left the window it **subtracted again whether or not it was discarded**, so counts went too low. For `[3, 3, 1, 3, 3]`, `w = 2`, `m = 1`, the answer is 2; this returned 1 |
| Attempt 4, AC | On a discard, set `arrivals[i]` to `0` (a type that does not exist), so leaving the window subtracts from type 0 and leaves real counts alone |

## Solution

```python
class Solution:
    def minArrivalsToDiscard(self, arrivals: List[int], w: int, m: int) -> int:
        n = len(arrivals)
        kept = [False] * n
        cnt = Counter()
        discards = 0
        for i, t in enumerate(arrivals):
            if i >= w and kept[i - w]:
                cnt[arrivals[i - w]] -= 1         # only kept arrivals leave the counts
            if cnt[t] >= m:
                discards += 1                     # the rule forces a discard
            else:
                cnt[t] += 1
                kept[i] = True
        return discards
```

A `kept` array is more direct than overwriting `arrivals[i]` with 0, and it leaves the input unchanged.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Leaving discarded arrivals in the counts.
- Subtracting discarded arrivals again when they leave the window.

## Interview Explanation

The rule already decides which arrivals must be discarded, so simulation gives the minimum. I keep a length-`w` window whose counts include only kept arrivals: each day I first remove the arrival from `w` days ago (only if it was kept), then discard today's arrival if its type already has `m`, otherwise keep it. Time `O(n)`.
