---
title: "LeetCode 279: Perfect Squares"
summary: "LeetCode note for Perfect Squares, rebuilt from the original learning note"
description: "Cleaned LeetCode 279 article from 2026-05-03 with note repair points and final solution"
date: 2026-05-03
tags: ["medium", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-03
Source: Day 18 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### Problem 1 - LC 279 Perfect Squares
- **Status:** Good enough.
- **Pattern:** Unbounded min-count DP.

#### Why DP Fits
For each target sum `i`, we can choose any perfect square `sq <= i` as the last piece.

That means:
```text
answer for i depends on best answer for i - sq
```

It is unbounded because the same perfect square can be reused multiple times, such as:
```text
12 = 4 + 4 + 4
```

#### State
```text
dp[i] = minimum number of perfect squares needed to sum to i
```

#### Base Case
```text
dp[0] = 0
```

Reason:
```text
zero needs zero numbers
```

Initialize all other states as:
```text
dp[i] = +infinity
```

#### Transition
For each total `i` from `1` to `n`, try every perfect square `sq <= i`:
```text
dp[i] = min(dp[i], dp[i - sq] + 1)
```

#### Complexity
```text
Time: O(n * sqrt(n))
Space: O(n)
```

#### Common Mistakes
- treating it like a counting problem instead of a min-count problem
- writing `dp[0] = 1` instead of `0`
- saying the inner loop is over all integers instead of only perfect squares
- assuming greedy always works

#### Greedy Counterexample
For:
```text
n = 12
```

greedy picks:
```text
9 + 1 + 1 + 1
```

which uses `4` numbers, but optimal is:
```text
4 + 4 + 4
```

which uses `3`.

#### Interview-Ready Explanation
This is a min-count unbounded DP problem. For each target sum `i`, I try every perfect square `sq <= i` as the last piece and combine it with the best answer for `i - sq`. I define `dp[i]` as the minimum number of perfect squares needed to sum to `i`, with base case `dp[0] = 0`. Then for each `i` from `1` to `n`, I iterate through all perfect squares up to `i` and do `dp[i] = min(dp[i], dp[i - sq] + 1)`. It is unbounded because the same square can be reused multiple times. The time complexity is `O(n * sqrt(n))` and the space complexity is `O(n)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
class Solution:
    def numSquares(self, n: int) -> int:
        squares = [i * i for i in range(1, int(n ** 0.5) + 1)]
        dp = [0] + [float('inf')] * n

        for x in range(1, n + 1):
            for sq in squares:
                if sq > x:
                    break
                dp[x] = min(dp[x], dp[x - sq] + 1)

        return dp[n]
```

## Complexity

Time O(n sqrt n), Space O(n).

## Mistakes To Watch

- Using each square at most once.
- Forgetting dp[0]=0.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
