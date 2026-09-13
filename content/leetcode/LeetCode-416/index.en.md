---
title: "LeetCode 416: Partition Equal Subset Sum"
summary: "LeetCode note for Partition Equal Subset Sum, rebuilt from the original learning note"
description: "Cleaned LeetCode 416 article from 2026-08-23 with note repair points and final solution"
date: 2026-08-23
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
First Attempt: 2026-08-23
Source: Day 43 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- `LC 416` is the clean `0/1` reachability anchor.
- I do not classify knapsack problems by surface wording alone. I ask three things: can each item be reused, what exactly does `dp[...]` represent, and what loop direction preserves that meaning in 1D compression. `LC 416` is `0/1` reachability so the target loop goes backward. `LC 518` is unbounded counting so the amount loop goes forward. `LC 322` is also unbounded, but its state is minimum coins, so the recurrence and invalid-state handling are different.
- explain `LC 416` as `0/1` reachability with backward loop direction

## Learning Note Extract

#### Problem 1 - LC 416 Partition Equal Subset Sum
- **Pattern:** `0/1` knapsack / subset-sum reachability

#### Why This Fits
Each number can be used:
```text
either once or not at all
```

The question becomes:
```text
can I reach total / 2?
```

That is classic `0/1` subset selection.

#### Core State / Invariant
2D form:
```text
dp[i][s] = whether some subset from the first i numbers can make sum s
```

Compressed form:
```text
dp[s] = whether the numbers processed so far can make sum s
```

#### Base Case
```text
dp[0] = true
```

Reason:
```text
choosing nothing always makes sum 0
```

#### Transition
For each `num`:
```text
dp[s] = dp[s] or dp[s - num]
```

when:
```text
s >= num
```

#### Why Loop Direction Matters
In 1D compression, iterate `s` backward:
```text
for s from target down to num
```

Reason:
```text
backward iteration prevents the current number from being reused in the same round
```

#### Complexity
```text
Time: O(n * target)
Space: O(target)
```

#### Common Mistakes
- forgetting the odd-total early exit
- iterating `s` forward and accidentally reusing one number in the same round
- saying `dp[s]` is a best value instead of a reachable-state boolean
- failing to explain why `dp[0] = true`

#### Strong Spoken Explanation
I first reduce the problem to whether some subset reaches `total / 2`, because equal partition means both sides must sum the same. Then I use `0/1` subset-sum DP where `dp[s]` means whether the processed numbers can make sum `s`. The base case is `dp[0] = true`, since choosing nothing makes sum zero. For each number I update the target sum backward so the current number is used at most once. If `dp[target]` is true at the end, an equal partition exists.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def canPartition(self, nums: List[int]) -> bool:
        total = sum(nums)
        if total % 2:
            return False
        target = total // 2
        dp = [False] * (target + 1)
        dp[0] = True

        for num in nums:
            for s in range(target, num - 1, -1):
                dp[s] = dp[s] or dp[s - num]

        return dp[target]
```

## Complexity

Time O(n * target), Space O(target).

## Mistakes To Watch

- Not rejecting odd total first.
- Iterating forward and reusing the same number.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
