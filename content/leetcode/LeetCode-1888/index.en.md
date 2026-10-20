---
title: "LeetCode 1888: Minimum Number of Flips to Make the Binary String Alternating"
summary: "LeetCode 1888 note: rotations become length-n windows over s + s; the window's mismatches against 0101… are diff, and against 1010… they are n - diff"
description: "LeetCode 1888 record from 2026-01-03"
date: 2026-01-03
tags: ["medium", "sliding-window", "string", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-03
- Submissions: Wrong Answer → Accepted

## Approach

Type-1 moves (front to back) are free, and any number of them yields some rotation of `s`. **Every rotation is a length-`n` substring of `s + s`**, so slide a length-`n` window over `s + s`.

Each window has only two alternating targets: `0101…` or `1010…`. Use the absolute index parity for the expected character and maintain `diff`, the window's mismatches against `0101…`. Each position mismatches exactly one of the two targets, so the mismatches against `1010…` are `n - diff`.

## My Attempts

Attempt 1 kept two counters. When the left element leaves, it must be checked against **its own position's** expected value, but after copy-pasting I still used the right position's `expected1` and `expected2`. For `s = "011"`, rotating to `"101"` needs no flips, so the answer is 0; this returned 1.

Using `expected1_left` and `expected2_left` passed.

## Solution

```python
class Solution:
    def minFlips(self, s: str) -> int:
        n = len(s)
        t = s + s
        diff = 0                                   # mismatches against 0101... in the window
        best = n
        for i, c in enumerate(t):
            diff += c != "01"[i % 2]
            if i >= n:
                diff -= t[i - n] != "01"[(i - n) % 2]   # the left position's own expectation
            if i >= n - 1:
                best = min(best, diff, n - diff)
        return best
```

Keeping one counter and deriving the other as `n - diff` removes the chance of a copy-paste mix-up between two sets of variables.

## Complexity

Time `O(n)`, space `O(n)` for `s + s` (indices `% n` avoid it).

## Mistakes to Avoid

- Checking the outgoing element against the incoming element's expected value.
- Considering only `s` itself and not its rotations.

## Interview Explanation

Moving the front to the back is free, so any rotation is available, and all rotations are length-`n` substrings of `s + s`. I slide a length-`n` window over `s + s`, tracking mismatches against `0101…` by index parity; mismatches against `1010…` are `n` minus that, and each window takes the smaller. Time `O(n)`.
