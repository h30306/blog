---
title: "LeetCode 1220: Count Vowels Permutation"
summary: "LeetCode 1220 note: state machine DP on the last vowel; turn \"what may follow x\" around into \"what may precede x\""
description: "LeetCode 1220 record from 2026-10-15"
date: 2026-10-15
tags: ["hard", "dynamic-programming", "state-machine"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-15
- Submissions: Wrong Answer ×2 → Accepted

## Approach

The state is the last vowel, with `a, e, i, o, u` counting strings ending in it. The problem says "what may follow `x`", so for transitions read it backwards as "what may precede `x`":

| Ends with | Previous may be |
|---|---|
| `a` | `e`, `i`, `u` |
| `e` | `a`, `i` |
| `i` | `e`, `o` |
| `o` | `i` |
| `u` | `i`, `o` |

At length 1 each is 1; apply `n - 1` transitions.

## My Attempts

1. **Attempt 1**: the modulus was `10 % 9 + 7` (which is 8) instead of `10 ** 9 + 7`, and the final sum had no modulo. For `n = 5` the answer is 68; it returned 20.
2. **Attempt 2**: added the final modulo, but the modulus was still 8. For `n = 2` the answer is 10; it returned `10 % 8 = 2`.
3. Changing it to `10 ** 9 + 7` passed.

## Solution

```python
class Solution:
    def countVowelPermutation(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        a = e = i = o = u = 1
        for _ in range(n - 1):
            a, e, i, o, u = (
                (e + i + u) % MOD,                 # previous may be e, i, u
                (a + i) % MOD,
                (e + o) % MOD,
                i % MOD,
                (i + o) % MOD,
            )
        return (a + e + i + o + u) % MOD
```

Simultaneous assignment avoids separate `prev_a`-style variables.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- `10 % 9 + 7` and `10 ** 9 + 7` differ by one character; small tests pass and only large ones fail.
- The rules say what follows `x`, so the transitions must be reversed.

## Interview Explanation

The state is the last vowel, with five variables counting strings ending in each. The problem gives what may follow each vowel, so I reverse it to what may precede each, update all five at once each step, and sum with the modulo at the end. Time `O(n)`.
