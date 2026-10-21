---
title: "LeetCode 1108: Defanging an IP Address"
summary: "LeetCode 1108 note: replace every . with [.]"
description: "LeetCode 1108 record from 2022-10-18"
date: 2022-10-18
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
First Attempt: 2022-10-18
- Submissions: Accepted (first try)

## Approach

Replace every `.` with `[.]`, either with one `replace` or by building the result character by character in a list ([String]({{< relref "/algorithm/String" >}}) Template 1).

## My Solution

```python
class Solution:
    def defangIPaddr(self, address: str) -> str:
        return address.replace(".", "[.]")
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `replace` returns a new string; the original is unchanged.

## Interview Explanation

I replace each dot with a bracketed dot in one replace call, in `O(n)`.
