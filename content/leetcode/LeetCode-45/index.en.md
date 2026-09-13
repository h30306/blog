---
title: "LeetCode 45: Jump Game II"
summary: "LeetCode note for Jump Game II, rebuilt from the original learning note"
description: "Cleaned LeetCode 45 article from 2026-05-01 with note repair points and final solution"
date: 2026-05-01
tags: ["medium", "greedy", "bfs"]
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
Source: Day 16 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 2. Explain `current_end` vs `farthest` in `LC 45`.
- 1. Re-explain why `LC 45` is greedy instead of defaulting to DP language.

## Learning Note Extract

#### Problem 2 - LC 45 Jump Game II
- **Status:** Good enough after BFS-layer greedy correction.
- **Pattern:** Greedy / BFS-layer frontier expansion.

#### Why Greedy Fits
This problem asks for:
```text
minimum number of jumps
```

The clean way to think about it is BFS by layers:
- all indices up to `current_end` are reachable with the current number of jumps
- while scanning that layer, compute the farthest index reachable with one more jump
- when the layer ends, commit one jump

#### Core Invariants
```text
current_end = farthest index reachable with current jump count
farthest = farthest index reachable while scanning the current layer
jumps = number of committed layers / jumps
```

#### Layer Transition
```text
for i in range(len(nums) - 1):
    farthest = max(farthest, i + nums[i])
    if i == current_end:
        jumps += 1
        current_end = farthest
```

#### Complexity
```text
Time: O(n)
Space: O(1)
```

#### Common Mistakes
- defaulting to `O(n^2)` DP even though a linear greedy solution exists
- incrementing `jumps` when `farthest` changes instead of when the current layer ends
- iterating through the last index and adding one unnecessary jump

#### Interview-Ready Explanation
I treat the array like BFS layers. `current_end` is the farthest index reachable with the current number of jumps, and `farthest` is the farthest position I can reach while scanning that layer. When I finish the layer, I increment `jumps` and move `current_end` to `farthest`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from typing import List

class Solution:
    def jump(self, nums: List[int]) -> int:
        jumps = 0
        current_end = 0
        farthest = 0

        for i in range(len(nums) - 1):
            farthest = max(farthest, i + nums[i])
            if i == current_end:
                jumps += 1
                current_end = farthest

        return jumps
```

## Complexity

Time O(n), Space O(1).

## Mistakes To Watch

- Doing O(n^2) DP unnecessarily.
- Incrementing jumps after reaching the last index.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
