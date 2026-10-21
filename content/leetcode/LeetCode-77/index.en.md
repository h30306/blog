---
title: "LeetCode 77: Combinations"
summary: "LeetCode 77 note: choose k of 1 to n with dfs(start, path), picking the next only after start to avoid duplicate combinations"
description: "LeetCode 77 record from 2022-10-26"
date: 2022-10-26
tags: ["medium", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-26
- Submissions: Runtime Error ×3 → Accepted ×3

## Approach

Combinations ignore order, so each choice starts after the previous one ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template): `dfs(start, path)` records `path` once it has length `k`. Prune when too few numbers remain: `i` only needs to reach `n - (k - len(path)) + 1`.

## My Attempts

This took 6 submissions:

- The first 2022-10-26 version called the helper without `self.` (NameError), and the helper itself **`return`ed the recursive call inside the `for` loop**, exploring only the first branch; `range(0, now[-1])` raised IndexError for an empty `now`.
- A month later a rewrite requiring each next number to exceed the previous one passed.

## Solution

```python
class Solution:
    def combine(self, n: int, k: int) -> List[List[int]]:
        res = []
        def dfs(start, path):
            if len(path) == k:
                res.append(path[:])
                return
            for i in range(start, n - (k - len(path)) + 2):
                path.append(i)
                dfs(i + 1, path)
                path.pop()
        dfs(1, [])
        return res
```

## Complexity

Time `O(k · C(n, k))`, space `O(k)` excluding output.

## Mistakes to Avoid

- Call a helper method through `self.`, or nest it.
- `return`ing the recursive call inside the `for` loop explores only the first branch.
- Record a copy, `path[:]`.

## Interview Explanation

Order does not matter, so I backtrack choosing each next number after the previous one, recording when k are chosen and pruning when too few numbers remain. Time `O(k · C(n, k))`.
