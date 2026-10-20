---
title: "LeetCode 2235: Add Two Integers"
summary: "LeetCode 2235 note: return the sum; the C++ version once failed to compile from a missing semicolon"
description: "LeetCode 2235 record from 2025-12-17"
date: 2025-12-17
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
First Attempt: 2025-12-17
- Submissions: Accepted (Python) → Compile Error (C++) → Accepted (C++)

## Approach

Return `num1 + num2`. I used this one to practice C++ syntax.

## My Attempts

The first C++ version, `return num1 + num2`, was missing a semicolon: Compile Error.

## Solution

```python
class Solution:
    def sum(self, num1: int, num2: int) -> int:
        return num1 + num2
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Switching from Python to C++, statements need a trailing semicolon.

## Interview Explanation

Return the sum directly. The value range is tiny, so there is no overflow. Time `O(1)`.
