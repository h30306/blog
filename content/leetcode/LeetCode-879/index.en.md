---
title: "LeetCode 879: Profitable Schemes"
summary: "LeetCode note for Profitable Schemes, rebuilt from the original learning note"
description: "Cleaned LeetCode 879 article from 2026-08-19 with note repair points and final solution"
date: 2026-08-19
tags: ["hard", "dynamic-programming", "knapsack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-19
Source: Day 46 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 879`: pass after state-definition repair
- explain `LC 879` with a state definition that exactly matches the code

## Learning Note Extract

#### Problem 1 - LC 879 Profitable Schemes
- **Pattern:** counting `0/1` knapsack with member capacity and capped profit threshold.

#### Why This Fits
Each crime can be:
```text
taken once or skipped
```

It consumes:
- some members

It contributes:
- some profit

The question is not to maximize profit.

It is:
```text
how many subsets satisfy members <= n and profit >= minProfit?
```

#### Core State / Invariant
For the implemented version used today:
```text
dp[p][m] = number of schemes that achieve at least profit p using at most m members
```

Profit is capped into:
```text
0..minProfit
```

#### Base Case
For every member limit `m`:
```text
dp[0][m] = 1
```

Reason:
```text
the empty set already achieves profit at least 0 and fits under any member cap
```

#### Transition
For a crime needing `g` members and giving profit `earn`:
```text
prevProfit = max(0, p - earn)
dp[p][m] += dp[prevProfit][m - g]
```

with modulo.

#### Why Profit Is Capped
Once a scheme already achieves:
```text
profit >= minProfit
```

extra profit does not create a new validity category.

So all larger profits can be merged into:
```text
the minProfit bucket
```

#### Complexity
```text
Time: O(len(group) * n * minProfit)
Space: O(n * minProfit)
```

#### Common Mistakes
- mixing `exactly m members` with `at most m members`
- using a state explanation that does not match the code
- forgetting why `dp[0][m] = 1` is valid in the `at most` formulation
- not capping profit at `minProfit`

#### Strong Spoken Explanation
This is a counting `0/1` knapsack. Each crime can be taken once, it consumes some members, and it contributes profit. The state I used is `dp[p][m] = number of schemes that achieve at least profit p using at most m members`. I cap the profit dimension at `minProfit` because once a scheme reaches that threshold, extra profit does not change whether it is valid. I initialize `dp[0][m] = 1` for all member limits because the empty set already satisfies profit at least `0`. Then for each crime I iterate both dimensions backward and add the previous-state count from `dp[max(0, p - earn)][m - g]`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def profitableSchemes(self, n: int, minProfit: int, group: List[int], profit: List[int]) -> int:
        mod = 10 ** 9 + 7
        dp = [[0] * (n + 1) for _ in range(minProfit + 1)]
        dp[0][0] = 1

        for members, gain in zip(group, profit):
            for p in range(minProfit, -1, -1):
                for used in range(n - members, -1, -1):
                    if dp[p][used] == 0:
                        continue
                    np = min(minProfit, p + gain)
                    dp[np][used + members] = (dp[np][used + members] + dp[p][used]) % mod

        return sum(dp[minProfit]) % mod
```

## Complexity

Time O(crimes * minProfit * n), Space O(minProfit * n).

## Mistakes To Watch

- Iterating forward and using a crime multiple times.
- Not capping profit at minProfit.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
