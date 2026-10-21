---
title: "LeetCode 42: Trapping Rain Water"
summary: "LeetCode 42 note: each cell holds min(tallest on the left, tallest on the right) - its own height; use prefix and suffix maxima or two pointers"
description: "LeetCode 42 record from 2022-10-27"
date: 2022-10-27
tags: ["hard", "array", "two-pointers", "dynamic-programming", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2022-10-27
- Submissions: Wrong Answer ×6 → Runtime Error ×2 → Time Limit Exceeded → Wrong Answer → Accepted ×5

## Approach

The water above cell `i` is set by **the shorter of the tallest walls on each side**: `water[i] = min(leftMax[i], rightMax[i]) - height[i]`, where both maxima include the cell itself, so the value is never negative.

- Prefix and suffix maxima ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 6): build both arrays, `O(n)` space.
- Two pointers ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): keep `lmax` and `rmax`; whichever side has the smaller maximum already knows its water level (the other side has a taller wall), so add it and move inward, `O(1)` space.

## My Attempts

This took 15 submissions in one evening:

- The first six scanned for a "left wall, right wall" basin and computed areas on a fall followed by a rise; they mishandled many shapes, returning 0 even for `[4, 3, 4]`, whose answer is 1.
- Next, computing `max(height[:i])` and `max(height[i + 1:])` per cell gave correct answers in `O(n²)` and timed out.
- With prefix and suffix maxima, the first version started the prefix loop at 1, **leaving cell 0 out of the maximum**: `[4, 3, 4]` still returned 0. Starting at 0 passed, and I finally switched to the two-pointer version.

## Solution

```python
class Solution:
    def trap(self, height: List[int]) -> int:
        l, r = 0, len(height) - 1
        lmax = rmax = water = 0
        while l < r:
            lmax = max(lmax, height[l])
            rmax = max(rmax, height[r])
            if lmax <= rmax:
                water += lmax - height[l]
                l += 1
            else:
                water += rmax - height[r]
                r -= 1
        return water
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Case analysis on "find a basin and compute its area" rarely covers every shape; compute the level per cell instead.
- Rescanning both sides for every cell is `O(n²)` and times out.
- The prefix maximum must start from cell 0.

## Interview Explanation

Each cell holds the shorter of the tallest walls on its two sides minus its height. With two pointers I track both maxima; the side with the smaller one has a settled level, so I add it and move inward. Time `O(n)`, space `O(1)`.
