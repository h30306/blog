---
title: "LeetCode 387: First Unique Character in a String"
summary: "LeetCode 387 note: count first, then scan left to right for the first character with count 1"
description: "LeetCode 387 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "queue", "counting"]
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
- Submissions: Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## Approach

Two passes ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1): count every character with a `Counter`, then scan left to right for the first index whose count is 1. With 26 letters the space is `O(1)`.

## My Attempts

Attempt 1 was a syntax error; then a dict of characters appearing once, scanned left to right for the first member, passed. A later one-liner with `OrderedDict(Counter(s))` took one WA to get right.

## Solution

```python
class Solution:
    def firstUniqChar(self, s: str) -> int:
        cnt = Counter(s)
        for i, c in enumerate(s):
            if cnt[c] == 1:
                return i
        return -1
```

## Complexity

Time `O(n)`, space `O(1)` (at most 26 letters).

## Mistakes to Avoid

- Return -1 when there is none.

## Interview Explanation

I count characters, then scan left to right for the first one appearing once and return its index, or -1. Time `O(n)`, space bounded by the alphabet.
