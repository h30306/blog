---
title: "LeetCode 227: Basic Calculator II"
summary: "LeetCode 227 note: read whole numbers, and at each operator apply the previous one: + and - push the number (negated for -), * and / combine with the top"
description: "LeetCode 227 record from 2022-11-13"
date: 2022-11-13
tags: ["medium", "math", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-13
- Submissions: Wrong Answer → Accepted

## Approach

There are no parentheses, only precedence ([Stack]({{< relref "/algorithm/Stack" >}}) Template 1). Keep the **previous operator** in `op` and accumulate digits into a full number; at the next operator or the end, apply `op`:

- `+`: push `num`; `-`: push `-num`.
- `*`, `/`: combine with the stack top and put it back, with division **truncating toward zero** (`int(a / b)`).

Sum the stack at the end. Multiplication and division happen immediately while addition and subtraction wait, which respects precedence.

## My Attempts

- Attempt 1 turned the string into a list of characters, **treating each character as a token**, so multi-digit numbers split apart: `"18"` returned something like 1.
- Attempt 2 tokenized numbers and operators first and passed, but it replaced slices in place with `s[i - 1:i + 2] = [result]`, shifting the rest each time, `O(n²)`; and it divided with `//`, which matches truncation toward zero only because every number is non-negative.

## Solution

```python
class Solution:
    def calculate(self, s: str) -> int:
        st, num, op = [], 0, "+"
        for i, c in enumerate(s):
            if c.isdigit():
                num = num * 10 + int(c)
            if c in "+-*/" or i == len(s) - 1:
                if op == "+":
                    st.append(num)
                elif op == "-":
                    st.append(-num)
                elif op == "*":
                    st.append(st.pop() * num)
                else:
                    st.append(int(st.pop() / num))
                op, num = c, 0
        return sum(st)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Numbers may have several digits; read them fully.
- Division truncates toward zero: `-3 / 2` is -1, while `//` gives -2.
- Handle the last number at the end of the string.

## Interview Explanation

I remember the previous operator and read numbers fully; at the next operator or the end, + and - push the number (negated for -) while * and / combine with the top, then I sum the stack, which respects precedence. Time `O(n)`.
