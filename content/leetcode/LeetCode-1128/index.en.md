---
title: "LeetCode 1128: Number of Equivalent Domino Pairs"
summary: "LeetCode 1128 note: normalize each domino to (small, large) as a key and count; a key with c dominoes yields c(c - 1) / 2 pairs"
description: "LeetCode 1128 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Runtime Error ×2 → Wrong Answer ×3 → Accepted

## Approach

`[a, b]` and `[b, a]` are the same, so normalize to `(min, max)` as the key ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5). A key with `c` dominoes forms `c(c - 1) / 2` pairs. Or accumulate while scanning: each domino pairs with every earlier one of the same key, so add the current count.

## My Attempts

- The first two used `sorted(dominoe)`, a list, as the key, **and lists are unhashable** (TypeError); they also returned `max(d.values())`.
- With `tuple(dominoe)` there was **no sorting**, so `[1, 3]` and `[3, 1]` counted as different, and the pair count was `(i * i - 1) // 2`. `tuple(sorted(...))` with `v * (v - 1) // 2` passed.

## Solution

```python
class Solution:
    def numEquivDominoPairs(self, dominoes: List[List[int]]) -> int:
        cnt = Counter()
        pairs = 0
        for a, b in dominoes:
            key = (min(a, b), max(a, b))
            pairs += cnt[key]
            cnt[key] += 1
        return pairs
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Lists cannot be dict keys; use tuples.
- Normalize the order: `[1, 3]` and `[3, 1]` are the same.
- The pair count is `c(c - 1) / 2`.

## Interview Explanation

I normalize each domino to a tuple with the smaller value first, add the number of earlier dominoes of the same kind to the answer, then increment its count. Time `O(n)`.
