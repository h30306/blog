---
title: "LeetCode 53: Maximum Subarray"
summary: "LeetCode note for Maximum Subarray, rebuilt from the original learning note"
description: "Cleaned LeetCode 53 article from 2026-05-10 with note repair points and final solution"
date: 2026-05-10
tags: ["medium", "dynamic-programming", "kadane"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-10
Source: Day 21 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 1. Explain `LC 53` with the exact ending-here invariant and correct initialization.
- 2. Explain why `LC 53` needs `best` separately from `curr`.
- **LC 53 Maximum Subarray:** Pass.
- 1. Re-answer `LC 53` once more later with no wording drift on the invariant.

## Learning Note Extract

#### Problem 1 - LC 53 Maximum Subarray
- **Status:** Pass.
- **Pattern:** 1D DP with rolling state / Kadane's algorithm.

#### Correct State
```text
curr = maximum subarray sum ending at the current index
best = maximum subarray sum seen so far
```

#### Why This State Fits
For any index `i`, the best subarray ending at `i` has only 2 possibilities:
- start fresh at `nums[i]`
- extend the best subarray ending at `i - 1`

That gives the recurrence:
```text
curr = max(nums[i], curr + nums[i])
best = max(best, curr)
```

#### Initialization
```text
curr = best = nums[0]
```

Why:
```text
all-negative arrays are valid, so initializing to 0 would be wrong
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- saying `curr` is just "current subarray sum" instead of the exact ending-here invariant
- initializing to `0`, which breaks all-negative arrays
- returning `curr` instead of `best`

#### Interview-Ready Explanation
This is 1D DP with rolling state, also known as Kadane's algorithm. I define `curr` as the maximum subarray sum ending at the current index, and `best` as the maximum subarray sum seen so far. For each element, the best subarray ending here either starts fresh at this element or extends the previous ending-here subarray, so `curr = max(nums[i], curr + nums[i])`. Then I update `best = max(best, curr)`. I initialize both to `nums[0]` so all-negative arrays are handled correctly. The time complexity is `O(n)` and the space complexity is `O(1)`.

#### Code
```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]

        for i in range(1, len(nums)):
            curr = max(nums[i], curr + nums[i])
            best = max(best, curr)

        return best
```

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        curr = best = nums[0]
        for x in nums[1:]:
            curr = max(x, curr + x)
            best = max(best, curr)
        return best
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Resetting to zero when all numbers are negative.
- Returning the current sum instead of global best.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
