---
title: "LeetCode 136: Single Number"
summary: "LeetCode 136 note: x ^ x = 0 and x ^ 0 = x, so XOR everything; pairs cancel and the single number remains"
description: "LeetCode 136 record from 2022-08-16"
date: 2022-08-16
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
First Attempt: 2022-08-16
- Submissions: Accepted ×3

## Approach

XOR is commutative and associative with `x ^ x = 0` and `x ^ 0 = x` ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})). XOR all numbers: pairs cancel to 0, leaving the single one, in `O(1)` extra space.

## My Solution

```python
class Solution:
    def singleNumber(self, nums: List[int]) -> int:
        res = 0
        for x in nums:
            res ^= x
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Counting with a hash map works but violates the `O(1)` space requirement.

## Interview Explanation

XOR is commutative and a number XORed with itself is 0, so XOR-ing everything cancels the pairs and leaves the answer. Time `O(n)`, space `O(1)`.
