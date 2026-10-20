---
title: "LeetCode 394: Decode String"
summary: "LeetCode 394 note: on [ push the current string and count, on ] pop and combine; counts can have several digits"
description: "LeetCode 394 record from 2025-10-08"
date: 2025-10-08
tags: ["medium", "stack", "string", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-10-08
- Submissions: Wrong Answer → Accepted

## Approach

`k[encoded]` can nest, e.g. `3[a2[c]]`. This is a classic stack problem:

- On `[`: push the string accumulated so far and this bracket's count, then start accumulating the inside.
- On `]`: the inside is complete; pop the outer string and count, and form `outer + inside * count`.

## My First Attempt: assuming a single-digit count

```python
stack.pop()                       # pop "["
repeat_time = int(stack.pop())    # only one character taken as the count
```

The first version pushed every character and popped back to `[` on `]`. The count was popped as a single character, so `10[a]` was treated as `0[a]`. The second version popped while the top was a digit, and passed.

## Solution

```python
class Solution:
    def decodeString(self, s: str) -> str:
        stack = []
        cur, num = "", 0
        for ch in s:
            if ch.isdigit():
                num = num * 10 + int(ch)
            elif ch == "[":
                stack.append((cur, num))
                cur, num = "", 0
            elif ch == "]":
                prev, k = stack.pop()
                cur = prev + cur * k
            else:
                cur += ch
        return cur
```

The stack holds "the outer string and count" rather than individual characters, so `]` never has to search back for `[` or rebuild strings character by character.

## Complexity

Time `O(output length)`, space `O(output length)`.

## Mistakes to Avoid

- Assuming the count has one digit.
- Pushing every character and rebuilding on `]`: it passes, but it is slower and more error-prone.

## Interview Explanation

I handle nested brackets with a stack: digits accumulate into the count (which may have several digits), `[` pushes the current string and count and starts fresh, and `]` pops the outer string and count and appends this level repeated that many times. The final accumulated string is the answer, in time proportional to the output length.
