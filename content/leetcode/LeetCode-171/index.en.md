---
title: "LeetCode 171: Excel Sheet Column Number"
summary: "LeetCode 171 note: scan left to right with res = res × 26 + letter value (A = 1)"
description: "LeetCode 171 record from 2022-08-21"
date: 2022-08-21
tags: ["easy", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-21
- Submissions: Runtime Error → Accepted ×7

## Approach

The reverse of LC 168 ([Math]({{< relref "/algorithm/Math" >}}) Template 7): each letter is worth `ord(c) - ord("A") + 1`, and scanning left to right with `res = res * 26 + value` works just like parsing a decimal string.

## My Attempts

Attempt 1 wrote `for i, n in columnTitle[::-1]` **without `enumerate`**, so unpacking failed (ValueError). Adding it passed.

## Solution

```python
class Solution:
    def titleToNumber(self, columnTitle: str) -> int:
        res = 0
        for c in columnTitle:
            res = res * 26 + ord(c) - ord("A") + 1
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `A` is 1, not 0.
- Use `enumerate` when both the index and the character are needed.

## Interview Explanation

Scanning left to right, I multiply the running result by 26 and add the letter's value, with A as 1. Time `O(n)`.
