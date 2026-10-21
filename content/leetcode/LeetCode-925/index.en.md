---
title: "LeetCode 925: Long Pressed Name"
summary: "LeetCode 925 note: one pointer each over name and typed; every typed character either matches the next name character or repeats the previous typed character"
description: "LeetCode 925 record from 2022-09-25"
date: 2022-09-25
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-25
- Submissions: Runtime Error ×2 → Internal Error → Wrong Answer ×5 → Accepted

## Approach

One pointer per string ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2), looping over `typed`:

- If `typed[j]` equals `name[i]`, it matches and `i` advances.
- Otherwise it must be a long press, `typed[j] == typed[j - 1]`; if not, fail.

Finally check that `i` reached the end of `name`, so `typed` did not stop partway.

## My Attempts

This took 9 submissions. The middle versions looped only while **both** pointers were in range, and on a mismatch did `i += 1` before comparing `name[i]`:

- `i` was not bounds-checked after the increment: `name = "b"`, `typed = "a"` raised an IndexError.
- The loop stopped once `name` ran out, **so the rest of `typed` was never checked**.

Looping over `typed`, where every character must match or be a long press, finally passed.

## Solution

```python
class Solution:
    def isLongPressedName(self, name: str, typed: str) -> bool:
        i = 0
        for j in range(len(typed)):
            if i < len(name) and name[i] == typed[j]:
                i += 1
            elif j == 0 or typed[j] != typed[j - 1]:
                return False
        return i == len(name)
```

## Complexity

Time `O(n + m)`, space `O(1)`.

## Mistakes to Avoid

- Loop over `typed` so that every extra character in it is checked.
- At the end confirm all of `name` was matched.

## Interview Explanation

With two pointers driven by typed: a character matching the current name character advances both, otherwise it must repeat the previous typed character (a long press) or we fail; finally name must be fully matched. Time `O(n + m)`, space `O(1)`.
