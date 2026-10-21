---
title: "LeetCode 709: To Lower Case"
summary: "LeetCode 709 note: an uppercase letter plus 32 in ASCII is its lowercase form; other characters stay"
description: "LeetCode 709 record from 2022-08-31"
date: 2022-08-31
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
First Attempt: 2022-08-31
- Submissions: Internal Error → Runtime Error ×3 → Accepted ×2

## Approach

`'A'` to `'Z'` are 65 to 90 and lowercase is exactly 32 higher. Check each character and convert uppercase ones with `chr(ord(c) + 32)` ([String]({{< relref "/algorithm/String" >}}) Template 4). In practice it is `s.lower()`.

## My Attempts

The first three wrote `ord(s)` (the whole string) in the condition, **a TypeError for any string longer than one character**, and two also lacked a closing bracket. Attempt 4 tried `ord(int(i))`, a ValueError on letters. Going back to `ord(i)` passed.

## Solution

```python
class Solution:
    def toLowerCase(self, s: str) -> str:
        return "".join(chr(ord(c) + 32) if "A" <= c <= "Z" else c for c in s)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Call `ord` on a single character, not the whole string.

## Interview Explanation

Uppercase letters become lowercase by adding 32 in ASCII, so I convert each character in A to Z and leave the rest. Time `O(n)`.
