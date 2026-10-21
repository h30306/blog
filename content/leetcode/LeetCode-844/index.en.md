---
title: "LeetCode 844: Backspace String Compare"
summary: "LeetCode 844 note: simulate backspaces with a stack; for O(1) space, walk from the end and count how many characters each # skips"
description: "LeetCode 844 record from 2022-09-15"
date: 2022-09-15
tags: ["easy", "two-pointers", "string", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-15
- Submissions: Runtime Error → Wrong Answer → Accepted ×2 → Runtime Error ×5 → Time Limit Exceeded ×3 → Runtime Error ×3 → Accepted

## Approach

With a stack ([Stack]({{< relref "/algorithm/Stack" >}}) Template 2): push ordinary characters and pop on `#` (doing nothing when empty), then compare the stacks.

For `O(1)` space walk from the end, since `#` only affects **earlier** characters. Each string keeps `skip`: a `#` adds one, a character with `skip > 0` is skipped and decrements it, until the next surviving character is found; then compare the two.

## My Attempts

I wrote this in 2022 and 2026 and failed 13 times in total:

- The first 2022-09 version used stacks and **popped an empty stack when `#` came first** (IndexError).
- Then came `O(1)`-space two pointers starting at `len(S)` (out of range), with inner `while` loops that never advanced, **looping forever: three TLEs**.
- A 2026 two-pointer rewrite read `s[j]` for the `t` side in two versions (an unedited copy-paste); `t[j]` passed.

## Solution

```python
class Solution:
    def backspaceCompare(self, s: str, t: str) -> bool:
        def next_char(x, i):
            skip = 0
            while i >= 0:
                if x[i] == "#":
                    skip += 1
                elif skip:
                    skip -= 1
                else:
                    return i
                i -= 1
            return -1
        i, j = len(s) - 1, len(t) - 1
        while True:
            i, j = next_char(s, i), next_char(t, j)
            if i < 0 or j < 0:
                return i < 0 and j < 0
            if s[i] != t[j]:
                return False
            i, j = i - 1, j - 1
```

## Complexity

Time `O(n + m)`, space `O(1)`.

## Mistakes to Avoid

- A `#` on an empty text does nothing; check before popping.
- Each round of the two-pointer loop must advance the pointers, or it never ends.
- Do not mix up the strings: compare `s[i]` with `t[j]`.

## Interview Explanation

The direct approach simulates backspaces with stacks. For `O(1)` space I walk both strings from the end, since a backspace only affects earlier characters, counting skips at each # and comparing the next surviving characters. Time `O(n + m)`.
