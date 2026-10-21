---
title: "LeetCode 131: Palindrome Partitioning"
summary: "LeetCode 131 note: each level cuts a palindrome from the front of the remaining string, trying every length from 1 to the whole remainder"
description: "LeetCode 131 record from 2022-10-30"
date: 2022-10-30
tags: ["medium", "string", "dynamic-programming", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-30
- Submissions: Wrong Answer ×3 → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted

## Approach

Partition backtracking ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) Variation 5): `dfs(start, path)` tries `s[start:end]` as the next piece with `end` from `start + 1` to **`len(s)`** (including the whole remainder), recursing only on palindromes. Record when `start == len(s)`. Precomputing `isPal[i][j]` with DP avoids repeated checks.

## My Attempts

This took 12 submissions with one core bug:

- Cut lengths were `range(1, len(s))`, **so the whole remainder was never a piece** and the last piece could never be cut: `"b"` returned `[]` and `"bab"` lacked `["bab"]`. Attempt 1 also continued from `s[i + 1:]` (skipping a character) and never called `dfs`.
- Rewrites in 2022-10 and 2022-11 failed at the same spot; `range(1, len(s) + 1)` finally passed.

## Solution

```python
class Solution:
    def partition(self, s: str) -> List[List[str]]:
        res, path = [], []
        def dfs(start):
            if start == len(s):
                res.append(path[:])
                return
            for end in range(start + 1, len(s) + 1):
                piece = s[start:end]
                if piece == piece[::-1]:
                    path.append(piece)
                    dfs(end)
                    path.pop()
        dfs(0)
        return res
```

## Complexity

Time `O(n · 2^n)`, space `O(n)` excluding output.

## Mistakes to Avoid

- The cut lengths must include the whole remainder: `range(1, len(s) + 1)`.
- Continue from `s[i:]` after cutting, not `s[i + 1:]`.

## Interview Explanation

I backtrack over cuts: each level takes a prefix of the remainder of every length from 1 to all of it, recursing on palindromes and recording when the string is used up; palindromic ranges can be precomputed with DP.
