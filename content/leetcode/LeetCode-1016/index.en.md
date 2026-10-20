---
title: "LeetCode 1016: Binary String With Substrings Representing 1 To N"
summary: "LeetCode 1016 note: s has at most 1000 characters, so there are few substrings of any fixed length and a large n must be False; checking from n downward fails fast, or extend up to 30 bits from each start to collect every value <= n"
description: "LeetCode 1016 record from 2026-01-04"
date: 2026-01-04
tags: ["medium", "sliding-window", "string", "bit-manipulation", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-04
- Submissions: Memory Limit Exceeded → Wrong Answer ×4 → Accepted

## Approach

`n` can reach `10^9`, but `s` has at most 1000 characters.

**Key observation**: every number in `(n/2, n]` has the same binary length `L`, and there are about `n/2` of them. `s` has at most `len(s)` substrings of length `L`, so whenever `n/2 > len(s)` some number is missing. When the answer is `True`, `n` must be small (about `<= 2000`).

Two approaches:

1. **Check downward from `n`**: test each number with `bin(i)[2:] in s`. For large `n` the first few checks fail; for small `n` there are only a few thousand checks.
2. **Collect with a sliding window**: from each `1` in `s`, extend right while computing the binary value, stopping past `n` or 30 bits; put every value `<= n` into a `set` and check whether its size is `n`.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, MLE | Put the binary strings of `1..n` into a `set` first; with `n = 10^9` memory ran out |
| Attempt 2, WA | Switched to "enough distinct substrings of each length", requiring both `"0"` and `"1"` for length 1. But `0` is not in `1..n`. For `s = "1"`, `n = 1`, the answer is `True`; this returned `False` |
| Attempts 3–5, WA | Required `2^w - 1` kinds of length `w`. But substrings can have leading zeros (`"0"`, `"01"`), and `n` need not use every length-`w` number, so the right count does not mean the right contents. For `s = "0"`, `n = 1`, length 1 has one kind, but it is `"0"`, not `"1"`; the answer is `False` and this returned `True` |
| AC | Checked every number from `n` downward with `in` |

## Solution

```python
class Solution:
    def queryString(self, s: str, n: int) -> bool:
        for i in range(n, 0, -1):                  # large numbers first; a big n fails fast
            if bin(i)[2:] not in s:
                return False
        return True
```

Sliding-window collection version:

```python
class Solution:
    def queryString(self, s: str, n: int) -> bool:
        seen = set()
        for i in range(len(s)):
            if s[i] == "0":
                continue                           # binary representations have no leading 0
            val = 0
            for j in range(i, min(len(s), i + 30)):
                val = val * 2 + (s[j] == "1")
                if val > n:
                    break
                seen.add(val)
        return len(seen) == n
```

## Complexity

- Downward check: when the answer is `True`, `n = O(len(s))`, and each `in` is `O(len(s) · log n)`, about `O(len(s)^2 · log n)` total; for large `n` it fails within the first few numbers.
- Collection: time `O(30 · len(s))`, space `O(min(n, 30 · len(s)))`.

## Mistakes to Avoid

- Storing all of `1..n`: `n` can be `10^9`.
- Judging by the number of distinct substrings: leading zeros and values outside `1..n` get mixed in.

## Interview Explanation

`s` has at most 1000 characters, and all numbers between `n/2` and `n` share one binary length, so for `n` above roughly twice `len(s)` the answer must be `False`. I can check from `n` downward whether each number is a substring, which fails quickly for large `n`; or extend up to 30 bits from each `1`, collect every value `<= n` in a `set`, and compare its size with `n`, in `O(30 · len(s))`.
