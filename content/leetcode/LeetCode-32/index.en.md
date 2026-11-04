---
title: "LeetCode 32: Longest Valid Parentheses"
summary: "LeetCode 32 note: a stack of indices whose bottom is the position just before the current valid run; the length is i - stack[-1]"
description: "LeetCode 32 record from 2026-11-03"
date: 2026-11-03
tags: ["hard", "string", "dynamic-programming", "stack", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-11-03
- Submissions: Wrong Answer ×5 → Accepted ×2

## Approach

Use a stack of **indices** ([Stack]({{< relref "/algorithm/Stack" >}})). The bottom of the stack holds the position just before the current valid run, initially `-1`:
- On `(`: push the index.
- On `)`: pop once.
  - If the stack is now empty, this `)` is unmatched and becomes the new boundary: push `i`.
  - Otherwise `i - stack[-1]` is the length of the valid run ending at `i`.

The key is storing indices so lengths can be computed. Counting matched pairs alone cannot tell whether those pairs are contiguous.

## My Attempts

Five WAs, all counting how many pairs matched:
1. `s.count("()") * 2` only sees adjacent `()`, not nested ones. `"(())"` returned 2; the answer is 4.
2. A stack of characters, adding 2 per match, counts **all** matches whether contiguous or not. `"()(()"` returned 4; the answer is 2, because the unmatched `(` in the middle splits the two runs.
3. Added `prev` and `curr` counters: when the stack emptied, add `curr` to `prev` and set `curr = prev`, which counts the same run twice. `"()()"` returned 6; the answer is 4.
4. `prev += curr` without resetting `curr` double-counts the same way; `"()()"` returned 6.
5. With `curr = 0` as the reset, `"(()(()"` returned 4; the answer is 2. An unmatched `(` sits between the two `()` pairs, but the stack never empties, so the counter keeps growing. Counters record how many, not where, so they cannot tell whether the two pairs touch.
6. Switching to a stack of indices with `-1` at the bottom as the boundary passed; a second rewrite also passed.

## Solution

```python
class Solution:
    def longestValidParentheses(self, s: str) -> int:
        stack = [-1]                  # position just before the current valid run
        longest = 0
        for i, c in enumerate(s):
            if c == "(":
                stack.append(i)
            else:
                stack.pop()
                if not stack:         # unmatched ), it becomes the new boundary
                    stack.append(i)
                else:
                    longest = max(longest, i - stack[-1])
        return longest
```

There is also an `O(1)`-space version: scan left to right counting `(` and `)`, update the answer when they are equal and reset both when `)` gets ahead; then scan right to left to handle runs with extra `(` (such as `"(()"`).

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Counting matches without positions cannot tell whether they are contiguous.
- Forgetting `-1` at the bottom: after `"()"` matches, the stack is empty and there is nothing to measure from.
- When the stack empties after a pop, push the current `i` as the new boundary instead of skipping it.

## Interview Explanation

I keep a stack of indices whose bottom is the position just before the current valid run, starting with -1. An opening bracket pushes its index. A closing bracket pops; if the stack is then empty, this bracket is unmatched and its index becomes the new boundary, otherwise `i` minus the top of the stack is the length of the valid run ending at `i`. I store indices rather than counting pairs, because an unmatched bracket in between means two runs are not contiguous. Time and space `O(n)`.
