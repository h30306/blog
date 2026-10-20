---
title: "LeetCode 2337: Move Pieces to Obtain a String"
summary: "LeetCode 2337 note: after skipping blanks the piece order must match; L only moves left and R only moves right, so each L's start index must be >= its target index and each R's must be <="
description: "LeetCode 2337 record from 2026-02-01"
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
- Submissions: Runtime Error → Accepted

## Approach

`L` only moves left into a blank, `R` only moves right into a blank, and pieces **cannot pass each other**. So:

1. With blanks removed, `start` and `target` must have exactly the same piece sequence.
2. If the k-th piece is `L`, its index in `start` must be `>=` its index in `target` (it only moves left); if it is `R`, it must be `<=`.

These conditions are also sufficient: with the same order and every move in a legal direction, the pieces can be pushed into place one by one.

Two pointers skip blanks on `start` and `target` to find the next piece on each side and compare the pair.

## My Attempts

Attempt 1 hit a runtime error. The loop ran while `left < n or right < n`, and after skipping blanks, if only one side reached the end, reading `start[left]` or `target[right]` went out of range. For `start = "L"`, `target = "_"`, `target` reaches `right == n` after skipping its blank while `start[0]` still holds an `L`, so reading `target[1]` raises IndexError.

Returning `False` when only one side is exhausted passed.

## Solution

```python
class Solution:
    def canChange(self, start: str, target: str) -> bool:
        n = len(start)
        i = j = 0
        while True:
            while i < n and start[i] == "_":
                i += 1
            while j < n and target[j] == "_":
                j += 1
            if i == n or j == n:
                return i == n and j == n          # both sides must run out together
            if start[i] != target[j]:
                return False                      # different piece order
            if start[i] == "L" and i < j:
                return False                      # L cannot move right
            if start[i] == "R" and i > j:
                return False                      # R cannot move left
            i += 1
            j += 1
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Comparing piece counts only: order and direction both matter.
- Not handling one side running out of pieces while the other still has some, which goes out of range.

## Interview Explanation

Pieces cannot pass each other, so with blanks removed both strings must have the same piece sequence. Two pointers skip blanks and pair up the k-th pieces: the types must match, an `L` cannot be left of its target, and an `R` cannot be right of its target. Both sides must run out together. Time `O(n)`, space `O(1)`.

Related: [LeetCode 777]({{< relref "/leetcode/LeetCode-777" >}}) is the same problem with `X` as the blank.
