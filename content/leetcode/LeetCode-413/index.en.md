---
title: "LeetCode 413: Arithmetic Slices"
summary: "LeetCode note for Arithmetic Slices, rebuilt from the original learning note"
description: "Cleaned LeetCode 413 article from 2026-05-10 with note repair points and final solution"
date: 2026-05-10
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
First Attempt: 2026-05-10
Source: Day 21 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 4. Explain why `LC 413` adds previous streak plus one new length-3 slice.
- **LC 413 Arithmetic Slices:** Pass.

## Learning Note Extract

#### Problem 2 - LC 413 Arithmetic Slices
- **Status:** Pass.
- **Pattern:** 1D streak DP on contiguous subarrays.

#### Correct State
```text
curr = number of arithmetic slices ending at the current index
total = total number of arithmetic slices seen so far
```

#### Why This State Fits
The problem is about:
```text
contiguous subarrays
```

So at each index `i`, only the last 2 adjacent differences matter:
```text
nums[i] - nums[i - 1]
nums[i - 1] - nums[i - 2]
```

If they match, then:
- every arithmetic slice ending at `i - 1` can extend to `i`
- plus the last 3 elements form one new arithmetic slice

So:
```text
curr += 1
total += curr
```

If the difference breaks:
```text
curr = 0
```

#### Initialization
```text
curr = total = 0
```

Why:
```text
fewer than 3 elements cannot form an arithmetic slice
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- confusing contiguous subarrays with subsequences
- saying only the new length-3 slice matters and forgetting earlier slices can extend
- using extra state that duplicates the rolling DP meaning

#### Interview-Ready Explanation
This is streak DP on contiguous subarrays. I define `curr` as the number of arithmetic slices ending at the current index, and `total` as the total number of arithmetic slices seen so far. Starting from index `2`, if the last 2 adjacent differences are equal, then every arithmetic slice ending at `i - 1` can extend to `i`, and the last 3 elements form one new slice, so I do `curr += 1` and `total += curr`. Otherwise the streak breaks and `curr = 0`. The time complexity is `O(n)` and the space complexity is `O(1)`.

#### Code
```python
class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        total = 0
        curr = 0

        for i in range(2, len(nums)):
            if nums[i] - nums[i - 1] == nums[i - 1] - nums[i - 2]:
                curr += 1
                total += curr
            else:
                curr = 0

        return total
```

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def numberOfArithmeticSlices(self, nums: List[int]) -> int:
        curr = total = 0
        for i in range(2, len(nums)):
            if nums[i] - nums[i - 1] == nums[i - 1] - nums[i - 2]:
                curr += 1
                total += curr
            else:
                curr = 0
        return total
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Counting only length-3 slices.
- Not resetting when the difference changes.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
