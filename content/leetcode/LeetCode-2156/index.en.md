---
title: "LeetCode 2156: Find Substring With Given Hash Value"
summary: "LeetCode 2156 note: the first character has weight p^0, so sliding right to left needs only multiply by p, add the new character, and subtract the outgoing one times p^k; the modulus may not be prime, so no modular inverse"
description: "LeetCode 2156 record from 2026-01-04"
date: 2026-01-04
tags: ["hard", "sliding-window", "rolling-hash", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-04
- Submissions: TLE → Accepted → TLE → Accepted

## Approach

`hash(s) = Σ val(s[i]) · p^i mod m`, so **the first character has weight `p^0`**.

Sliding left to right, moving the window one step would **divide** every weight by `p`. But `m` need not be prime, so `p` may have no inverse modulo `m`, and division is impossible.

**Sliding right to left** needs only multiplication:

```text
new hash = old hash · p + val(new left character) − val(outgoing right character) · p^k
```

Precompute `p^k mod m` with `pow(p, k, m)`. Scanning right to left, the last (leftmost) match is the answer.

## My Attempts

1. **TLE**: slid left to right, computing weights as `power ** (right - left)` and doing `//= power` on removal, with no modulo, so the numbers kept growing. Exact integer division is correct without a modulo, but the big-integer arithmetic is too slow.
2. **AC**: slid right to left with `pk = pow(power, k, modulo)`.
3. **TLE**: a rewrite computed `power ** k % modulo` at every step, and `power ** k` is a huge integer.
4. **AC**: went back to precomputing it with `pow`.

## Solution

```python
class Solution:
    def subStrHash(self, s: str, power: int, modulo: int, k: int, hashValue: int) -> str:
        n = len(s)
        pk = pow(power, k, modulo)                 # precompute once, not per step
        h = 0
        ans = 0
        for left in range(n - 1, -1, -1):
            h = (h * power + ord(s[left]) - 96) % modulo
            if left + k < n:
                h = (h - (ord(s[left + k]) - 96) * pk) % modulo
            if left + k <= n and h == hashValue:
                ans = left                         # leftmost match is updated last
        return s[ans:ans + k]
```

Python's `%` returns a non-negative result for negative numbers, so no extra `+ modulo` is needed after subtracting.

## Complexity

Time `O(n)`, space `O(1)` excluding the output.

## Mistakes to Avoid

- Sliding left to right needs division by `p`, but `modulo` may not be prime.
- Computing `power ** k` every step: big integers, TLE.
- The problem wants the **first** matching substring, so keep updating all the way to the leftmost when scanning right to left.

## Interview Explanation

This hash gives the first character weight `p^0`, so sliding left to right would divide by `p`, and the modulus may not be prime, so there is no inverse. I slide right to left instead: multiply the old hash by `p`, add the new character, and subtract the outgoing character times `p^k`, precomputed with a modulo. Since the first match is wanted, I keep updating until the leftmost position. Time `O(n)`.
