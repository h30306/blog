---
title: "LeetCode 1449: Form Largest Integer With Digits That Add Up To Target"
summary: "LeetCode note for Form Largest Integer With Digits That Add Up To Target, rebuilt from the original learning note"
description: "Cleaned LeetCode 1449 article from 2026-08-19 with note repair points and final solution"
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

- explain `LC 1449` as unbounded cost DP plus greedy reconstruction

## Learning Note Extract

#### Problem 2 - LC 1449 Form Largest Integer With Digits That Add Up To Target
- **Pattern:** unbounded knapsack optimization plus greedy reconstruction.

#### Why This Fits
Each digit `1..9` has:
- a cost
- unlimited reuse

The objective is not just:
```text
can I hit target?
```

It is:
```text
form the numerically largest integer whose total cost is target
```

That means:
1. maximize digit count first
2. among equal-length answers, reconstruct the lexicographically largest digit sequence

#### Core State / Invariant
```text
dp[t] = maximum number of digits we can build with total cost t
```

Use a very negative sentinel for unreachable states.

#### Base Case
```text
dp[0] = 0
```

Reason:
```text
cost 0 can form a number with 0 digits
```

#### Transition
For a digit with cost `c`:
```text
dp[t] = max(dp[t], dp[t - c] + 1)
```

Iterate target cost forward because digit reuse is allowed.

#### Reconstruction
After DP, rebuild from digit `9` down to `1`.

Greedy rule:
```text
take digit d if its cost fits and dp[remaining] == dp[remaining - cost[d]] + 1
```

This preserves max length while making the leftmost digits as large as possible.

#### Complexity
```text
Time: O(9 * target)
Space: O(target)
```

#### Common Mistakes
- solving only feasibility and forgetting reconstruction
- optimizing digit value directly instead of digit count first
- using backward loop and accidentally turning it into `0/1`
- not handling unreachable target cleanly

#### Strong Spoken Explanation
This is an unbounded knapsack on digit cost. I first use DP to maximize how many digits can be formed for each total cost, because any number with more digits is always numerically larger than a shorter valid number. So `dp[t]` stores the maximum digit count for cost `t`, with `dp[0] = 0` and unreachable states set to negative infinity. Since digits can be reused, the transition is unbounded: `dp[t] = max(dp[t], dp[t - cost] + 1)`. After I know the maximum digit count for the target, I reconstruct greedily from digit `9` down to `1`, taking a digit whenever it preserves the optimal count. That gives the lexicographically largest number among all max-length answers.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List, Optional

class Solution:
    def largestNumber(self, cost: List[int], target: int) -> str:
        dp: List[Optional[str]] = [None] * (target + 1)
        dp[0] = ''

        def better(a: str, b: Optional[str]) -> str:
            if b is None or len(a) > len(b) or (len(a) == len(b) and a > b):
                return a
            return b

        for t in range(1, target + 1):
            for digit in range(1, 10):
                c = cost[digit - 1]
                if t >= c and dp[t - c] is not None:
                    dp[t] = better(dp[t - c] + str(digit), dp[t])

        return dp[target] if dp[target] is not None else '0'
```

## Complexity

Time O(9 * target * answer_length), Space O(target * answer_length).

## Mistakes To Watch

- Maximizing digit value before length; a longer number is always larger.
- Forgetting unreachable states.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
