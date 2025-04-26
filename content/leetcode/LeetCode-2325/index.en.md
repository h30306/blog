---
title: "LeetCode 2325: Decode the Message"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-22
tags: ["LeetCode", "blog", "hash map", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy  
First Attempt: 2025-04-22  
- Total time: 10:00.00  

## Intuition

We can build a mapping from each character in the `key` to a corresponding character starting from `'a'` by using `ord()`.  
After constructing the substitution table, we simply iterate through the `message` and join the result.  
This is an `O(n)` solution that iterates through the array once.

## Approach

```python
class Solution:
    def decodeMessage(self, key: str, message: str) -> str:
        idx_map = {}
        first_ord = 97  # ASCII code for 'a'
        for s in key:
            if s != " " and s not in idx_map:
                idx_map[s] = chr(first_ord)
                first_ord += 1
        return "".join(idx_map[s] if s != " " else s for s in message)
```

## Findings

N/A

## Encountered Problems

N/A