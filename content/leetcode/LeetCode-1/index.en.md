---
title: "LeetCode 1: Two Sum"
summary: "LeetCode 1 note: store seen numbers in a hash map while scanning and look up target - x; checking before storing prevents using one element twice"
description: "LeetCode 1 record from 2019-09-14"
date: 2019-09-14
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2019-09-14
- Submissions: Runtime Error → Accepted ×2 → Wrong Answer → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Wrong Answer ×2 → Accepted → Output Limit Exceeded → Accepted ×2 → Runtime Error ×2 → Accepted ×4 → Compile Error

## Approach

At `x` the other half is `target - x`. Keep a "value → index" hash map ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})) and **check before storing**: return both indices on a hit, otherwise store `x`. Checking first guarantees an element never pairs with itself and handles equal values such as `[3, 3]`.

## My Attempts

I wrote this 24 times between 2019 and 2026, with mostly one kind of error:

- Two nested loops with `nums.index(i)` to find indices, **which returns the same index for equal values**: `[1, 1]`, `target = 2` returned `[0, 0]`. Adding `i != l` compared values and did not help.
- Nested loops starting the inner one at `i + 1` were correct but `O(n²)`.
- The hash-map versions failed on details: typos (`taregt`, writing `target[num]` for `temp[num]`) and a leftover `print` causing Output Limit Exceeded.

## Solution

```python
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        seen = {}
        for i, x in enumerate(nums):
            if target - x in seen:
                return [seen[target - x], i]
            seen[x] = i
        return []
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Return indices, not values; `nums.index(x)` returns the same index for equal values.
- Check before storing, or `x` pairs with itself.
- Two nested loops are `O(n²)`.

## Interview Explanation

Scanning once, I keep a hash map from value to index; for each number I first look up target minus it and return both indices on a hit, storing the number only afterward so it never pairs with itself. Time `O(n)`, space `O(n)`.
