---
title: "LeetCode 696: Count Binary Substrings"
summary: "LeetCode 696 note: split the string into runs of equal characters; each adjacent pair of runs contributes min(previous, current) substrings"
description: "LeetCode 696 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Wrong Answer ×2 → Accepted ×3

## Approach

A valid substring always spans **two adjacent runs**: in `000111` the `0` run has length 3 and the `1` run has length 3, giving `01`, `0011`, `000111`, which is `min(3, 3)`. Track the previous run length `prev` and the current one `cur`, adding `min(prev, cur)` whenever a run ends. **The last run ends after the loop, so add once more outside it.**

## My Attempts

Attempt 1 forgot the `return`. Attempt 2 added it but **never counted the last pair of runs after the loop**: `"01"` should give 1; it returned 0.

## Solution

```python
class Solution:
    def countBinarySubstrings(self, s: str) -> int:
        res, prev, cur = 0, 0, 1
        for i in range(1, len(s)):
            if s[i] == s[i - 1]:
                cur += 1
            else:
                res += min(prev, cur)
                prev, cur = cur, 1
        return res + min(prev, cur)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- After the loop the last pair of runs has not been counted; add `min(prev, cur)`.

## Interview Explanation

I view the string as runs of equal characters; two adjacent runs give the smaller of their lengths, so I track the previous and current run lengths, add at each boundary, and add once more after the loop. Time `O(n)`, space `O(1)`.
