---
title: "LeetCode 1049: Last Stone Weight II"
summary: "LeetCode note for Last Stone Weight II, rebuilt from the original learning note"
description: "Cleaned LeetCode 1049 article from 2026-08-19 with note repair points and final solution"
date: 2026-08-19
tags: ["medium", "dynamic-programming", "knapsack", "subset-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-08-19
Source: Day 45 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- explain `LC 1049` as a partition problem, not a simulation problem

## Learning Note Extract

#### Problem 2 - LC 1049 Last Stone Weight II
- **Pattern:** `0/1` subset partition with best-half approximation.

#### Why This Fits
If the stones are partitioned into two groups with sums:
```text
A and B
```

then the final remaining weight is:
```text
|A - B|
```

So the real goal is:
```text
find a reachable subset sum as close as possible to total / 2
```

#### Core State / Invariant
```text
dp[s] = whether some subset of processed stones can make sum s
```

#### Base Case
```text
dp[0] = true
```

Reason:
```text
choosing no stones makes sum 0
```

#### Transition
For each stone, iterate backward:
```text
dp[s] |= dp[s - stone]
```

#### Final Answer
Find the largest reachable:
```text
s <= total // 2
```

Then return:
```text
total - 2 * s
```

#### Complexity
```text
Time: O(len(stones) * target)
Space: O(target)
```

#### Common Mistakes
- treating smash operations as simulation instead of partitioning
- using forward iteration and reusing one stone
- thinking maximize-value DP is required
- forgetting the final scan for best reachable half

#### Strong Spoken Explanation
I reframe the smash process as partitioning stones into two groups. If the group sums are `A` and `B`, the final leftover is `|A - B|`, so I want the two sums as close as possible. That means I only need subset sums up to `total // 2`. I use boolean `0/1` DP where `dp[s]` tells me whether sum `s` is reachable from the processed stones. After filling the table, I scan downward from `total // 2` for the largest reachable `s` and return `total - 2 * s`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def lastStoneWeightII(self, stones: List[int]) -> int:
        total = sum(stones)
        target = total // 2
        dp = [False] * (target + 1)
        dp[0] = True

        for stone in stones:
            for s in range(target, stone - 1, -1):
                dp[s] = dp[s] or dp[s - stone]

        for s in range(target, -1, -1):
            if dp[s]:
                return total - 2 * s
        return 0
```

## Complexity

Time O(n * total_sum), Space O(total_sum).

## Mistakes To Watch

- Iterating forward accidentally reuses the same stone more than once.
- Optimizing for exact half only; the best answer may be below half.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
