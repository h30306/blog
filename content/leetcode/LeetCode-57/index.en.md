---
title: "LeetCode 57: Insert Interval"
summary: "LeetCode 57 note: split the intervals into three groups, entirely left, entirely right and overlapping, and merge the overlapping ones into one"
description: "LeetCode 57 record from 2022-10-22"
date: 2022-10-22
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
First Attempt: 2022-10-22
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted

## Approach

The intervals are sorted and disjoint, so each relates to the new `[s, e]` in one of three ways:

- `end < s`: entirely left, kept as is.
- `start > e`: entirely right, kept as is.
- Otherwise they overlap: set `s = min(s, start)` and `e = max(e, end)`.

The answer is `left + [[s, e]] + right`. Starting `s` and `e` from the new interval keeps it correct when nothing overlaps or the list is empty.

## My Attempts

This took 12 submissions:

- The early versions modified `intervals` in place from the back, popping while checking, with ever more cases: an empty `intervals` returned `[]` (should be `[[5, 8]]`), and inserting `[0, 4]` into `[[2, 5]]` also returned `[]`.
- Switching to left / overlap / right, I first wrote `left += i`, **splicing an interval's two numbers into the list**: it returned `[[0, 4], 5, 9]`. `left += [i]` passed.
- A 2022-10-31 rewrite started the merged range at `inf` and `-inf` without the new interval itself and used `min` for the right end: an empty `intervals` returned `[[inf, -inf]]`.

## Solution

```python
class Solution:
    def insert(self, intervals: List[List[int]], newInterval: List[int]) -> List[List[int]]:
        s, e = newInterval
        left, right = [], []
        for a, b in intervals:
            if b < s:
                left.append([a, b])
            elif a > e:
                right.append([a, b])
            else:
                s, e = min(s, a), max(e, b)
        return left + [[s, e]] + right
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Start the merged range from the new interval itself, not from `inf`.
- Take the `max` of right ends, not the `min`.
- `left += [a, b]` splices two numbers into the list; use `append`.
- An empty list returns `[newInterval]`.

## Interview Explanation

Since the intervals are sorted and disjoint, I classify each as entirely left, entirely right or overlapping, merge the overlapping ones into the new interval, and concatenate. Time `O(n)`.
