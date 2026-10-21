---
title: "LeetCode 682: Baseball Game"
summary: "LeetCode 682 note: keep valid scores on a stack; C removes the last, D adds its double, and + adds the sum of the last two"
description: "LeetCode 682 record from 2022-08-30"
date: 2022-08-30
tags: ["easy", "array", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-30
- Submissions: Accepted (first try)

## Approach

Each operation involves only the latest scores ([Stack]({{< relref "/algorithm/Stack" >}}) Template 2): push numbers; `C` pops; `D` pushes `2 * st[-1]`; `+` pushes `st[-1] + st[-2]`. Sum the stack at the end.

## My Solution

```python
class Solution:
    def calPoints(self, operations: List[str]) -> int:
        st = []
        for op in operations:
            if op == "C":
                st.pop()
            elif op == "D":
                st.append(2 * st[-1])
            elif op == "+":
                st.append(st[-1] + st[-2])
            else:
                st.append(int(op))
        return sum(st)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Scores can be negative; convert with `int(op)` rather than testing `isdigit`.

## Interview Explanation

Each operation touches only recent scores, so a stack of valid scores handles C by popping, D by pushing a double and + by pushing the sum of the last two; the answer is the stack's sum. Time `O(n)`.
