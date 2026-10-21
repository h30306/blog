---
title: "LeetCode 3612: Process String with Special Operations I"
summary: "LeetCode 3612 note: simulate the four operations with a list; put the "result is non-empty" check inside the * branch, or * gets appended as a letter"
description: "LeetCode 3612 record from 2025-07-13"
date: 2025-07-13
tags: ["medium", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-13
- Submissions: Wrong Answer → Accepted

## Approach

Simulate the rules ([String]({{< relref "/algorithm/String" >}}) Template 1). With a list as the result, `*` pops, `#` is `res += res`, `%` reverses, a letter appends, and `join` at the end.

## My Attempts

Attempt 1 wrote `if char == "*" and res:`. With an empty result that condition fails, so `*` falls through to the last `elif char.lower() == char`, and since `"*".lower()` is still `"*"`, **it was appended as if it were a letter**. For `"*"` the answer is the empty string; it returned `"*"`. Moving `if res` inside the branch passed.

## Solution

```python
class Solution:
    def processStr(self, s: str) -> str:
        res = []
        for ch in s:
            if ch == "*":
                if res:
                    res.pop()
            elif ch == "#":
                res += res
            elif ch == "%":
                res.reverse()
            else:
                res.append(ch)
        return "".join(res)
```

## Complexity

The result can double at every `#`; time and space are proportional to the final length.

## Mistakes to Avoid

- Folding an extra condition into a branch test with `and` makes failures fall through to later branches.
- `ch.lower() == ch` does not detect letters; symbols pass too. Use `ch.isalpha()` or just `else`.

## Interview Explanation

I simulate the four operations on a list and `join` at the end. Note that `*` on an empty result does nothing; that check must sit inside the branch, or `*` falls through and is treated as a letter. Time is proportional to the output length.
