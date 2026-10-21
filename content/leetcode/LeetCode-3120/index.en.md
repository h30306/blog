---
title: "LeetCode 3120: Count the Number of Special Characters I"
summary: "LeetCode 3120 note: collect the letters seen in lowercase and in uppercase; the size of their intersection is the answer"
description: "LeetCode 3120 record from 2024-04-21"
date: 2024-04-21
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2024-04-21
- Submissions: Accepted (first try)

## Approach

Split the seen letters into two sets, those seen in lowercase and those seen in uppercase (stored in one case), and count the letters present in both ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})).

## My Solution

```python
class Solution:
    def numberOfSpecialChars(self, word: str) -> int:
        lower = {c for c in word if c.islower()}
        upper = {c.lower() for c in word if c.isupper()}
        return len(lower & upper)
```

## Complexity

Time `O(n)`, space `O(26)`.

## Mistakes to Avoid

- Store both sets in the same case before intersecting.

## Interview Explanation

I put letters seen in lowercase and in uppercase into two sets in one case and return the size of their intersection. Time `O(n)`.
