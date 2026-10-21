---
title: "LeetCode 942: DI String Match"
summary: "LeetCode 942 note: two pointers hold the smallest and largest unused values; place the smallest on I and the largest on D"
description: "LeetCode 942 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Accepted ×3

## Approach

`lo = 0` and `hi = n` are the smallest and largest unused values. On `I` place `lo`, since everything placed later is larger; on `D` place `hi`, since everything later is smaller. At the end `lo == hi`; append it.

## My Solution

```python
class Solution:
    def diStringMatch(self, s: str) -> List[int]:
        lo, hi = 0, len(s)
        res = []
        for ch in s:
            if ch == "I":
                res.append(lo)
                lo += 1
            else:
                res.append(hi)
                hi -= 1
        res.append(lo)
        return res
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- The answer has `n + 1` numbers; append the last one after the loop.

## Interview Explanation

Two pointers track the smallest and largest unused values; I takes the smallest and D the largest, so the next number always fits, and the one left over goes at the end. Time `O(n)`.
