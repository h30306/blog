---
title: "LeetCode 551: Student Attendance Record I"
summary: "LeetCode 551 note: fewer than two A's and no LLL substring"
description: "LeetCode 551 record from 2022-08-27"
date: 2022-08-27
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
First Attempt: 2022-08-27
- Submissions: Wrong Answer → Accepted ×4

## Approach

Two conditions: fewer than two `'A'`s in total, and no three consecutive `'L'`s, i.e. `"LLL" not in s` ([String]({{< relref "/algorithm/String" >}}) Template 2).

## My Attempts

Attempt 1 wrote `for i in s: if i[:3] == "LLL"`; `i` is a single character, **so `i[:3]` is never `"LLL"`**: `"LLL"` returned `True`. Using `s[i:i + 3]` passed.

## Solution

```python
class Solution:
    def checkRecord(self, s: str) -> bool:
        return s.count("A") < 2 and "LLL" not in s
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Consecutive `L`s need a substring check; a per-character loop variable is a single character.

## Interview Explanation

I check that there are fewer than two A's and that LLL does not occur, in `O(n)`.
