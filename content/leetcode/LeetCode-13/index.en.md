---
title: "LeetCode 13: Roman to Integer"
summary: "LeetCode 13 note: add each symbol's value left to right, subtracting instead when it is smaller than the symbol to its right"
description: "LeetCode 13 record from 2019-09-18"
date: 2019-09-18
tags: ["easy", "hash-table", "math", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2019-09-18
- Submissions: Accepted ×4

## Approach

In Roman numerals a smaller symbol **left of** a larger one means subtraction (`IV = 4`, `XC = 90`). Look values up in a hash map ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})); subtract when `val[s[i]] < val[s[i + 1]]`, otherwise add.

## My Solution

```python
class Solution:
    def romanToInt(self, s: str) -> int:
        val = {"I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000}
        total = 0
        for i, c in enumerate(s):
            if i + 1 < len(s) and val[c] < val[s[i + 1]]:
                total -= val[c]
            else:
                total += val[c]
        return total
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Bound-check `i + 1` before comparing with the right neighbor.

## Interview Explanation

I store each symbol's value in a hash map and scan left to right, subtracting a symbol smaller than its right neighbor and adding otherwise. Time `O(n)`.
