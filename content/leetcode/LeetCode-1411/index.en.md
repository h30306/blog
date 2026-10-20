---
title: "LeetCode 1411: Number of Ways to Paint N × 3 Grid"
summary: "LeetCode 1411 note: a row's colorings come in two patterns, ABA (ends match) and ABC (all different), 6 each; the next row gives ABA → 3 ABA + 2 ABC and ABC → 2 ABA + 2 ABC"
description: "LeetCode 1411 record from 2026-07-05"
date: 2026-07-05
tags: ["hard", "dynamic-programming", "state-machine", "graph-coloring"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-05
- Submissions: Accepted ×2 (brute-force enumeration → pattern classes)

## Approach

A row of 3 cells with 3 colors and no equal neighbors has 12 colorings, in two patterns:

- **ABA**: the ends match, e.g. red-yellow-red, 6 colorings.
- **ABC**: all three differ, e.g. red-yellow-green, 6 colorings.

The next row must differ from the previous one in every cell. The number of compatible next rows depends only on the pattern (e.g. after `ABA` red-yellow-red, the next row can be yellow-red-yellow, green-red-green, yellow-green-yellow as ABA, and yellow-red-green, green-red-yellow as ABC):

```text
new ABA = 3 × ABA + 2 × ABC
new ABC = 2 × ABA + 2 × ABC
```

## My Attempts

Attempt 1 used `dp[row][c1][c2][c3]` directly, enumerating every valid coloring of each row against every valid coloring of the previous row, `O(n · 27 · 27)`, which passed in 1.3 seconds.

Grouping the 12 colorings into two patterns leaves only 4 coefficients, `O(n)`.

## Solution

```python
class Solution:
    def numOfWays(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        aba = abc = 6
        for _ in range(n - 1):
            aba, abc = (3 * aba + 2 * abc) % MOD, (2 * aba + 2 * abc) % MOD
        return (aba + abc) % MOD
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Check the coefficients by listing them by hand once (or with a brute force like attempt 1) rather than guessing.

## Interview Explanation

A row's 12 colorings fall into two patterns: ABA with matching ends and ABC with all different colors, 6 each. How many next rows fit depends only on the pattern: ABA allows 3 ABA and 2 ABC, ABC allows 2 ABA and 2 ABC. Pushing those two counts down row by row gives `O(n)`.
