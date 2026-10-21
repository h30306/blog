---
title: "LeetCode 412: Fizz Buzz"
summary: "LeetCode 412 note: check multiples of 15 first, then 5 and 3; multiples need %, not //"
description: "LeetCode 412 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Wrong Answer ×4 → Accepted

## Approach

Go from `1` to `n`: test `i % 15 == 0` **first** (or 3 or 5 would claim it), then `% 3` and `% 5`, and otherwise output `str(i)`.

## My Attempts

The first four submissions were WAs:

- Attempt 1 used `//` to test multiples (`i // 15 == 0` means "less than 15") and looped only over `range(3)`.
- The next ones hard-coded `["1", "2"]` and started at 3; until `//` was fixed everything became `FizzBuzz`, and after switching to `%`, **`n = 1` still returned two elements**. Dropping the hard-coded start passed.

## Solution

```python
class Solution:
    def fizzBuzz(self, n: int) -> List[str]:
        res = []
        for i in range(1, n + 1):
            if i % 15 == 0:
                res.append("FizzBuzz")
            elif i % 3 == 0:
                res.append("Fizz")
            elif i % 5 == 0:
                res.append("Buzz")
            else:
                res.append(str(i))
        return res
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- Test multiples with `%`.
- The range is `1..n`; do not hard-code the first elements.
- Convert numbers to strings.

## Interview Explanation

For 1 to n I check 15 first, then 3 and 5, and otherwise output the number as a string. Time `O(n)`.
