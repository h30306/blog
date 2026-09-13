---
title: "LeetCode 300: Longest Increasing Subsequence"
summary: "LeetCode note for Longest Increasing Subsequence, rebuilt from the original learning note"
description: "Cleaned LeetCode 300 article from 2026-05-01 with note repair points and final solution"
date: 2026-05-01
tags: ["medium", "dynamic-programming", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-01
Source: Day 17 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 2. Explain why `LC 300` DP state must mean "ending at i".

## Learning Note Extract

#### Problem 2 - LC 300 Longest Increasing Subsequence
- **Status:** Good enough for both `O(n^2)` DP and `O(n log n)` follow-up.
- **Pattern:** Sequence DP, plus greedy + binary search optimization.

#### O(n^2) DP

#### Why DP Fits
For each index `i`, the LIS ending at `i` depends on earlier indices `j < i` whose values are smaller than `nums[i]`.

#### State
```text
dp[i] = length of the longest increasing subsequence ending at index i
```

#### Base Case
```text
dp[i] = 1 for every i
```

Reason:
```text
each element alone is an increasing subsequence of length 1
```

#### Transition
```text
for each j < i:
    if nums[j] < nums[i]:
        dp[i] = max(dp[i], dp[j] + 1)
```

#### Answer
```text
max(dp)
```

#### Complexity
```text
Time: O(n^2)
Space: O(n)
```

#### Common Mistakes
- saying "choose index i as one of the elements" instead of "ending at i"
- forgetting the answer is global max, not just `dp[-1]`

#### O(n log n) Follow-Up

#### Core Idea
Keep:
```text
tails[len - 1] = the smallest possible tail value of an increasing subsequence of length len
```

Why smaller tail is better:
```text
for the same subsequence length, a smaller tail gives more future extension options
```

#### Update Rule
For each number:
- if it is larger than all tails, append it
- otherwise replace the first tail `>= num`

#### Important Nuance
```text
tails is not always the actual LIS sequence
```

But:
```text
len(tails) is the correct LIS length
```

#### Complexity
```text
Time: O(n log n)
Space: O(n)
```

#### Interview-Ready Explanation
The O(n^2) DP uses `dp[i]` as the LIS ending at `i`. The O(n log n)` follow-up keeps the smallest possible tail for each subsequence length and uses binary search to replace tails. A smaller tail is better because it leaves more room for future extension.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from bisect import bisect_left
from typing import List

class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        tails = []
        for x in nums:
            i = bisect_left(tails, x)
            if i == len(tails):
                tails.append(x)
            else:
                tails[i] = x
        return len(tails)
```

## Complexity

Time O(n log n), Space O(n).

## Mistakes To Watch

- Treating equal values as increasing; use first >= x.
- Confusing tails with the actual final subsequence.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
