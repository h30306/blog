---
title: "LeetCode 216: Combination Sum III"
summary: "LeetCode 216 note: use only 1 to 9, each at most once, choosing exactly k numbers that sum to n"
description: "LeetCode 216 record from 2022-11-12"
date: 2022-11-12
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
First Attempt: 2022-11-12
- Submissions: Wrong Answer → Accepted ×2

## Approach

The same combination backtracking as LC 77 ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template) with candidates fixed to **1 through 9**, the next level starting at `i + 1`. Prune when the count exceeds `k` or the sum exceeds `n`.

## My Attempts

Attempt 1 drew candidates from `range(min_number + 1, n + 1)`, **1 to `n` instead of 1 to 9**: `k = 3`, `n = 24` returned combinations like `[1, 2, 21]`. Restricting to 1 through 9 passed.

## Solution

```python
class Solution:
    def combinationSum3(self, k: int, n: int) -> List[List[int]]:
        res = []
        def dfs(start, remain, path):
            if len(path) == k:
                if remain == 0:
                    res.append(path[:])
                return
            for x in range(start, 10):
                if x > remain:
                    break
                path.append(x)
                dfs(x + 1, remain - x, path)
                path.pop()
        dfs(1, n, [])
        return res
```

## Complexity

Time `O(C(9, k) · k)`, space `O(k)`.

## Mistakes to Avoid

- Candidates are 1 to 9 only, not 1 to `n`.

## Interview Explanation

With candidates 1 to 9 each used once, I backtrack combinations starting each level above the current number, check the sum once k are chosen, and prune overshoots.
