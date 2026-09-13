---
title: "LeetCode 376: Wiggle Subsequence"
summary: "LeetCode note for Wiggle Subsequence, rebuilt from the original learning note"
description: "Cleaned LeetCode 376 article from 2026-05-23 with note repair points and final solution"
date: 2026-05-23
tags: ["medium", "dynamic-programming", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-05-23
Source: Day 25 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- explain `LC 376` as alternating-direction state tracking, not vague greedy intuition

## Learning Note Extract

#### Problem 1 - LC 376 Wiggle Subsequence
- **Pattern:** state-machine DP / greedy over alternating direction.

#### Why This Fits
At each position, the only thing that matters is:
```text
what is the best wiggle subsequence length if my last step was up or down?
```

That is a clean exact-end-state question, so state-machine reasoning fits naturally.

#### Core State / Invariant
```text
up   = best wiggle length ending at current index with last difference positive
down = best wiggle length ending at current index with last difference negative
```

If:
- `nums[i] > nums[i - 1]`, a positive jump can extend a sequence whose last jump was negative:
  - `up = down + 1`
- `nums[i] < nums[i - 1]`, a negative jump can extend a sequence whose last jump was positive:
  - `down = up + 1`
- equal values do not help either direction

#### Why Greedy Compression Works
For wiggle behavior, only turning points matter.

If you already have an upward move, keeping a more extreme endpoint is always at least as good as keeping a weaker one, because it preserves or improves the chance of a future alternating move.

That is why the full DP collapses cleanly into rolling `up/down`.

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- treating equal adjacent values as a valid wiggle step
- forgetting that `up` and `down` are lengths, not differences
- trying to keep the full subsequence instead of the best length under each ending direction
- giving a greedy answer without being able to justify why local compression is safe

#### Strong Spoken Explanation
I track two exact states: the best wiggle length ending here if the last movement is up, and the best if the last movement is down. When I see a larger value than the previous one, I can extend a sequence whose last movement was down; when I see a smaller value, I can extend one whose last movement was up. Equal values do not change either state. The reason the solution compresses to two variables is that for future wiggles only the best length under each ending direction matters.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def wiggleMaxLength(self, nums: List[int]) -> int:
        up = down = 1
        for i in range(1, len(nums)):
            if nums[i] > nums[i - 1]:
                up = down + 1
            elif nums[i] < nums[i - 1]:
                down = up + 1
        return max(up, down)
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Counting zero differences.
- Needing the actual subsequence; only length is required.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
