---
title: "LeetCode 2838: Maximum Coins Heroes Can Collect"
summary: "LeetCode 2838 note: sort monsters by power, build coin prefix sums, and bisect_right per hero"
description: "LeetCode 2838 record from 2026-02-10"
date: 2026-02-10
tags: ["medium", "binary-search", "prefix-sum", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-10
- Submissions: Accepted (first try)

## Approach

A hero beats every monster with power `<=` their own and collects all of their coins. So each hero's answer is "the total coins of monsters with power `<=` the hero".

1. Sort `(monster power, coins)` by power.
2. Build prefix sums of the coins.
3. For each hero, `bisect_right` gives the index `idx` of the first monster they cannot beat; the answer is `prefix[idx]`.

## My Solution

```python
import bisect

class Solution:
    def maximumCoins(self, heroes: List[int], monsters: List[int], coins: List[int]) -> List[int]:
        pairs = sorted(zip(monsters, coins))
        powers = [p for p, _ in pairs]
        prefix = [0]
        for _, c in pairs:
            prefix.append(prefix[-1] + c)
        return [prefix[bisect.bisect_right(powers, h)] for h in heroes]
```

`bisect_right` is used because monsters with power **equal** to the hero's can be beaten too.

## Complexity

Time `O((n + m) log m)`, space `O(m)`.

## Mistakes to Avoid

- Using `bisect_left`: monsters with exactly equal power get skipped.
- Re-summing for every hero: `O(n * m)`.
- Sorting monsters and coins separately: the pairing breaks, so `zip` them before sorting.

## Interview Explanation

Each hero's answer is the total coins of monsters whose power does not exceed theirs. I sort monsters together with their coins by power, build coin prefix sums, and for each hero use `bisect_right` to find the first monster they cannot beat; the prefix sum there is the answer. Time `O((n + m) log m)`.
