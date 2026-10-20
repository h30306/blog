---
title: "LeetCode 3703: Remove K-Balanced Substrings"
summary: "LeetCode 3703 note: repeated replace is O(n^2); a stack of (character, run length) removes k ( plus k ) as soon as they line up"
description: "LeetCode 3703 record from 2025-10-05"
date: 2025-10-05
tags: ["medium", "stack", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-10-05
- Submissions: Accepted (5298ms)

## Approach

A `k`-balanced substring is `k` `(` followed by `k` `)`. Keep deleting such substrings until none remain.

After a deletion, the two sides join and may form a new `k`-balanced substring. That "delete and join with what came before" pattern is a stack.

## My Solution: repeated replace

```python
class Solution:
    def removeSubstring(self, s: str, k: int) -> str:
        target = "(" * k + ")" * k
        while target in s:
            s = s.replace(target, "", 1)
        return s
```

It passed but took 5298ms. Each `in` and `replace` rescans the whole string, and there can be up to `n / 2k` deletions, for `O(n^2 / k)` total.

## Better: a stack of runs

The stack holds `[character, run length]`, merging equal characters into one run:

1. Read a character; if it matches the top run, increment its length, otherwise push a new run.
2. If the top run is `)` with exactly `k` and the run below is `(` with at least `k`, remove `k` of each.
3. If the `(` run drops to 0, remove it; later characters merge with the new top automatically.

```python
class Solution:
    def removeSubstring(self, s: str, k: int) -> str:
        stack = []                                 # [character, run length]
        for ch in s:
            if stack and stack[-1][0] == ch:
                stack[-1][1] += 1
            else:
                stack.append([ch, 1])
            if (ch == ")" and stack[-1][1] == k and len(stack) >= 2
                    and stack[-2][0] == "(" and stack[-2][1] >= k):
                stack.pop()
                stack[-1][1] -= k
                if stack[-1][1] == 0:
                    stack.pop()
        return "".join(ch * cnt for ch, cnt in stack)
```

The check runs only when the `)` run **equals** `k`: once it exceeds `k`, the `(` run before it was too short, and more `)` cannot fix that.

## Complexity

| Approach | Time |
|---|---|
| Repeated replace | `O(n^2 / k)` |
| Stack of runs | `O(n)` |

## Mistakes to Avoid

- Stopping after one round: joining the two sides can create a new `k`-balanced substring.
- Storing single characters on the stack: each check would count back `k` characters; storing run lengths avoids that.

## Interview Explanation

Deleting a block joins its neighbors, which may allow another deletion, so I use a stack. It stores runs of identical characters with their lengths; when a `)` run reaches exactly `k` and the `(` run below has at least `k`, I subtract `k` from both and drop empty runs. Each character is pushed and popped once, so time is `O(n)`. My original repeated `replace` passed but rescanned the whole string every time.
