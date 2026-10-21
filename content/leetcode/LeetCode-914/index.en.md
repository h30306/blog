---
title: "LeetCode 914: X of a Kind in a Deck of Cards"
summary: "LeetCode 914 note: every card count must be divisible by one X >= 2, i.e. the GCD of all counts is at least 2"
description: "LeetCode 914 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "array", "hash-table", "math", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Wrong Answer → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted ×2

## Approach

Count each card value ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). Groups of `X` require `X` to divide **every** count, so `X` is a common divisor; some `X >= 2` exists exactly when the **GCD** of all counts is at least 2 ([Number Theory]({{< relref "/algorithm/Number-Theory" >}}) Template 1).

## My Attempts

This took 10 submissions, step by step toward the GCD:

- Attempt 1 required **equal** counts: a single card `[2]` returned `True` instead of `False`. Adding "count `>= 2`" then broke on different counts sharing a factor: `[1, 3, 1, 1, 1, 3]` has counts 4 and 2, groupable by 2, yet it returned `False`.
- Next, "every count divisible by the smallest count": counts 4 and 6 returned `False`, although groups of 2 work.
- Then "every count shares a factor with the smallest count": counts 6, 10 and 15 share factors pairwise, but no single `X` divides all three, so the answer is `False`; this returned `True`.
- Taking the GCD of **all** counts passed.

## Solution

```python
class Solution:
    def hasGroupsSizeX(self, deck: List[int]) -> bool:
        return reduce(gcd, Counter(deck).values()) >= 2
```

## Complexity

Time `O(n + k log n)`, space `O(k)`.

## Mistakes to Avoid

- Counts need not be equal: counts `[4, 6]` work with groups of 2.
- Dividing by the smallest count is wrong: for `4` and `6`, `X` is 2, not 4.
- Pairwise GCDs with the smallest count are not enough: `6, 10, 15` share a factor pairwise, but the GCD of all three is 1.

## Interview Explanation

I count each card; X must divide every count, so I take the GCD of all counts and check it is at least 2. Time `O(n + k log n)`.
