---
title: "LeetCode 17: Letter Combinations of a Phone Number"
summary: "LeetCode 17 note: each level handles one digit and tries its letters; an empty input returns an empty list"
description: "LeetCode 17 record from 2022-10-20"
date: 2022-10-20
tags: ["medium", "hash-table", "string", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-20
- Submissions: Runtime Error ×8 → Accepted → Runtime Error → Accepted ×2

## Approach

Level `i` handles `digits[i]`, appending each of its letters to the current string, and records once every digit is handled ([Backtracking]({{< relref "/algorithm/Backtracking" >}}) template). An empty `digits` returns `[]`, not `[""]`.

## My Attempts

This took 12 submissions, nearly all Python scoping:

- The recursion lived in another method that **used `digits` and `dic` directly**, but they were locals of `letterCombinations`, invisible to the other method (NameError), with a few syntax errors in between.
- The 2022-11 rewrite stored the mapping as `self.d2l` and passed `digits` down as a parameter, and passed.

## Solution

```python
class Solution:
    def letterCombinations(self, digits: str) -> List[str]:
        if not digits:
            return []
        letters = {"2": "abc", "3": "def", "4": "ghi", "5": "jkl",
                   "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"}
        res = []
        def dfs(i, path):
            if i == len(digits):
                res.append(path)
                return
            for c in letters[digits[i]]:
                dfs(i + 1, path + c)
        dfs(0, "")
        return res
```

## Complexity

Time `O(4^n · n)`, space `O(n)`.

## Mistakes to Avoid

- Another method cannot see this method's local variables (`digits`, `dic`); pass them or use a nested function.
- An empty string returns `[]`.

## Interview Explanation

I backtrack one digit per level, appending each of its letters and recording once all digits are processed; an empty input returns an empty list. Time `O(4^n · n)`.
