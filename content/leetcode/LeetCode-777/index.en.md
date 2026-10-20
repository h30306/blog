---
title: "LeetCode 777: Swap Adjacent in LR String"
summary: "LeetCode 777 note: XL→LX moves L left and RX→XR moves R right; after skipping X the order must match, with L only moving left and R only moving right"
description: "LeetCode 777 record from 2026-02-01"
date: 2026-02-01
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-01
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Translate the moves:

- `"XL" → "LX"`: `L` moves one step left.
- `"RX" → "XR"`: `R` moves one step right.

`X` is a blank, and `L` and `R` cannot pass each other, so this is exactly [LeetCode 2337]({{< relref "/leetcode/LeetCode-2337" >}}):

1. With `X` removed, `start` and `result` must have the same sequence.
2. Each `L`'s index in `start` must be `>=` its index in `result`; each `R`'s must be `<=`.

## My Attempts

1. **Attempt 1** only compared `Counter(start) == Counter(result)`. For `start = "LR"`, `result = "RL"`, the counts match but `L` and `R` cannot pass each other, so the answer is `False`; this version returned `True`.
2. **Attempt 2** used two pointers to skip `X` and compare order, but did not check direction. For `start = "LX"`, `result = "XL"`, the order matches but `L` would have to move right, so the answer is `False`; this version returned `True`.

Adding the direction checks passed.

## Solution

```python
class Solution:
    def canTransform(self, start: str, result: str) -> bool:
        n = len(start)
        i = j = 0
        while True:
            while i < n and start[i] == "X":
                i += 1
            while j < n and result[j] == "X":
                j += 1
            if i == n or j == n:
                return i == n and j == n
            if start[i] != result[j]:
                return False
            if start[i] == "L" and i < j:
                return False                      # L only moves left
            if start[i] == "R" and i > j:
                return False                      # R only moves right
            i += 1
            j += 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Comparing character counts only.
- Comparing order only and forgetting that `L` only moves left and `R` only moves right.

## Interview Explanation

Replacing `XL` with `LX` moves `L` left, and replacing `RX` with `XR` moves `R` right; `X` is a blank and pieces cannot pass each other. Two pointers skip `X` and pair the k-th pieces: same type, an `L` in `start` not left of its spot in `result`, an `R` not right of it, and both sides run out together. Time `O(n)`.
