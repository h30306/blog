---
title: "LeetCode 152: Maximum Product Subarray"
summary: "LeetCode note for Maximum Product Subarray, rebuilt from the original learning note"
description: "Cleaned LeetCode 152 article from 2026-05-01 with note repair points and final solution"
date: 2026-05-01
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
First Attempt: 2026-05-01
Source: Day 17 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 1. Explain why `LC 152` needs both `cur_max` and `cur_min`.

## Learning Note Extract

#### Problem 1 - LC 152 Maximum Product Subarray
- **Status:** Good enough.
- **Pattern:** Rolling DP with max/min state.

#### Why DP Fits
Product behaves differently from sum because a negative number can flip:
- a very small negative product into the new maximum
- a previous maximum into the new minimum

So one rolling state is not enough.

#### State
```text
cur_max = maximum product of a subarray ending at current index
cur_min = minimum product of a subarray ending at current index
```

Important nuance:
```text
"max" and "min" are value-based, not sign-based labels
```

#### Base Case
```text
cur_max = cur_min = nums[0]
answer = nums[0]
```

#### Transition
For current number `x`, compute from:
- `x`
- previous `cur_max * x`
- previous `cur_min * x`

So:
```text
new_max = max(x, cur_max * x, cur_min * x)
new_min = min(x, cur_max * x, cur_min * x)
```

Then:
```text
cur_max = new_max
cur_min = new_min
answer = max(answer, cur_max)
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- tracking only one running product
- forgetting that the DP boundary is "ending at i"
- returning the final `cur_max` instead of a global answer

#### Interview-Ready Explanation
I track both the maximum and minimum product ending at each index, because multiplying by a negative can swap their roles. At each number, I either start a new subarray or extend the previous max/min product. I keep a separate global answer because the best subarray may end before the last index.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maxProduct(self, nums: List[int]) -> int:
        max_here = min_here = ans = nums[0]

        for x in nums[1:]:
            a = x * max_here
            b = x * min_here
            max_here = max(x, a, b)
            min_here = min(x, a, b)
            ans = max(ans, max_here)

        return ans
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Tracking only the maximum product.
- Resetting on negative numbers instead of using min_here.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
