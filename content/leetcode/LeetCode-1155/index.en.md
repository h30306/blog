---
title: "LeetCode 1155: Number of Dice Rolls With Target Sum"
summary: "LeetCode note for Number of Dice Rolls With Target Sum, rebuilt from the original learning note"
description: "Cleaned LeetCode 1155 article from 2026-08-23 with note repair points and final solution"
date: 2026-08-23
tags: ["medium", "dynamic-programming", "counting"]
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
Source: Day 44 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 1155`: pass after state and base-case repair
- explain why `LC 1155` needs per-die layers and `newDp`
- say one clean difference between `LC 494`, `LC 518`, and `LC 1155`

## Learning Note Extract

#### Problem 2 - LC 1155 Number of Dice Rolls With Target Sum
- **Pattern:** layered counting DP with bounded per-step choices.

#### Why This Fits
This is not subset choice and not unbounded reuse.

The real question is:
```text
after rolling exactly d dice, how many ways produce sum s?
```

#### Core State / Invariant
2D form:
```text
dp[d][s] = number of ways to make sum s using exactly d dice
```

Compressed form:
```text
dp[s] = number of ways from the previous dice layer
newDp[s] = number of ways for the current dice layer
```

#### Base Case
Before rolling any dice:
```text
dp[0] = 1
```

Reason:
```text
there is exactly one way to make sum 0 with 0 dice
```

#### Transition
For each die, for each target sum, try every face:
```text
newDp[s] += dp[s - face]
```

when:
```text
s - face >= 0
```

Apply modulo after each addition.

#### Why `newDp` Is Required
The current layer must only read:
```text
states from d - 1 dice
```

If updated in place, one die could contribute multiple times in the same layer, which is incorrect.

#### Complexity
```text
Time: O(n * target * k)
Space: O(target)
```

#### Common Mistakes
- wrong base-case explanation for `dp[0]`
- trying to reuse a single array in place like `LC 518`
- saying this is unbounded knapsack
- forgetting modulo in the recurrence

#### Strong Spoken Explanation
I model this as counting ways by dice layer. `dp[s]` means the number of ways to make sum `s` from the previous number of dice, and for each new die I build a fresh `newDp`. For each target sum and each face value from `1` to `k`, I add the number of ways to reach `s - face` from the previous layer. The key invariant is that when computing the layer for `d` dice, I must only read states from `d - 1` dice, which is why I use `newDp` instead of in-place updates.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numRollsToTarget(self, n: int, k: int, target: int) -> int:
        mod = 10 ** 9 + 7
        dp = [0] * (target + 1)
        dp[0] = 1

        for _ in range(n):
            ndp = [0] * (target + 1)
            for s in range(target + 1):
                if dp[s] == 0:
                    continue
                for face in range(1, k + 1):
                    if s + face <= target:
                        ndp[s + face] = (ndp[s + face] + dp[s]) % mod
            dp = ndp

        return dp[target]
```

## Complexity

Time O(n * target * k), Space O(target).

## Mistakes To Watch

- Updating one array in place and mixing dice layers.
- Forgetting the modulo.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
