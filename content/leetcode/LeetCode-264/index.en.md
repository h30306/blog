---
title: "LeetCode 264: Ugly Number II"
summary: "LeetCode 264 note: three pointers mark the next ugly numbers to multiply by 2, 3 and 5; take the minimum each time and advance every pointer that produced it"
description: "LeetCode 264 record from 2022-11-14"
date: 2022-11-14
tags: ["medium", "hash-table", "math", "dynamic-programming", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-14
- Submissions: Time Limit Exceeded ×3 → Accepted ×3

## Approach

Every ugly number is a smaller ugly number times 2, 3 or 5. Keep pointers `i2`, `i3`, `i5`; the next one is `min(u[i2] * 2, u[i3] * 3, u[i5] * 5)`, and **every** pointer that produced it advances, avoiding duplicates such as 6 = 2 × 3 = 3 × 2 ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}) Template 1).

## My Attempts

The first three tested every integer from 1 for ugliness (the second added a `seen` set), but the `n`th ugly number can be huge, **so checking one by one was too slow**: three TLEs. The three-pointer version passed.

## Solution

```python
class Solution:
    def nthUglyNumber(self, n: int) -> int:
        u = [1]
        i2 = i3 = i5 = 0
        while len(u) < n:
            nxt = min(u[i2] * 2, u[i3] * 3, u[i5] * 5)
            u.append(nxt)
            if nxt == u[i2] * 2: i2 += 1
            if nxt == u[i3] * 3: i3 += 1
            if nxt == u[i5] * 5: i5 += 1
        return u[-1]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Use three separate `if`s, not `elif`, so every matching pointer advances.
- Testing each integer from 1 times out; the 1690th ugly number exceeds two billion.

## Interview Explanation

Each ugly number is a smaller one times 2, 3 or 5, so three pointers mark the next to multiply; I take the smallest product and advance every pointer that matches it to avoid duplicates. Time `O(n)`.
