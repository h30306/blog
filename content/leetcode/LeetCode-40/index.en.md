---
title: "LeetCode 40: Combination Sum II"
summary: "LeetCode 40 note: each number is used once and duplicates exist, so sort, start the next level at i + 1, and skip equal values within a level"
description: "LeetCode 40 record from 2022-10-21"
date: 2022-10-21
tags: ["medium", "array", "backtracking"]
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
- Submissions: Wrong Answer ×2 → Runtime Error → Time Limit Exceeded ×2 → Runtime Error ×2 → Accepted → Runtime Error ×2 → Accepted → Wrong Answer ×3 → Runtime Error → Accepted → Wrong Answer ×3 → Accepted

## Approach

Two differences from LC 39 ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 4):

1. Each number is used once: the next level starts at `i + 1`.
2. `candidates` has duplicates: after sorting, skip `candidates[i] == candidates[i - 1]` within one level (when `i > start`), since equal choices at one level grow identical subtrees.

The skip applies **within a level** only; equal values on different levels are fine, as in `[1, 1, 6]`.

## My Attempts

This took 20 submissions in three rounds:

- 2022-10-21: attempt 1 started the next level at `i`, **reusing the same number**: `[1]`, `target = 6` returned `[[1, 1, 1, 1, 1, 1]]`; with `i + 1` there was no deduplication, so `[3, 3, 5]`, `target = 8` returned `[3, 5]` twice; deduplicating with `not in self.res` then timed out twice.
- A 2022-10-30 rewrite hit the same missing deduplication three more times.
- 2022-11-23: one version returned early when `candidates` was empty, **before recording a combination completed by the last number**: `[1]`, `target = 1` returned nothing. Adding "skip equal values within a level" finally passed.

## Solution

```python
class Solution:
    def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        res = []
        def dfs(start, remain, path):
            if remain == 0:
                res.append(path[:])
                return
            for i in range(start, len(candidates)):
                if i > start and candidates[i] == candidates[i - 1]:
                    continue
                if candidates[i] > remain:
                    break
                path.append(candidates[i])
                dfs(i + 1, remain - candidates[i], path)
                path.pop()
        dfs(0, target, [])
        return res
```

## Complexity

Time `O(2^n)`, space `O(n)`.

## Mistakes to Avoid

- Start the next level at `i + 1`; each number is used once.
- Deduplicate within a level (`i > start`), after sorting.
- Deduplicating with `not in res` times out.
- Check `remain == 0` before "no candidates left", or a combination completed by the last number is missed.

## Interview Explanation

Each number is used once and duplicates exist, so I sort, start the next level at i + 1, skip a value equal to the previous one within a level to avoid identical combinations, and stop once a number exceeds the remainder.
