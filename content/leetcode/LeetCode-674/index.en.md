---
title: "LeetCode 674: Longest Continuous Increasing Subsequence"
summary: "LeetCode 674 note: one pass that extends the run while strictly increasing and resets to 1 otherwise, updating the maximum after the loop too"
description: "LeetCode 674 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Wrong Answer ×2 → Runtime Error ×4 → Accepted ×2 → Wrong Answer ×2 → Accepted

## Approach

Walk each strictly increasing run ([Array]({{< relref "/algorithm/Array" >}}) Template 1): extend while `nums[i] > nums[i - 1]`, otherwise restart at 1. Updating the maximum every step avoids missing the final run. **Do not sort**; the run must be contiguous in the original order.

## My Attempts

This took 11 submissions:

- Attempt 1 **sorted first**, destroying the order that defines the runs, and returned a list.
- After switching to counting, one version compared `nums[i + 1]` and ran past the last index.
- Two versions updated the maximum only when a run broke, **so the final run was never counted**: `[0, 1]` returned 1 instead of 2. One more `max` after the loop passed.

## Solution

```python
class Solution:
    def findLengthOfLCIS(self, nums: List[int]) -> int:
        best = cur = 1
        for i in range(1, len(nums)):
            cur = cur + 1 if nums[i] > nums[i - 1] else 1
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Do not sort.
- If the maximum updates only when a run breaks, update once more after the loop.
- Compare `nums[i]` with `nums[i - 1]`; `nums[i + 1]` runs out of range.

## Interview Explanation

In one pass I extend the run when an element exceeds its predecessor and reset to 1 otherwise, updating the maximum each step so the final run counts. Time `O(n)`, space `O(1)`.
