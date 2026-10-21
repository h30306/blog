---
title: "LeetCode 202: Happy Number"
summary: "LeetCode 202 note: repeatedly take the sum of squared digits, which reaches 1 or enters a cycle; detect it with a set of seen numbers or fast and slow pointers"
description: "LeetCode 202 record from 2022-08-21"
date: 2022-08-21
tags: ["easy", "hash-table", "math", "two-pointers", "floyds-cycle-finding-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-21
- Submissions: Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Repeatedly summing squared digits shrinks the number quickly, ending either at 1 or in a cycle without 1. A set of seen numbers detects the cycle on a repeat (or use fast and slow pointers from [Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3 for `O(1)` space).

## My Attempts

Both WAs had the same bug: the loop kept computing the sum from **the original `n`** without updating it, so the second round repeated: `94` reaches 1, but it returned `False`.

## Solution

```python
class Solution:
    def isHappy(self, n: int) -> bool:
        seen = set()
        while n != 1 and n not in seen:
            seen.add(n)
            n = sum(int(c) ** 2 for c in str(n))
        return n == 1
```

## Complexity

Each step is `O(log n)` and there are few steps; space `O(steps)`.

## Mistakes to Avoid

- Each round must use the **new** number; update `n`.

## Interview Explanation

I keep replacing the number with its squared-digit sum, tracking seen numbers in a set; reaching 1 means happy, a repeat means a cycle without 1. Effectively `O(log n)`.
