---
title: "LeetCode 3688: Bitwise OR of Even Numbers in an Array"
summary: "LeetCode 3688 note: OR only the even numbers; the starting value 0 is also the answer when there are none"
description: "LeetCode 3688 record from 2025-09-21"
date: 2025-09-21
tags: ["easy", "bit-manipulation", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-09-21
- Submissions: Accepted (first try)

## Approach

Even numbers have lowest bit 0; OR them all together ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) Template 1). OR starts from 0, which stays untouched when there are no even numbers, exactly the required 0.

## My Solution

```python
class Solution:
    def evenNumberBitwiseORs(self, nums: List[int]) -> int:
        res = 0
        for x in nums:
            if x % 2 == 0:
                res |= x
        return res
```

I originally filtered first and special-cased an empty list; starting from 0 removes the special case.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The identity for OR is 0 and for AND is -1; do not mix them up.

## Interview Explanation

I OR only the even numbers starting from 0; with none, the result is naturally 0. Time `O(n)`.
