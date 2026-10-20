---
title: "LeetCode 60: Permutation Sequence"
summary: "LeetCode 60 note: make k 0-indexed; once the first digit is fixed there are (n-1)! arrangements, so k // (n-1)! picks the first digit among those remaining, then repeat for the next position"
description: "LeetCode 60 record from 2026-07-29"
date: 2026-07-29
tags: ["hard", "math", "combinatorics", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-29
- Submissions: Accepted (2026-07-29) → Wrong Answer (rewritten 2026-10-13)

## Approach

The permutations of `1..n` in lexicographic order: **once the first digit is fixed, the remaining `n - 1` numbers have `(n - 1)!` arrangements**, so the permutations split into `n` blocks of `(n - 1)!` each.

Make `k` 0-indexed:

- `idx = k // (n - 1)!`: the `k`-th permutation is in block `idx`, so the first digit is the `idx`-th smallest remaining number.
- `k %= (n - 1)!`: the position inside that block.
- **Remove** the used digit from the candidates and repeat for the remaining `n - 1` numbers.

## My Attempts

My first accepted version is the approach above. Rewriting it three months later, I did not keep the remaining digits; I printed `k // (n-1)! + 1` directly as the digit, and the factorial helper was wrong too (it multiplied by `n - 1`), so both the length and the digits were off. For `n = 3`, `k = 3` the answer is `"213"`; it returned `"3"`.

## Solution

```python
from math import factorial

class Solution:
    def getPermutation(self, n: int, k: int) -> str:
        k -= 1                                     # 0-indexed
        digits = [str(i) for i in range(1, n + 1)]
        res = []
        for i in range(n - 1, -1, -1):
            block = factorial(i)                   # arrangements of the remaining i numbers
            idx, k = divmod(k, block)
            res.append(digits.pop(idx))            # remove the used digit
        return "".join(res)
```

## Complexity

Time `O(n^2)` (`pop` is `O(n)`) with `n <= 9`. Space `O(n)`.

## Mistakes to Avoid

- Subtract 1 from `k` first; otherwise the division is off by one.
- Remove used digits; each position chooses among the **remaining** numbers.

## Interview Explanation

With the first digit fixed there are `(n - 1)!` arrangements left, so I make `k` 0-indexed; `k` divided by `(n - 1)!` says which remaining number comes first, I take it out, keep the remainder, and move to the next position. Used digits are removed. Time `O(n^2)`.
