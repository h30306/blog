---
title: "LeetCode 504: Base 7"
summary: "LeetCode 504 note: repeatedly take % 7 and // 7 of the absolute value, then add the sign and reverse; handle 0 separately"
description: "LeetCode 504 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Runtime Error → Accepted

## Approach

Base conversion ([Math]({{< relref "/algorithm/Math" >}}) Template 7): repeatedly take `% 7` of `abs(num)` for the lowest digit and `// 7` to move on, reverse, and prepend `-` for negatives. With `num = 0` the loop never runs, so return `"0"` directly.

## My Attempts

The first submission pasted the wrong problem's code, a BST-mode solution (AttributeError). Seconds later the right code passed.

## Solution

```python
class Solution:
    def convertToBase7(self, num: int) -> str:
        if num == 0:
            return "0"
        n, digits = abs(num), []
        while n:
            digits.append(str(n % 7))
            n //= 7
        return ("-" if num < 0 else "") + "".join(reversed(digits))
```

## Complexity

Time `O(log n)`, space `O(log n)`.

## Mistakes to Avoid

- Handle 0 separately.
- Work on the absolute value; Python's `%` gives a non-negative remainder for negatives.

## Interview Explanation

I take remainders mod 7 of the absolute value for each digit, divide, reverse at the end, and add the sign; 0 returns directly. Time `O(log n)`.
