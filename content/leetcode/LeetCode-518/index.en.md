---
title: "LeetCode 518: Coin Change 2"
summary: "LeetCode note for Coin Change 2, rebuilt from the original learning note"
description: "Cleaned LeetCode 518 article from 2026-08-23 with note repair points and final solution"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "unbounded-knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-23
Source: Day 43 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 518` is the clean `unbounded` counting anchor.
- I do not classify knapsack problems by surface wording alone. I ask three things: can each item be reused, what exactly does `dp[...]` represent, and what loop direction preserves that meaning in 1D compression. `LC 416` is `0/1` reachability so the target loop goes backward. `LC 518` is unbounded counting so the amount loop goes forward. `LC 322` is also unbounded, but its state is minimum coins, so the recurrence and invalid-state handling are different.
- explain `LC 518` as unbounded counting with forward loop direction
- explain why `LC 322` is a different answer shape from `LC 518`

## Learning Note Extract

#### Problem 2 - LC 518 Coin Change 2
- **Pattern:** unbounded knapsack counting combinations

#### Why This Fits
Each coin can be reused:
```text
any number of times
```

The question is:
```text
how many combinations make the amount?
```

#### Core State / Invariant
```text
dp[a] = number of combinations to make amount a using the coins processed so far
```

#### Base Case
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make amount 0: choose no coins
```

#### Transition
For each `coin`:
```text
dp[a] += dp[a - coin]
```

when:
```text
a >= coin
```

#### Why Loop Direction Matters
Iterate amount forward:
```text
for a from coin up to amount
```

Reason:
```text
forward iteration lets the current coin be reused in the same coin round
```

#### Complexity
```text
Time: O(len(coins) * amount)
Space: O(amount)
```

#### Common Mistakes
- iterating amount backward and accidentally enforcing `0/1`
- putting amount as the outer loop and counting permutations instead of combinations
- saying `dp[a]` is minimum coins instead of number of ways
- forgetting why `dp[0] = 1`

#### Strong Spoken Explanation
I define `dp[a]` as the number of combinations to make amount `a` using the coins processed so far. The base case is `dp[0] = 1`, because there is exactly one way to make amount zero: choose nothing. For each coin, I iterate amounts forward so the same coin can be reused in the same round. The transition is `dp[a] += dp[a - coin]`. Keeping coins as the outer loop makes the answer combinations rather than permutations.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def change(self, amount: int, coins: List[int]) -> int:
        dp = [0] * (amount + 1)
        dp[0] = 1

        for coin in coins:
            for a in range(coin, amount + 1):
                dp[a] += dp[a - coin]

        return dp[amount]
```

## Complexity

Time O(len(coins) * amount), Space O(amount).

## Mistakes To Watch

- Putting amount outside counts permutations.
- Iterating amounts backward turns it into 0/1 knapsack.
- Confusing this with LC 322, which minimizes coin count.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
