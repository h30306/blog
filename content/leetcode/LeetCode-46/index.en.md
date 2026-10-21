---
title: "LeetCode 46: Permutations"
summary: "LeetCode 46 note: each level picks one unused number, marked in a used array, and records when the path is full"
description: "LeetCode 46 record from 2022-10-21"
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
- Submissions: Accepted → Memory Limit Exceeded → Runtime Error → Wrong Answer → Accepted ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer → Accepted

## Approach

Permutations depend on order, so each level may pick any unused number ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template). Mark it in `used[i]`, checking before choosing and clearing on backtrack. Record a copy when `path` has length `n`.

## My Attempts

This took 12 submissions; the first passed (filtering out numbers equal to the current one), and each rewrite then slipped on details:

- An unclosed parenthesis, and putting the index `i` rather than the value `nums[i]` into the answer (`[3]` returned `[[0]]`).
- Forgetting to call `dfs` or to `return`, and wrapping the answer in an extra list (`[[[3]]]`).

## Solution

```python
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        res, path = [], []
        used = [False] * len(nums)
        def dfs():
            if len(path) == len(nums):
                res.append(path[:])
                return
            for i, x in enumerate(nums):
                if used[i]:
                    continue
                used[i] = True
                path.append(x)
                dfs()
                path.pop()
                used[i] = False
        dfs()
        return res
```

## Complexity

Time `O(n · n!)`, space `O(n)` excluding output.

## Mistakes to Avoid

- Put the value `nums[i]` into `path`, not the index `i`.
- Filtering used values by `j != i` works only without duplicates; marking indices is safer.

## Interview Explanation

Order matters, so each level may pick any unused number; I mark it in a used array, recurse, unmark, and record a copy when the path is full. Time `O(n · n!)`.
