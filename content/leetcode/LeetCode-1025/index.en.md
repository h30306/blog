---
title: "LeetCode 1025: Divisor Game"
summary: "LeetCode 1025 note: dp[i] holds when some divisor x of i makes dp[i - x] a loss; observing the pattern, the answer is simply whether n is even"
description: "LeetCode 1025 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "math", "dynamic-programming", "brainteaser", "game-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-27
- Submissions: Accepted ×2 → Runtime Error ×2 → Wrong Answer → Accepted ×3

## Approach

Game DP: `dp[i]` says whether the player facing `i` wins, true when some `x | i` with `x < i` makes `dp[i - x]` false (the opponent loses). Running it shows `dp[i]` is exactly "`i` is even" ([Linear DP]({{< relref "/algorithm/Linear-DP" >}}), "tagged DP but an observation is faster"): from an even number take 1, leaving the opponent odd; an odd number has only odd divisors, so any move leaves the opponent even.

## My Attempts

In 2022-09 `n % 2 == 0` passed at once. In 2022-11 I practiced the DP version:

- It started with `[False] * len(n)` (an integer has no length), then an index out of range.
- After that the outer loop was `range(n)`, **so `dp[n]` itself was never computed** and stayed `False`: `n = 2` returned `False`. `range(n + 1)` passed.

## Solution

```python
class Solution:
    def divisorGame(self, n: int) -> bool:
        return n % 2 == 0
```

## Complexity

Time `O(1)`, space `O(1)`; the DP version is `O(n²)`.

## Mistakes to Avoid

- The DP loop must include `n` itself: `range(n + 1)`.
- The array length is `n + 1`, not `len(n)`.

## Interview Explanation

A DP works, with dp[i] true when some divisor x leaves the opponent losing at i - x; but an even number can take 1 to hand over an odd one, and an odd number's divisors are all odd so it must hand over an even one, so the answer is whether n is even.
