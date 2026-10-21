---
title: "LeetCode 961: N-Repeated Element in Size 2N Array"
summary: "LeetCode 961 note: the other n values are distinct, so the first value seen twice is the answer"
description: "LeetCode 961 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array", "hash-table", "pigeonhole-principle"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Accepted ×3

## Approach

An array of length `2n` holds `n + 1` distinct values, one repeated `n` times and the rest once. So add values to a set while scanning; **the first repeat** is the answer ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). For `O(1)` space, the repeated value must meet itself within distance 3 somewhere.

## My Solution

```python
class Solution:
    def repeatedNTimes(self, nums: List[int]) -> int:
        seen = set()
        for x in nums:
            if x in seen:
                return x
            seen.add(x)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Only the answer repeats, so there is no need to count to `n`.

## Interview Explanation

Every other value appears once, so the first value seen twice is the answer, found with a set while scanning. Time `O(n)`.
