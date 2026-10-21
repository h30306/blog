---
title: "LeetCode 1018: Binary Prefix Divisible By 5"
summary: "LeetCode 1018 note: each new bit turns the prefix into x = 2x + bit, so keep only x mod 5 and the number never grows"
description: "LeetCode 1018 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "array", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-27
- Submissions: Runtime Error → Time Limit Exceeded ×2 → Accepted ×4

## Approach

Reading one more bit turns the prefix value into `2x + bit` ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}): shift left, add the bit). Only divisibility by 5 matters, so apply `% 5` each step and the number stays below 5. Rebuilding each prefix as an integer is `O(n²)` with numbers of thousands of bits.

## My Attempts

Attempt 1 called `join` on a list of integers (TypeError); after that it rebuilt every prefix as an integer, `O(n²)` with ever-growing numbers, **timing out twice**. Keeping only the remainder passed.

## Solution

```python
class Solution:
    def prefixesDivBy5(self, nums: List[int]) -> List[bool]:
        res, x = [], 0
        for bit in nums:
            x = (x * 2 + bit) % 5
            res.append(x == 0)
        return res
```

## Complexity

Time `O(n)`, space `O(1)` excluding output.

## Mistakes to Avoid

- Reduce every step; `(2x + b) mod 5` depends only on `x mod 5`.
- Re-converting each prefix is `O(n²)` and times out.

## Interview Explanation

Each new bit doubles the prefix and adds the bit, and only the remainder mod 5 matters, so I keep just the remainder and the number never grows. Time `O(n)`.
