---
title: "LeetCode 322: Coin Change"
summary: "LeetCode note for Coin Change, rebuilt from the original learning note"
description: "Cleaned LeetCode 322 article from 2026-04-25 with note repair points and final solution"
date: 2026-04-25
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
First Attempt: 2026-04-25
Source: Day 10 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- **LC 322 Coin Change:** Repaired.

## Learning Note Extract

#### Problem 1 - LC 322 Coin Change
- **Status:** Repaired.
- **Pattern:** Unbounded minimum-count DP.
- **Main lesson:** Correct DP setup was mostly fine; the bug was control flow and greedy intuition.

#### State
```text
dp[i] = minimum number of coins needed to make amount i
```

#### Base Case
```text
dp[0] = 0
```

#### Transition
```text
dp[i] = min(dp[i], dp[i - coin] + 1)
```

for each reachable `i - coin`.

#### Initialization
```text
dp[i] = infinity for unreachable amounts
```

#### Important Repairs
- Do not early return just because `dp[amount]` becomes finite once.
- Do not assume reverse-sorting coins makes the first reachable answer optimal.
- Do not size the DP array with `len(coins) + 1`; it must be `amount + 1`.

#### Interview-Ready Explanation
This is a minimum-count DP problem. I define `dp[i]` as the minimum number of coins needed to make amount `i`. The base case is `dp[0] = 0`. For each coin, I update `dp[i]` from `dp[i - coin] + 1` if the smaller amount is reachable. After filling the table, if `dp[amount]` is still infinity, the answer is `-1`.

#### Complexity
```text
Time: O(amount * len(coins))
Space: O(amount)
```

#### Must-Know Distinction
```text
Coin Change minimum count -> dp[0] = 0
Coin Change 2 counting ways -> dp[0] = 1
```

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:
        inf = amount + 1
        dp = [0] + [inf] * amount

        for a in range(1, amount + 1):
            for coin in coins:
                if coin <= a:
                    dp[a] = min(dp[a], dp[a - coin] + 1)

        return -1 if dp[amount] == inf else dp[amount]
```

## Complexity

Time O(amount * len(coins)), Space O(amount).

## Mistakes To Watch

- Confusing with LC 518 counting combinations.
- Not using an unreachable sentinel.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
