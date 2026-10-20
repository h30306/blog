---
title: "LeetCode 3908: Valid Digit Number"
summary: "LeetCode 3908 note: convert to a string and check that it contains x but does not start with x"
description: "LeetCode 3908 record from 2026-04-25"
date: 2026-04-25
tags: ["easy", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-25
- Submissions: Accepted (first try)

## Approach

Both conditions are string operations:

- Contains `x` at least once: `str(x) in s`.
- Does not start with `x`: `not s.startswith(str(x))`.

## My Solution

```python
class Solution:
    def validDigit(self, n: int, x: int) -> bool:
        s = str(n)
        return str(x) in s and not s.startswith(str(x))
```

## Complexity

Time `O(d)`, space `O(d)`.

## Mistakes to Avoid

- `x` is an integer; convert it to a string before comparing with strings.

## Interview Explanation

I convert `n` to a string and check that it contains `x` and that its first character is not `x`. Time `O(d)`.
