---
title: "LeetCode 647: Palindromic Substrings"
summary: "LeetCode 647 note: expand around centers, counting one palindromic substring for each successful expansion"
description: "LeetCode 647 record from 2022-11-01"
date: 2022-11-01
tags: ["medium", "two-pointers", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-01
- Submissions: Accepted (first try)

## Approach

As in LC 5, expand around the `2n - 1` centers (characters and gaps); each step outward with matching ends adds one palindromic substring.

## My Attempts

Passed on the first try, expanding odd and even centers as in LC 5.

## Solution

```python
class Solution:
    def countSubstrings(self, s: str) -> int:
        count = 0
        for center in range(2 * len(s) - 1):
            l, r = center // 2, center // 2 + center % 2
            while l >= 0 and r < len(s) and s[l] == s[r]:
                count += 1
                l, r = l - 1, r + 1
        return count
```

## Complexity

Time `O(n²)`, space `O(1)`.

## Mistakes to Avoid

- Count both odd- and even-length centers.

## Interview Explanation

I expand around every character and every gap, counting one palindrome for each step outward with matching ends. Time `O(n²)`, space `O(1)`.
