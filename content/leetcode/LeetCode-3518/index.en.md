---
title: "LeetCode 3518: Smallest Palindromic Rearrangement II"
summary: "LeetCode 3518 note: a palindrome is determined by its left half, so this is the k-th permutation of a multiset; try characters position by position and use permutation counts, updated in O(1), to find k's branch"
description: "LeetCode 3518 record from 2025-04-13"
date: 2025-04-13
tags: ["hard", "math", "combinatorics", "counting", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-04-13
- Submissions: WA → TLE ×2 (2025-04) → WA → TLE → RE → TLE → AC → RE → AC (2026-09-26)

## Approach

`s` is a palindrome, so every character count is even except at most one. A palindrome is determined by its **left half** (the right half mirrors it, and the middle is the odd-count character), so the task becomes: **the `k`-th permutation of the left half's multiset**.

Decide position by position:

- Remaining permutations = `remaining length! / Π remaining count of each character!`.
- Try character `c` here (smallest first): placing it leaves `current count × cnt[c] / remaining length` permutations.
  - If `k` falls in this branch (`k <= that`), place `c` and move on.
  - Otherwise subtract it from `k` and try the next character.
- If the total is `< k` from the start, return the empty string.

## My Attempts

| When | Version | Problem |
|---|---|---|
| 2025-04 | WA | Computed one next permutation and ignored `k`. For `s = "cc"`, `k = 6` there is only one palindromic arrangement, so the answer is empty; it returned `"cc"` |
| 2025-04 | Two TLEs | Ran next permutation `k - 1` times; `k` up to `10^6` is too slow |
| 2026-09 | WA | Switched to position-by-position, but the middle character only considered "characters with count `< 2`", so **a character appearing 3 times** never became the middle. For `s = "ccc"`, `k = 1` the answer is `"ccc"`; it returned `"cc"` |
| 2026-09 | TLE ×2 | Recomputed big-integer `factorial` divisions for every character tried |
| 2026-09 | RE ×2 | Renamed the method to `kthSmallestPalindrome`, so LeetCode could not find `smallestPalindrome` |
| 2026-09 | AC | Updated the permutation count in `O(1)`: `branch = current × cnt[c] // length` |

## Solution

```python
from math import factorial

class Solution:
    def smallestPalindrome(self, s: str, k: int) -> str:
        cnt = [0] * 26
        for ch in s:
            cnt[ord(ch) - 97] += 1
        mid = ""
        for i in range(26):
            if cnt[i] % 2:
                mid = chr(i + 97)                  # the odd-count character (3, 5, ... times too)
            cnt[i] //= 2                           # counts in the left half

        length = sum(cnt)
        ways = factorial(length)
        for c in cnt:
            ways //= factorial(c)
        if ways < k:
            return ""

        left = []
        for _ in range(length):
            for i in range(26):
                if cnt[i] == 0:
                    continue
                branch = ways * cnt[i] // length   # permutations after placing i here
                if k <= branch:
                    left.append(chr(i + 97))
                    cnt[i] -= 1
                    ways, length = branch, length - 1
                    break
                k -= branch
        half = "".join(left)
        return half + mid + half[::-1]
```

## Complexity

`O(26 · n)` big-integer operations (plus the initial factorials), space `O(n)`. Capping counts at `k` while computing them avoids big integers altogether.

## Mistakes to Avoid

- The middle character is the one with an **odd** count, not the one appearing once.
- Enumerating permutations one by one: too slow for large `k`.
- Recomputing factorials each time: update by the ratio `cnt[c] / length`.

## Interview Explanation

A palindrome is fixed by its left half, so this is the `k`-th permutation of the left half's multiset. I decide positions one at a time: placing character `c` leaves the current count times `cnt[c]` divided by the remaining length, so if `k` is within that I place `c`, otherwise I subtract and try the next. The middle is the odd-count character. Time `O(26n)`.
