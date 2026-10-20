---
title: "LeetCode 3895: Count Digit Appearances"
summary: "LeetCode 3895 note: convert each number to a string and add up how many times the digit appears"
description: "LeetCode 3895 record from 2026-08-24"
date: 2026-08-24
tags: ["medium", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-24
- Submissions: Accepted (first try)

## Approach

Despite the Medium label, convert each number to a string, count occurrences with `count`, and sum. Comparing digit by digit with `% 10` also works.

## My Solution

```python
class Solution:
    def countDigitOccurrences(self, nums: List[int], digit: int) -> int:
        target = str(digit)
        return sum(str(x).count(target) for x in nums)
```

## Complexity

Time `O(n · d)`, space `O(d)`.

## Mistakes to Avoid

- `digit` is an integer; convert it to a string to use `str.count`.

## Interview Explanation

I convert each number to a string, count how many times `digit` appears, and add them up. Without strings, peel digits with `% 10` and compare. Time `O(n · d)`.
