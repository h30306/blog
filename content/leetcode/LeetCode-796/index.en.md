---
title: "LeetCode 796: Rotate String"
summary: "LeetCode 796 note: goal is a rotation of s exactly when the lengths match and goal occurs in s + s"
description: "LeetCode 796 record from 2022-09-07"
date: 2022-09-07
tags: ["easy", "string", "string-matching"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-07
- Submissions: Runtime Error ×2 → Wrong Answer → Accepted ×5

## Approach

`s + s` contains every rotation of `s` (each start followed by `len(s)` characters). So the answer is equal lengths and `goal in s + s` ([String]({{< relref "/algorithm/String" >}}) Template 2). **The length check is required**: `"aa"` is inside `"a" + "a"` too.

## My Attempts

This problem had two versions that were accepted yet wrong:

- The first two used `s.index` to locate characters and compare the next one, running `i + 1` out of range (IndexError).
- Then came "every adjacent pair of `s` must appear in `goal`, with at most one exception"; after one WA, adding a length check **was accepted, but the idea is wrong**: with `s = "b"`, `goal = "a"` the single missing piece `"b"` is within the allowance, so it returns `True`.
- Next, `goal in s + s` with only a `len(goal) < len(s)` check **was accepted too**: `s = "a"`, `goal = "aa"` returns `True`. The following version added `len(goal) == len(s)`, which is actually correct.

## Solution

```python
class Solution:
    def rotateString(self, s: str, goal: str) -> bool:
        return len(s) == len(goal) and goal in s + s
```

## Complexity

Time `O(n²)` worst case for the built-in search, `O(n)` with KMP; space `O(n)`.

## Mistakes to Avoid

- The lengths must be equal; checking only `len(goal) < len(s)` is not enough.
- "Every adjacent pair appears in goal" does not imply a rotation.

## Interview Explanation

s concatenated with itself contains every rotation, so I check equal lengths and that goal is a substring of s + s. The built-in search is `O(n²)` worst case; KMP makes it `O(n)`.
