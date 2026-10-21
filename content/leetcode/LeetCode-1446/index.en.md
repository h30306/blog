---
title: "LeetCode 1446: Consecutive Characters"
summary: "LeetCode 1446 note: track the current run of equal characters in one pass, resetting to 1 on a change"
description: "LeetCode 1446 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Wrong Answer → Accepted

## Approach

Extend the current run when a character equals the previous one, otherwise **reset to 1** (the new character is itself a run of length 1), tracking the maximum. `itertools.groupby` also works.

## My Attempts

Attempt 1 **reset the run to 0** on a change, leaving out the new character: `"baa"` should be 2; it returned 1. Resetting to 1 passed.

## Solution

```python
class Solution:
    def maxPower(self, s: str) -> int:
        best = cur = 1
        for i in range(1, len(s)):
            cur = cur + 1 if s[i] == s[i - 1] else 1
            best = max(best, cur)
        return best
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Reset to 1, not 0.

## Interview Explanation

In one pass I extend the run on equal neighbors and reset it to 1 otherwise, keeping the maximum. Time `O(n)`, space `O(1)`.
