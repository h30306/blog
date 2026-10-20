---
title: "LeetCode 1512: Number of Good Pairs"
summary: "LeetCode 1512 note: count while scanning; each number pairs with every earlier equal number, so add its current count to the answer"
description: "LeetCode 1512 record from 2025-12-18"
date: 2025-12-18
tags: ["easy", "math", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-12-18
- Submissions: Accepted ×2 (Python) → Compile Error → Accepted ×2 (C++)

## Approach

Count pairs with `nums[i] == nums[j]` and `i < j`.

- Brute force: a double loop, `O(n^2)`, fine for `n <= 100`.
- Counting: a value appearing `c` times gives `c × (c - 1) / 2` pairs.
- **Count while scanning**: on reading `x`, it pairs with every earlier `x`, so add `cnt[x]` to the answer and then increment `cnt[x]`.

## My Solution

```python
class Solution:
    def numIdenticalPairs(self, nums: List[int]) -> int:
        cnt = Counter()
        pairs = 0
        for x in nums:
            pairs += cnt[x]                        # pair with every earlier x
            cnt[x] += 1
        return pairs
```

I first wrote the brute force and the combination formula in Python, then practiced the scanning version in C++; that Compile Error was a missing semicolon after `return res`.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The combination with `/` yields a float; use `//`, or just count while scanning.

## Interview Explanation

I count while scanning: each number pairs with every earlier equal number, so I add how many times it has appeared so far, then increment that count. Time `O(n)`.
