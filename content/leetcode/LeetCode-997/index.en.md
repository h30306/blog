---
title: "LeetCode 997: Find the Town Judge"
summary: "LeetCode 997 note: the judge is trusted by the other n - 1 people and trusts nobody, so in-degree minus out-degree equals n - 1"
description: "LeetCode 997 record from 2022-09-27"
date: 2022-09-27
tags: ["easy", "array", "hash-table", "graph"]
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
- Submissions: Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×3 → Runtime Error ×2 → Wrong Answer ×4 → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Accepted

## Approach

Treat trust as a directed graph. The judge is trusted by **everyone else** (in-degree `n - 1`) and **trusts nobody** (out-degree 0). Track `in - out` in one array; the person reaching `n - 1` is the judge (only the judge can, since in-degree is at most `n - 1`). With `n = 1` and no trust at all, that single person is the judge.

## My Attempts

This took 21 submissions across 2022-09 and 2022-11:

- At first I guessed: return `False` when `n == len(trust)`, or just return `n`, so `n = 2` with no trust returned 2 instead of -1.
- Counting in-degrees, I checked only "trusted by `n - 1` people" **without checking that the judge trusts nobody**; after adding that, `n = 1` with empty `trust` failed (answer 1, returned -1), and special-casing `trust == []` to return 1 broke `n = 2`.
- The 2022-11 rewrite separated the special cases (`n == 1` returns 1, otherwise -1) and passed. Using `in - out == n - 1` needs none of them.

## Solution

```python
class Solution:
    def findJudge(self, n: int, trust: List[List[int]]) -> int:
        score = [0] * (n + 1)
        for a, b in trust:
            score[a] -= 1
            score[b] += 1
        for i in range(1, n + 1):
            if score[i] == n - 1:
                return i
        return -1
```

## Complexity

Time `O(n + t)`, space `O(n)`.

## Mistakes to Avoid

- Both conditions apply: trusted by `n - 1` people and trusting no one.
- With `n = 1` and empty `trust` the answer is 1.

## Interview Explanation

The judge is trusted by all others and trusts nobody, so I record in-degree minus out-degree per person and return whoever reaches n - 1. Time `O(n + t)`.
