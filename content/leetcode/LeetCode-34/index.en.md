---
title: "LeetCode 34: Find First and Last Position of Element in Sorted Array"
summary: "LeetCode 34 note: two lower bounds: the first position >= target, and the first position >= target + 1 minus one"
description: "LeetCode 34 record from 2022-10-21"
date: 2022-10-21
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-21
- Submissions: Time Limit Exceeded ×5 → Runtime Error ×2 → Wrong Answer ×3 → Runtime Error → Wrong Answer ×2 → Accepted ×4 → Wrong Answer → Accepted ×2
- 2026-11-03 rewrite: Wrong Answer → Accepted ×2

## Approach

Both ends come from one lower-bound function ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1):

- Start: the first position `>= target`.
- End: the first position `>= target + 1`, minus one.

If the start is out of range or not `target`, it is absent.

## My Attempts

This took 20 submissions in 2022:

- The first versions used `while l < r` with `l = mid` / `r = mid`, so the interval stopped shrinking and looped forever (TLE).
- After fixing the loops, the final check `start < end` treated **a single occurrence (start equals end)** as absent: `[1]`, `target = 1` should be `[0, 0]`; it returned `[-1, -1]`, and one version used `low` instead of `high` for the end, returning `[0, 1]`.

## Solution

```python
class Solution:
    def searchRange(self, nums: List[int], target: int) -> List[int]:
        def lower(x):
            l, r = 0, len(nums)
            while l < r:
                mid = (l + r) // 2
                if nums[mid] < x:
                    l = mid + 1
                else:
                    r = mid
            return l
        start = lower(target)
        if start == len(nums) or nums[start] != target:
            return [-1, -1]
        return [start, lower(target + 1) - 1]
```

## 2026-11 Rewrite

Wrong once on 2026-11-03, then accepted once with each interval style:
1. Used the half-open `while left < right` with `right = mid`, but initialized `right` to `n - 1`. The search range became `[0, n - 1)`, so the end search could never return `n`. When the target is the last element, the first position `> target` is `n`: `[3]`, `target = 3` returned `[0, -1]`; the answer is `[0, 0]`.
2. Setting `right` to `n` passed.
3. In the afternoon I rewrote it with the closed `while left <= right` and `right = mid - 1`, taking the end directly from `right` (the last position `<= target`); also accepted.

It is the rule from "do not mix the two interval styles" in [Binary Search]({{< relref "/algorithm/Binary-Search" >}}): `right = n` for half-open, `right = n - 1` for closed.

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- With a single match the start equals the end, so `start < end` cannot test existence.
- Do not stop at a match; keep shrinking left (or right).

## Interview Explanation

One lower-bound function gives the start (first position not less than the target) and the end (first position not less than target + 1, minus one); if the start is not the target I return `[-1, -1]`. Two searches, `O(log n)`.
