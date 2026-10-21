---
title: "LeetCode 2264: Largest 3-Same-Digit Number in String"
summary: "LeetCode 2264 note: there are only ten candidates, "000" to "999", so check from "999" down whether each appears"
description: "LeetCode 2264 record from 2025-08-14"
date: 2025-08-14
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
First Attempt: 2025-08-14
- Submissions: Accepted (first try)

## Approach

A good integer must look like `"ddd"`, so there are only 10. From the largest, `"999"`, down, the first one found in `num` is the answer ([String]({{< relref "/algorithm/String" >}}) Template 3).

## My Solution

I originally used a length-3 sliding window with a `Counter`, comparing with the current answer whenever the window held one character. Enumerating the 10 candidates is simpler:

```python
class Solution:
    def largestGoodInteger(self, num: str) -> str:
        for d in "9876543210":
            if d * 3 in num:
                return d * 3
        return ""
```

## Complexity

Time `O(10 · n)`, space `O(1)`.

## Mistakes to Avoid

- The answer is a string, and `"000"` is valid; do not convert to an integer.

## Interview Explanation

Good integers are only `"000"` through `"999"`, so I check from largest to smallest which appears in the string; the first found is the answer. Time `O(n)`.
