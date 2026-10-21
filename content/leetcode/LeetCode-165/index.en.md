---
title: "LeetCode 165: Compare Version Numbers"
summary: "LeetCode 165 note: split on dots, compare revision by revision as integers, and treat missing revisions of the shorter version as 0"
description: "LeetCode 165 record from 2022-11-19"
date: 2022-11-19
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-19
- Submissions: Accepted (first try)

## Approach

Split on `.` and convert each revision to `int` (dropping leading zeros), then compare with one pointer per version ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2). Missing revisions of the shorter version count as `0`, so `1.0` equals `1`.

## My Solution

```python
class Solution:
    def compareVersion(self, version1: str, version2: str) -> int:
        a = list(map(int, version1.split(".")))
        b = list(map(int, version2.split(".")))
        for i in range(max(len(a), len(b))):
            x = a[i] if i < len(a) else 0
            y = b[i] if i < len(b) else 0
            if x != y:
                return 1 if x > y else -1
        return 0
```

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- Compare as integers: `"01"` equals `"1"`.
- Pad missing revisions with 0 instead of assuming the longer version is larger.

## Interview Explanation

I split on dots, convert each revision to an integer, and compare them in order, treating missing revisions as 0; the first difference decides. Time `O(n + m)`.
