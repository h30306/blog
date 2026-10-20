---
title: "LeetCode 726: Number of Atoms"
summary: "LeetCode 726 note: tokenize into elements, numbers, and parentheses; handle parentheses with a stack, with a default multiplier of 1"
description: "LeetCode 726 record from 2026-07-11"
date: 2026-07-11
tags: ["hard", "stack", "string", "hash-map", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-11
- Submissions: Wrong Answer ×3 → Accepted

## Approach

A formula contains three kinds of things:

- **Elements**: an uppercase letter followed by zero or more lowercase letters, e.g. `H`, `Mg`.
- **Numbers**: possibly several digits; omitted means 1.
- **Parentheses**: `( ... )` optionally followed by a multiplier; omitted means 1.

Parse left to right with an index, reading one complete token at a time:

1. `(`: push a marker.
2. `)`: read the multiplier after it, multiply every count back to the matching `(`, and push them back.
3. An uppercase letter: read the full element name and the number after it, and push it.

Finally, sum the counts and output them sorted by element name.

## My Attempts

The first three versions processed one character at a time and guessed which token it belonged to, which broke on several edge cases:

1. **`digits = "23456789"`**: missing `0` and `1`. A count of 1 is never written, but multi-digit numbers like `10` and `21` still contain `0` and `1`.
2. **Reading only one digit**: `H12` was read as `H1` followed by `2`.
3. **No number after `)`**: in `(OH)`, the elements inside were never merged and the `)` marker stayed on the stack.

The fourth version **read one complete token at a time with an index** and handled each token type separately, and passed.

## Solution

```python
from collections import defaultdict

class Solution:
    def countOfAtoms(self, formula: str) -> str:
        n = len(formula)
        i = 0

        def read_number() -> int:
            nonlocal i
            start = i
            while i < n and formula[i].isdigit():
                i += 1
            return int(formula[start:i]) if i > start else 1

        stack = [defaultdict(int)]
        while i < n:
            ch = formula[i]
            if ch == "(":
                stack.append(defaultdict(int))
                i += 1
            elif ch == ")":
                i += 1
                mult = read_number()
                inner = stack.pop()
                for atom, cnt in inner.items():
                    stack[-1][atom] += cnt * mult
            else:
                start = i
                i += 1
                while i < n and formula[i].islower():
                    i += 1
                atom = formula[start:i]
                stack[-1][atom] += read_number()

        counts = stack[0]
        return "".join(a + (str(counts[a]) if counts[a] > 1 else "") for a in sorted(counts))
```

Here each stack level is a dict, and `)` merges the level, multiplied, into the one below. The accepted version kept `(element, count)` pairs on one stack and popped back to a `(` marker on `)`; the idea is the same.

## Complexity

Worst-case time `O(n^2)` (with deep nesting, each merge rescans everything inside), plus sorting. Space `O(n)`.

## Mistakes to Avoid

- A digit set missing `0` and `1`.
- Reading only one digit.
- No default multiplier of 1 when nothing follows `)`.
- Guessing token types one character at a time: tokenizing first makes the logic much clearer.

## Interview Explanation

I parse left to right with an index and read one full token at a time: an element name is an uppercase letter plus following lowercase letters, and a number may have several digits, defaulting to 1. Each stack level is a dict of counts: `(` opens a new level, and `)` reads the multiplier and merges the level, multiplied, into the one below. Finally I output the elements in sorted order, writing the count only when it exceeds 1.
