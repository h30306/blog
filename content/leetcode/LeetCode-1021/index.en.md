---
title: "LeetCode 1021: Remove Outermost Parentheses"
summary: "LeetCode 1021 note: track depth instead of a stack; the '(' raising depth from 0 to 1 and the ')' lowering it from 1 to 0 are outermost, everything else stays"
description: "LeetCode 1021 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "string", "stack", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-27
- Submissions: Wrong Answer → Accepted

## Approach

With a single bracket type the stack only ever holds `(`, so a depth counter suffices ([Stack]({{< relref "/algorithm/Stack" >}}) Template 1). On `(`, keep it only if the depth was already `> 0`, then increment; on `)`, decrement first and keep it only if the depth is still `> 0`. That strips the outer pair of every primitive.

## My Attempts

Attempt 1 used a stack to find each primitive and `temp[1:-1]` to strip its ends, which was right, but **it forgot the `return`**; adding it passed.

## Solution

```python
class Solution:
    def removeOuterParentheses(self, s: str) -> str:
        res, depth = [], 0
        for c in s:
            if c == "(":
                if depth > 0:
                    res.append(c)
                depth += 1
            else:
                depth -= 1
                if depth > 0:
                    res.append(c)
        return "".join(res)
```

## Complexity

Time `O(n)`, space `O(n)` (output).

## Mistakes to Avoid

- Check `(` before incrementing and `)` after decrementing.

## Interview Explanation

With one bracket type I count depth instead of using a stack: an opening bracket is kept when the depth is already positive, a closing one when the depth stays positive after decrementing, removing each primitive's outer pair. Time `O(n)`.
