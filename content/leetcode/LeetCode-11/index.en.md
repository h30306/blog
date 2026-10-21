---
title: "LeetCode 11: Container With Most Water"
summary: "LeetCode 11 note: start pointers at both ends and always move the shorter side; moving the taller side only narrows the width without raising the height"
description: "LeetCode 11 record from 2022-10-20"
date: 2022-10-20
tags: ["medium", "array", "two-pointers", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-20
- Submissions: Runtime Error → Time Limit Exceeded → Accepted ×6 → Wrong Answer ×2 → Accepted

## Approach

The area is `width × the shorter height` ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1). Starting at both ends maximizes width. Each step moves one side:

- Moving **the taller** side narrows the width while the shorter side still caps the height, so the area cannot grow.
- So move **the shorter** side, the only chance of finding something taller.

## My Attempts

A November 2022 rewrite wrote `if r > l: l += 1`, testing positions rather than heights, so it always moved left: `[3, 5, 1]` should be 3 (between 3 and 5); it returned 2.

## Solution

```python
class Solution:
    def maxArea(self, height: List[int]) -> int:
        l, r, best = 0, len(height) - 1, 0
        while l < r:
            best = max(best, (r - l) * min(height[l], height[r]))
            if height[l] < height[r]:
                l += 1
            else:
                r -= 1
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Choose which side to move by **height**, not position.

## Interview Explanation

From both ends I compute the area and move the shorter side, since moving the taller one only reduces width without raising the height. Each position is seen once, `O(n)`.
