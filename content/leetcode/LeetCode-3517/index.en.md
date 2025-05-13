---
title: "LeetCode 3517: Smallest Palindromic Rearrangement I"
summary: "LeetCode Problem Solving"
description: "LeetCode Weekly Contest 445"
date: 2025-04-13
series: ["LeetCode Weekly Contest 445"]
series_order: 2
tags: ["LeetCode", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-13
- Total time: 05:00.00

## Intuition

We need to determine whether the string has an odd or even length in order to check if there's a middle character that needs special handling.  
Then, we sort the first half of the string based on `ord()`, and construct the final result by concatenating the left half, the middle character (if any), and the reversed left half.


## Approach
```
class Solution:
    def smallestPalindrome(self, s: str) -> str:
        odd = len(s)%2
        helf_index = len(s)//2
        left = list(s[:helf_index])
        
        middle_str = s[helf_index] if odd else ""
        
        left_sorted = "".join(sorted(left, key=ord))
        
        return left_sorted+middle_str+left_sorted[::-1]
```

## Findings
NA

## Encountered Problems 
NA