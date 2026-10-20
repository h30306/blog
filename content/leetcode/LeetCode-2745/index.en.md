---
title: "LeetCode 2745: Construct the Longest New String"
summary: "LeetCode 2745 note: AA and BB must alternate, using min(x, y) pairs plus one extra of the more common kind, and every AB fits in"
description: "LeetCode 2745 record from 2025-07-22"
date: 2025-07-22
tags: ["medium", "dynamic-programming", "math", "greedy", "brainteaser"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-22
- Submissions: Accepted (first try)

## Approach

`AAA` and `BBB` are forbidden:

- `AA` cannot be followed by `AA` or `AB` (that makes `AAA`); only `BB`.
- `BB` cannot be followed by `BB`; `AA` or `AB` are fine.
- `AB` may be followed by `AA` or `AB`, not `BB`.

So `AA` and `BB` must alternate, `AABBAABB...`, using at most `min(x, y)` pairs; if one kind is more common, one more fits at an end. All `AB`s chain together between a `BB` and an `AA` (`...BB ABAB AA...`), so every one is used.

```text
x == y: (2x + z) × 2
x != y: (2 × min(x, y) + 1 + z) × 2
```

## My Solution

```python
class Solution:
    def longestString(self, x: int, y: int, z: int) -> int:
        pairs = min(x, y)
        pieces = 2 * pairs + (1 if x != y else 0) + z     # strings used
        return pieces * 2                                 # each string has length 2
```

LeetCode tags this as DP (`dp[x][y][z][last]` works), but with the pattern found it is `O(1)`.

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Assuming `AB` is restricted: `ABAB` creates no `AAA` or `BBB`, so all of them fit.

## Interview Explanation

`AA` can only be followed by `BB`, so `AA` and `BB` alternate, using twice the smaller count plus one more of the larger kind; all `AB`s chain together between a `BB` and an `AA`. Count the strings used and multiply by 2. Time `O(1)`.
