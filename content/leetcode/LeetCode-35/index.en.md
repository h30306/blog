---
title: "LeetCode 35: Search Insert Position"
summary: "LeetCode 35 note: find the first position >= target (lower bound); a half-open [l, r) needs r = mid, not r = mid - 1"
description: "LeetCode 35 record from 2022-05-11"
date: 2022-05-11
tags: ["easy", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-05-11
- Submissions: Wrong Answer → Accepted → Runtime Error ×2 → Accepted → Wrong Answer → Time Limit Exceeded → Wrong Answer ×2 → Runtime Error → Accepted ×2

## Approach

The insert position is the first index with a value `>= target`, i.e. the lower bound ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). With a half-open `[l, r)`: if `nums[mid] < target` the answer is to the right, `l = mid + 1`; otherwise `mid` may be the answer, `r = mid`.

## My Attempts

This took 12 submissions, mostly from mixing interval styles:

- At first it lacked a return value and computed `mid` with `/` (TypeError).
- A November 2022 rewrite used a half-open `right = len(nums)` but wrote `right = mid - 1`, skipping a possible answer: `[0, 7]`, `target = 5` should be 1; it returned 0.

## Solution

```python
class Solution:
    def searchInsert(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums)
        while l < r:
            mid = (l + r) // 2
            if nums[mid] < target:
                l = mid + 1
            else:
                r = mid
        return l
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- Do not mix interval styles: a half-open `r = len(nums)` goes with `while l < r` and `r = mid`.

## Interview Explanation

The answer is the first position not less than the target, so I run a half-open lower bound: go right when the middle is smaller, otherwise shrink the right bound to the middle. The final `l` is the answer. Time `O(log n)`.
