---
title: "LeetCode 746: Min Cost Climbing Stairs"
summary: "LeetCode note for Min Cost Climbing Stairs, rebuilt from the original learning note"
description: "Cleaned LeetCode 746 article from 2026-04-25 with note repair points and final solution"
date: 2026-04-25
tags: ["easy", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-04-25
Source: Day 10 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 3. Re-solve `LC 746 Min Cost Climbing Stairs` cleanly.

## Learning Note Extract

#### Problem 2 - LC 746 Min Cost Climbing Stairs
- **Status:** Good enough.
- **Pattern:** Fibonacci-style minimum-cost DP.

#### State
```text
dp[i] = minimum cost to reach step i
```

#### Base Case
```text
dp[0] = cost[0]
dp[1] = cost[1]
```

#### Transition
```text
dp[i] = cost[i] + min(dp[i - 1], dp[i - 2])
```

#### Final Answer
The top is one step beyond the last index, so:
```text
answer = min(dp[n - 1], dp[n - 2])
```

#### Complexity
```text
Time: O(n)
Space: O(n)
```

#### Interview-Ready Explanation
I can start from step 0 or step 1. To reach step `i`, I must come from `i - 1` or `i - 2`, so the minimum cost to reach `i` is the current step cost plus the cheaper of those two previous states. Since the top is beyond the last step, the answer is the cheaper of reaching the last or second-last step.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def minCostClimbingStairs(self, cost: List[int]) -> int:
        prev2 = prev1 = 0
        for i in range(2, len(cost) + 1):
            curr = min(prev1 + cost[i - 1], prev2 + cost[i - 2])
            prev2, prev1 = prev1, curr
        return prev1
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Paying cost for the top floor, which has no cost.
- Off-by-one between stair index and step position.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
