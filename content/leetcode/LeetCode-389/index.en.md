---
title: "LeetCode 389: Find the Difference"
summary: "LeetCode 389 note: t has one extra character; XOR every character of both strings, pairs cancel, and the extra one remains"
description: "LeetCode 389 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "bit-manipulation", "sorting"]
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
- Submissions: Accepted → Runtime Error → Accepted

## Approach

As in LC 136 ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})): across `s` and `t` every character except the extra one appears an even number of times, so XOR-ing them all leaves it. `sum(ord(t)) - sum(ord(s))` also works.

## My Attempts

The first version sorted and compared position by position and passed; a rewrite then had a syntax error, and the final version subtracted sums of character codes.

## Solution

```python
class Solution:
    def findTheDifference(self, s: str, t: str) -> str:
        x = 0
        for c in s + t:
            x ^= ord(c)
        return chr(x)
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- XOR the `ord` values and convert back with `chr`.

## Interview Explanation

Across both strings every character but the extra one appears an even number of times, so XOR-ing all character codes leaves the answer. Time `O(n)`, space `O(1)`.
