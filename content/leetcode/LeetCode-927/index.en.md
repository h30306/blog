---
title: "LeetCode 927: Three Equal Parts"
summary: "LeetCode 927 note: every part has the same number of 1s, so count them; the third part always runs to the end of the array, fixing what each part must match, then check the parts do not overlap"
description: "LeetCode 927 record from 2025-07-16"
date: 2025-07-16
tags: ["hard", "math", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-07-16
- Submissions: 18 (many WA / RE → AC on the morning of 2025-07-17 → 7 more failures in a rewrite → AC)

## Approach

Leading zeros do not change the value, so the three parts represent one binary number ⇔ **they are identical after stripping leading zeros**.

1. Every part has the same number of 1s: if the total is not divisible by 3, it is impossible.
2. **All zeros**: every split gives 0, so return `[0, n - 1]`.
3. Each part has `k = total ones / 3` ones. Find the positions `a`, `b`, `c` of the 1st, `(k + 1)`-th and `(2k + 1)`-th ones: the starts of the three parts after stripping leading zeros.
4. **The third part always extends to the end**, owning the trailing zeros, so every part's length from its first 1 is `L = n - c`.
5. Check that `arr[a:a+L]`, `arr[b:b+L]` and `arr[c:]` match, that part one ends before part two starts (`a + L <= b`), and part two before part three (`b + L <= c`).
6. The answer is `[a + L - 1, b + L]`.

## My Attempts

This took 18 submissions. The first 9 scanned right to left accumulating each part's value with `2 ** (position)`, and the boundaries kept breaking:

- **All zeros were not handled**: `[0, 0, 0]` raised IndexError (`res` was empty) or returned `[-1, -1]`, while the answer is `[0, 2]`. One version even special-cased `if arr == [0, 0, 0, 0, 0]: return [0, 4]` to get past a specific test.
- The first AC returned `[0, n - 1]` when `part_count == 0`.

The same morning I rewrote it as "take the third part as a template, then match leftward", and kept getting the template position and the returned indices off by one, 7 more failures. For instance `[1, 1, 1]` returned `[0, 1]` (the answer is `[0, 2]`) and `[1, 1, 1, 1, 1, 1]` returned `[1, 3]` (the answer is `[1, 4]`).

The solution above compares directly from the three positions `a`, `b`, `c`, with no values to compute and fewer chances to be off by one.

## Solution

```python
class Solution:
    def threeEqualParts(self, arr: List[int]) -> List[int]:
        n = len(arr)
        ones = sum(arr)
        if ones == 0:
            return [0, n - 1]                      # all zeros
        if ones % 3:
            return [-1, -1]
        k = ones // 3

        starts = []                                # positions of the 1st, (k+1)-th, (2k+1)-th ones
        seen = 0
        for i, x in enumerate(arr):
            if x:
                if seen % k == 0:
                    starts.append(i)
                seen += 1
        a, b, c = starts
        L = n - c                                  # the third part runs to the end and fixes the length

        if a + L <= b and b + L <= c and arr[a:a + L] == arr[b:b + L] == arr[c:]:
            return [a + L - 1, b + L]
        return [-1, -1]
```

## Complexity

Time `O(n)`, space `O(n)` for the slices (three pointers comparing digit by digit make it `O(1)`).

## Mistakes to Avoid

- The all-zeros case.
- Computing values with `2 ** position`: with up to `3 × 10^4` digits the numbers are huge, and off-by-ones creep in.
- The returned `j` is where the third part **starts**, not where the second ends.

## Interview Explanation

Leading zeros do not matter, so the parts must match after stripping them. I count the 1s: not divisible by 3 is impossible, all zeros splits anywhere. Then I find each part's first 1; the third part runs to the end, so its length fixes how much each part must match, and if the three match without overlapping, the cut points follow. Time `O(n)`.
