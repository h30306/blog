---
title: "LeetCode 441: Arranging Coins"
summary: "LeetCode 441 note: find the largest k with k(k + 1) / 2 <= n; when moving right write l = mid + 1 or the search gets stuck"
description: "LeetCode 441 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Accepted → Time Limit Exceeded → Accepted

## Approach

Filling `k` rows takes `k(k + 1) / 2` coins, increasing in `k`; find the largest `k` that fits within `n` ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 2). With a closed interval, `r` ends on the last valid value.

## My Attempts

The first submission passed; when practicing binary search afterward I wrote `while l < r` with `l = mid`, so with `r = l + 1` the `mid` kept equaling `l` and it looped forever (TLE), e.g. `n = 8`.

## Solution

```python
class Solution:
    def arrangeCoins(self, n: int) -> int:
        l, r = 0, n
        while l <= r:
            mid = (l + r) // 2
            if mid * (mid + 1) // 2 <= n:
                l = mid + 1
            else:
                r = mid - 1
        return r
```

## Complexity

Time `O(log n)`, space `O(1)`. A formula with `isqrt(8n + 1)` also works.

## Mistakes to Avoid

- With `while l < r` and `l = mid`, `mid` rounds down and `l` may never move, looping forever.

## Interview Explanation

`k` full rows need `k(k+1)/2` coins, so I binary search the largest `k` that fits. Time `O(log n)`.
