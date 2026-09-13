---
title: "LeetCode 983: Minimum Cost For Tickets"
summary: "LeetCode note for Minimum Cost For Tickets, rebuilt from the original learning note"
description: "Cleaned LeetCode 983 article from 2026-05-07 with note repair points and final solution"
date: 2026-05-07
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
First Attempt: 2026-05-07
Source: Day 20 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 4. Explain why `dp[n] = 0` and `n + 1` DP size are needed in `LC 983`.

## Learning Note Extract

#### Problem 2 - LC 983 Minimum Cost For Tickets
- **Status:** Good enough.
- **Pattern:** 1D DP on travel-day index.

#### Why DP Fits
The decision only matters on travel days.

At each travel day `days[i]`, there are only 3 choices:
- buy 1-day pass
- buy 7-day pass
- buy 30-day pass

Each choice jumps to:
```text
the first future travel day not covered by that pass
```

#### State
```text
dp[i] = minimum cost to cover all travel days starting from days[i]
```

#### Base Case
```text
dp[n] = 0
```

Reason:
```text
if there are no travel days left, no more cost is needed
```

#### Transition
If we buy:
- 1-day pass: jump to first index `j1` where `days[j1] >= days[i] + 1`
- 7-day pass: jump to first index `j7` where `days[j7] >= days[i] + 7`
- 30-day pass: jump to first index `j30` where `days[j30] >= days[i] + 30`

Then:
```text
dp[i] = min(
    costs[0] + dp[j1],
    costs[1] + dp[j7],
    costs[2] + dp[j30]
)
```

#### Why `n + 1` DP Size Matters
Need:
```text
dp[n] = 0
```

because after one pass covers all remaining travel days, the next uncovered index becomes:
```text
n
```

#### Why DP Fills Right To Left
`dp[i]` depends on:
- `dp[j1]`
- `dp[j7]`
- `dp[j30]`

Those are future indices, so later states must already be known.

#### Complexity
For the straightforward scan-forward version:
```text
Time: O(n^2)
Space: O(n)
```

#### Common Mistakes
- forgetting `dp[n] = 0`
- allocating only `n` states instead of `n + 1`
- trying to force prefix-sum thinking into a coverage-range problem
- forgetting that pass duration can be partially "wasted" and still be optimal

#### Interview-Ready Explanation
This is 1D DP on the travel-day index. I define `dp[i]` as the minimum cost to cover all travel days starting from `days[i]`. The base case is `dp[n] = 0`, because no travel days left means no more cost. At each state, I choose whether to buy a 1-day, 7-day, or 30-day pass. Each pass covers a range of future travel days, so I jump to the first travel-day index not covered by that pass and add that future DP cost. Then I take the minimum of the three choices. In the straightforward implementation, the time complexity is `O(n^2)` and the space complexity is `O(n)`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def mincostTickets(self, days: List[int], costs: List[int]) -> int:
        travel = set(days)
        last = days[-1]
        dp = [0] * (last + 1)

        for day in range(1, last + 1):
            if day not in travel:
                dp[day] = dp[day - 1]
            else:
                dp[day] = min(
                    dp[max(0, day - 1)] + costs[0],
                    dp[max(0, day - 7)] + costs[1],
                    dp[max(0, day - 30)] + costs[2],
                )

        return dp[last]
```

## Complexity

Time O(last travel day), Space O(last travel day).

## Mistakes To Watch

- Doing DP only by index but mishandling pass coverage.
- Forgetting non-travel days carry over.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
