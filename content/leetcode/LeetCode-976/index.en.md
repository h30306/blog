---
title: "LeetCode 976: Largest Perimeter Triangle"
summary: "LeetCode 976 note: after sorting, check consecutive triples from the largest down; the first with a + b > c gives the largest perimeter"
description: "LeetCode 976 record from 2026-01-29"
date: 2026-01-29
tags: ["easy", "math", "greedy", "sorting", "geometry", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-29
- Submissions: Wrong Answer → Time Limit Exceeded → Accepted ×3

## Approach

After sorting, sides `a <= b <= c` form a triangle ⇔ `a + b > c`.

With the longest side fixed at `c = nums[i]`, the best other two sides are **the two right before it**, `nums[i - 1]` and `nums[i - 2]`: the largest values below `c`, with the largest sum, most likely to exceed `c` and giving the largest perimeter. If even they fail, smaller ones fail too, so the longest side must move down.

So check consecutive triples from the largest down; the first valid one is the answer.

## My Attempts

The first two versions used two pointers, one for the longest side and one for the other two, and the pointer moves got tangled:

- Attempt 1 could count a non-triangle. For `[1, 1, 3, 4]` no three sides form a triangle, so the answer is 0; it returned 3.
- Attempt 2 changed the condition, but in some cases neither pointer moved; `[8, 8, 1, 7]` loops forever, TLE.

Once it is clear that "with the longest side fixed, the two largest others are best", one loop suffices.

## Solution

```python
class Solution:
    def largestPerimeter(self, nums: List[int]) -> int:
        nums.sort()
        for i in range(len(nums) - 1, 1, -1):
            if nums[i - 2] + nums[i - 1] > nums[i]:
                return nums[i - 2] + nums[i - 1] + nums[i]
        return 0
```

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- The triangle inequality is strict.
- No two pointers needed: with the longest side fixed, its two neighbors are always best.

## Interview Explanation

After sorting, the best partners for a fixed longest side are the two right before it, since their sum is largest. So I check consecutive triples from the largest down, and the first with `a + b > c` gives the largest perimeter; if none does, return 0. Time `O(n log n)`.
