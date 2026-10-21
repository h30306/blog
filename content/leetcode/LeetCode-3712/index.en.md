---
title: "LeetCode 3712: Sum of Elements With Frequency Divisible by K"
summary: "LeetCode 3712 note: count each value, and for counts divisible by k add value × count"
description: "LeetCode 3712 record from 2025-10-12"
date: 2025-10-12
tags: ["easy", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-10-12
- Submissions: Accepted (first try)

## Approach

Count each value with a `Counter` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). For a value whose count is divisible by `k`, every occurrence counts, so add `value × count`.

## My Solution

```python
class Solution:
    def sumDivisibleByK(self, nums: List[int], k: int) -> int:
        return sum(x * c for x, c in Counter(nums).items() if c % k == 0)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Add every occurrence, not the value once.

## Interview Explanation

I count each value, and when its count is divisible by `k` I add the value times its count. Time `O(n)`.
