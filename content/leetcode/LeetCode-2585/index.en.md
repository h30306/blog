---
title: "LeetCode 2585: Number of Ways to Earn Points"
summary: "LeetCode 2585 note: a bounded (grouped) knapsack; each question type takes 0 to count questions, with capacity running backwards and the count enumerated inside"
description: "LeetCode 2585 record from 2026-08-27"
date: 2026-08-27
tags: ["hard", "dynamic-programming", "knapsack", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-27
- Submissions: Accepted ×2

## Approach

Questions of one type are indistinguishable, so each type decides **how many to solve** (`0` to `count`). That is a bounded knapsack, or a grouped knapsack where each group (type) picks one option.

`dp[s]` = the ways to earn exactly `s` points, `dp[0] = 1`. For each type, run capacity **backwards**, adding for each `s` the ways that take `k` of this type: `dp[s] += dp[s - k × marks]`.

Going backwards keeps `dp[s - k × marks]` at the value from the previous type, so a type is never counted twice.

## My Solution

```python
class Solution:
    def waysToReachTarget(self, target: int, types: List[List[int]]) -> int:
        MOD = 10 ** 9 + 7
        dp = [1] + [0] * target                    # dp[s]: ways to earn exactly s
        for count, marks in types:
            for s in range(target, 0, -1):         # backwards
                for k in range(1, count + 1):      # take k of this type
                    if s - k * marks < 0:
                        break
                    dp[s] = (dp[s] + dp[s - k * marks]) % MOD
        return dp[target]
```

Once `s - k × marks` goes negative, `break`, since larger `k` only goes further.

## Complexity

Time `O(target · Σ count)`, space `O(target)`.

## Mistakes to Avoid

- Running capacity forwards: a type could then be used without limit.
- Treating same-type questions as different: they are indistinguishable, so only the count matters.

## Interview Explanation

Questions of one type are indistinguishable, so each type only decides how many to take, from 0 to `count`. This is a bounded knapsack: with a 1D `dp`, each type runs capacity backwards and enumerates how many to take inside, adding the matching ways. Going backwards keeps a type from being reused. Time `O(target · Σ count)`.
