---
title: "LeetCode 556: Next Greater Element III"
summary: "LeetCode Problem Solving"
description: "LeetCode"
date: 2025-04-13
tags: ["LeetCode", "blog", "medium", "next permutation"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-13
- Total time: 5:00.00

## Intuition

This is the classic [Next Permutation]({{< relref "Next-Permutation.md" >}}) problem, but with one additional constraint:  
the number must fit within a 32-bit signed integer.  
Therefore, we need to perform an extra check at the end of the algorithm to ensure the result is valid.

## Approach
```
class Solution:
    def nextGreaterElement(self, n: int) -> int:
        digits = list(str(n))

        i = len(digits)-2
        while i != -1 and digits[i]>=digits[i+1]:
            i -= 1

        if i == -1:
            return -1

        j = len(digits)-1
        while digits[i]>=digits[j]: 
            j -=1

        digits[i], digits[j] = digits[j], digits[i]
        digits[i+1:] = reversed(digits[i+1:])
        res = int("".join(digits))

        return res if res < 1<<31 else -1
```

## Findings
1. `1 << 32` means shifting the number 1 to the 32nd bit position, which is equivalent to calculating 2 raised to the power of 32.

## Encountered Problems 
NA