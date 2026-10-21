---
title: "LeetCode 665: Non-decreasing Array"
summary: "LeetCode 665 note: at a drop, lower nums[i-1] when possible, and only when nums[i] < nums[i-2] raise nums[i] instead; a second drop fails"
description: "LeetCode 665 record from 2025-07-22"
date: 2025-07-22
tags: ["medium", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-22
- Submissions: Wrong Answer ×2 → Runtime Error ×2 → Accepted

## Approach

When the scan meets `nums[i] < nums[i - 1]`, it may fix at most once ([Array]({{< relref "/algorithm/Array" >}}) Template 2). Which element changes?

- Prefer lowering `nums[i - 1]` to `nums[i]`: `nums[i]` stays put, which is best for what follows. This requires `nums[i - 2] <= nums[i]`, or a new drop appears between `i - 2` and `i - 1`.
- If `nums[i] < nums[i - 2]`, the only option is raising `nums[i]` to `nums[i - 1]`, then keep checking.

A second drop returns `False`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Only counted drops. `[3, 4, 1, 2]` has one drop, but lowering 4 below 1 goes under 3 and raising 1 to 4 exceeds 2, so the answer is `False`; it returned `True` |
| Attempt 2 | Added an "unfixable" check, but wrote `i > 1`, missing `i == 1`, so `[3, 4, 1, 2]` was still `True`; `nums[i + 2]` also went out of range, e.g. `[0, 2, 4, 0]` |
| Two REs | Changed to `i >= 1`, but the bound was still `i < len(nums) - 1`, so `[3, 4, 0]` read `nums[i + 2]` out of range |
| AC | Changed the bound to `i < len(nums) - 2` |

My AC version looked at both sides of the drop at once; here it is reorganized as "decide which element to change", which is easier to explain.

## Solution

```python
class Solution:
    def checkPossibility(self, nums: List[int]) -> bool:
        changed = False
        for i in range(1, len(nums)):
            if nums[i] < nums[i - 1]:
                if changed:
                    return False
                changed = True
                if i >= 2 and nums[i] < nums[i - 2]:
                    nums[i] = nums[i - 1]          # 只能把 nums[i] 拉高
        return True
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Counting drops is not enough; check whether the drop can be fixed.
- Make sure `i + 2` is in range before looking ahead.

## Interview Explanation

I scan the array; at a drop there is one change available: lower the previous element if that does not conflict with the one before it, otherwise raise the current element. A second drop returns `False`. Time `O(n)`.
