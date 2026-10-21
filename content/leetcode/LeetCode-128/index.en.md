---
title: "LeetCode 128: Longest Consecutive Sequence"
summary: "LeetCode 128 note: put everything in a set and count upward only from values whose x - 1 is absent; each value is seen at most twice, O(n)"
description: "LeetCode 128 record from 2022-10-27"
date: 2022-10-27
tags: ["medium", "array", "hash-table", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-27
- Submissions: Wrong Answer ×11 → Accepted ×3

## Approach

The problem requires `O(n)`, so no sorting. Put every value in a set ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})); `x` **starts** a run only if `x - 1` is absent, and then count upward `x + 1, x + 2, ...`. Each value is a start at most once and counted at most once, `O(n)` in total. The set also removes duplicates.

## My Attempts

This took 14 submissions, all "sort and find runs" versions (against the `O(n)` requirement):

- At first the run formula and initial values were wrong: `[7]` returned 0.
- After that the length was assigned as `max_length = end - start + 1`, **so a later, shorter run overwrote an earlier, longer one**: in `[4, 5, 7, 8, 3, 0]` the run `3, 4, 5` has length 3, but it returned 2.
- **Duplicates** were not handled: `[4, 3, 3]` returned 3 instead of 2. A `dup` counter subtracting repeats plus taking the `max` passed.

## Solution

```python
class Solution:
    def longestConsecutive(self, nums: List[int]) -> int:
        s = set(nums)
        best = 0
        for x in s:
            if x - 1 not in s:
                y = x
                while y + 1 in s:
                    y += 1
                best = max(best, y - x + 1)
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Count only from starts, or counting from every value is `O(n²)`.
- Iterate over the set so duplicates count once.
- Sorting is `O(n log n)`, against the requirement; a sorted version must also handle duplicates and take the `max` rather than overwrite.

## Interview Explanation

I put the numbers in a set; a value starts a run only when x - 1 is missing, and from each start I count upward until the run breaks, keeping the longest. Each value is touched at most twice, so time is `O(n)`.
