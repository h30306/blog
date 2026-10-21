---
title: "LeetCode 434: Number of Segments in a String"
summary: "LeetCode 434 note: split() with no argument ignores extra spaces, so the number of pieces is the answer"
description: "LeetCode 434 record from 2022-08-24"
date: 2022-08-24
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
First Attempt: 2022-08-24
- Submissions: Accepted (first try)

## Approach

A segment is a run of non-space characters. `split()` with no argument treats runs of spaces as one separator and drops leading and trailing spaces, giving an empty list for an empty string, so `len(s.split())` is the answer ([String]({{< relref "/algorithm/String" >}}) Template 6).

## My Solution

```python
class Solution:
    def countSegments(self, s: str) -> int:
        return len(s.split())
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `split(" ")` leaves empty strings and overcounts.

## Interview Explanation

I use split with no argument, which ignores extra spaces, and count the pieces; for `O(1)` space, count positions that are non-space and either first or preceded by a space.
