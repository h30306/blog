---
title: "LeetCode 1497: Check If Array Pairs Are Divisible by k (Remainder Pairing, Modulo)"
summary: "Remainder pairing with a hash map; handle 0 and k/2 remainders carefully."
description: "Use modulo and complement counts to verify if the array can be fully paired; includes complexity and common pitfalls."
date: 2025-08-09
tags: ["leetcode", "daily", "medium", "array", "hash-map", "complement", "counting", "math", "modulo"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Medium
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

Count each value's remainder modulo k in a hash map and pair remainder r with its complement k − r. The special cases are r = 0 and (when k is even) r = k/2; their counts must be even to form valid pairs.

## Approach

- Compute `num % k` for every element and record counts in a hash map of remainders.
- For each remainder r, check that `count[r] == count[k - r]`.
- Special cases:
  - Remainder 0 must have an even count.
  - If k is even, remainder k/2 must also have an even count.

```python
class Solution:
    def canArrange(self, arr: List[int], k: int) -> bool:
        remains = defaultdict(int)

        for num in arr:
            if num % k:
                remains[num % k] += 1

        for remain_num, count in remains.items():
            if k - remain_num == remain_num and remains[k - remain_num] % 2:
                return False

            elif remains[k - remain_num] != remains[remain_num]:
                return False

        return True
```

### Complexity

- Time: O(n)
- Space: O(k)

## Findings

- Complement pairing on remainders is the key idea: r pairs with k − r.
- Python's `%` yields non‑negative remainders, so negatives are handled implicitly.
- Common pitfalls: forgetting to handle remainder 0 and (if k is even) remainder k/2.

## Encountered Problems 

- Edge cases to handle explicitly:
  - Numbers divisible by k (remainder 0) must appear an even number of times so they can pair among themselves.
  - When k is even, numbers with remainder k/2 must also appear an even number of times; otherwise, `count[k/2] == count[k - k/2]` alone can be misleading (e.g., k = 4 and three 2s).