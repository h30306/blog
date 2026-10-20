---
title: "LeetCode 3639: Minimum Time to Activate String"
summary: "LeetCode 3639 note: each new star adds (left distance) × (right distance) new substrings; or binary search on time"
description: "LeetCode 3639 record from 2025-08-03"
date: 2025-08-03
tags: ["medium", "binary-search", "counting", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-03
- Submissions: Accepted (first try)

## Approach

At each time step one position becomes `*`. Find the first time the number of substrings containing at least one `*` reaches `k`.

### My approach: how many new valid substrings each star adds

When a star lands at `idx`, find the nearest star to its left, `left`, and to its right, `right` (use `-1` and `n` if there is none).

**The new valid substrings** are exactly those that contain `idx` but no other star: start in `(left, idx]` and end in `[idx, right)`, giving `(idx - left) * (right - idx)`.

The first time the running total reaches `k` is the answer.

## My Solution

```python
import bisect

class Solution:
    def minTime(self, s: str, order: List[int], k: int) -> int:
        n = len(s)
        stars = [-1, n]                       # sorted star positions plus two sentinels
        total = 0
        for t, idx in enumerate(order):
            i = bisect.bisect_left(stars, idx)
            left, right = stars[i - 1], stars[i]
            total += (idx - left) * (right - idx)
            if total >= k:
                return t
            stars.insert(i, idx)
        return -1
```

My original code had a hand-written lower bound; this version uses `bisect`.

One concern: `list.insert` is `O(n)`, so the worst case is `O(n^2)`. In practice `insert` is a fast memory move and `n = 10^5` passes, but in an interview it is better to offer something sturdier.

## Sturdier: binary search on time

"Later time, more stars, more valid substrings", so `check(t)` = "after placing the first t+1 stars, are there at least `k` valid substrings" is monotonic, and `t` can be binary searched.

`check` counts the complement: all `n(n+1)/2` substrings minus the star-free ones. Star-free substrings come from each maximal star-free run; a run of length `L` contributes `L(L+1)/2`.

```python
class Solution:
    def minTime(self, s: str, order: List[int], k: int) -> int:
        n = len(s)
        total = n * (n + 1) // 2
        if total < k:
            return -1

        def count(t: int) -> int:
            star = [False] * n
            for idx in order[:t + 1]:
                star[idx] = True
            bad = run = 0
            for is_star in star:
                run = 0 if is_star else run + 1
                bad += run                    # star-free substrings ending here
            return total - bad

        lo, hi = 0, n - 1
        while lo < hi:
            mid = (lo + hi) // 2
            if count(mid) >= k:
                hi = mid
            else:
                lo = mid + 1
        return lo
```

`bad += run` adds the `run` star-free substrings that end at the current position; summing gives all star-free substrings.

## Complexity

| Approach | Time |
|---|---|
| Insert stars one by one | worst `O(n^2)` (`list.insert`) |
| Binary search on time | `O(n log n)` |

## Mistakes to Avoid

- Recounting all substrings after every star: `O(n^2)` or worse.
- Not checking first whether `k` exceeds the total number of substrings: if even all stars cannot reach it, return `-1`.
- Using `(idx - left + 1) * (right - idx + 1)`: the neighboring stars themselves must not be included.

## Interview Explanation

Each new star adds the substrings that contain it but no other star, which is the product of its distances to the nearest stars on each side, so I keep a sorted list of stars, find neighbors with bisect, and accumulate. Since insertion is `O(n)`, a sturdier option is binary search on time: more stars means more valid substrings, and `check` subtracts the star-free substrings from the total in `O(n)`, for `O(n log n)` overall.
