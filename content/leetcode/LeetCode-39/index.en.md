---
title: "LeetCode 39: Combination Sum"
summary: "LeetCode 39 note: numbers may be reused, so the next level starts at i (not i + 1), which also avoids duplicates differing only in order"
description: "LeetCode 39 record from 2022-10-21"
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
- Submissions: Wrong Answer → Accepted ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Each number may be used any number of times, but order does not matter. In `dfs(start, remain, path)` the next level starts at **`i`** ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template): it may reuse the same number but never goes back, so `[2, 2, 3]` and `[3, 2, 2]` appear once. After sorting, `break` once `candidates[i] > remain`.

## My Attempts

- The first 2022-10-21 version restarted every level from the beginning, **recording every ordering of the same numbers**: `[2, 3]`, `target = 9` returned `[2, 2, 2, 3]` four times.
- In a 2022-10-30 rewrite one version put a 0 into the combination (`[[0, 5]]`) and another had a wrong recursion condition, returning nothing for `[2]`, `target = 8`.
- "The next number may not be smaller than the previous" passed on 2022-11-23.

## Solution

```python
class Solution:
    def combinationSum(self, candidates: List[int], target: int) -> List[List[int]]:
        candidates.sort()
        res = []
        def dfs(start, remain, path):
            if remain == 0:
                res.append(path[:])
                return
            for i in range(start, len(candidates)):
                if candidates[i] > remain:
                    break
                path.append(candidates[i])
                dfs(i, remain - candidates[i], path)
                path.pop()
        dfs(0, target, [])
        return res
```

## Complexity

Exponential time (depending on target and the smallest number); space `O(target / min)`.

## Mistakes to Avoid

- Start the next level at `i`: from 0 yields order-permuted duplicates, from `i + 1` forbids reuse.
- Record when `remain == 0`, never the empty combination.

## Interview Explanation

Numbers may be reused but order does not matter, so the next level starts at the same index, allowing reuse without going back; after sorting I stop once a number exceeds the remainder.
