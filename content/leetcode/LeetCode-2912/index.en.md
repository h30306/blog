---
title: "LeetCode 2912: Number of Ways to Reach Destination in the Grid"
summary: "LeetCode 2912 note: many cells, but only four classes relative to the destination (itself, same row, same column, neither); each class's total moves together in O(k)"
description: "LeetCode 2912 record from 2026-07-30"
date: 2026-07-30
tags: ["hard", "dynamic-programming", "state-machine", "math", "combinatorics"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-07-30
- Submissions: Wrong Answer → Accepted ×2

## Approach

Each step moves to any other cell in the same row or column. There are `n × m` cells, but relative to the destination `(dx, dy)` only four classes, and **cells in a class behave identically**:

| Class | Condition | Cells |
|---|---|---|
| 0 | the destination | 1 |
| 1 | `x == dx`, `y != dy` (same row) | `m - 1` |
| 2 | `x != dx`, `y == dy` (same column) | `n - 1` |
| 3 | neither | the rest |

`dp[c]` = the total ways to be at **any cell of class `c`**. From one cell, the reachable classes are:

- From the destination: `m - 1` cells of class 1 and `n - 1` of class 2.
- From a class-1 cell `(dx, y)`: the destination, the other `m - 2` class-1 cells, and `n - 1` cells in its column, all class 3.
- From class 2: symmetric.
- From a class-3 cell `(x, y)`: `(dx, y)` is class 1, `(x, dy)` is class 2, and the other `n + m - 4` cells are class 3.

```text
new0 = dp1 + dp2
new1 = (m - 1) dp0 + (m - 2) dp1 + dp3
new2 = (n - 1) dp0 + (n - 2) dp2 + dp3
new3 = (n - 1) dp1 + (m - 1) dp2 + (n + m - 4) dp3
```

## My Attempts

Attempt 1 mixed two meanings in its transitions: some coefficients were derived as "ways to one specific cell" and others as "the total over a class", so coefficients ended up in the wrong places. For `n = 2`, `m = 4`, `k = 2`, from `[2, 4]` to `[1, 1]`, the answer is 2 (via `[2, 1]` or `[1, 4]`); it returned 6.

Settling on "`dp[c]` is the class total" and deriving every coefficient from "which classes one cell of this class reaches, and how many cells of each" fixed it.

## Solution

```python
class Solution:
    def numberOfWays(self, n: int, m: int, k: int, source: List[int], dest: List[int]) -> int:
        MOD = 10 ** 9 + 7
        sx, sy = source
        dx, dy = dest
        dp = [0, 0, 0, 0]                          # total ways for each of the four classes
        if (sx, sy) == (dx, dy):
            dp[0] = 1
        elif sx == dx:
            dp[1] = 1
        elif sy == dy:
            dp[2] = 1
        else:
            dp[3] = 1

        for _ in range(k):
            d0, d1, d2, d3 = dp
            dp = [
                (d1 + d2) % MOD,
                ((m - 1) * d0 + (m - 2) * d1 + d3) % MOD,
                ((n - 1) * d0 + (n - 2) * d2 + d3) % MOD,
                ((n - 1) * d1 + (m - 1) * d2 + (n + m - 4) * d3) % MOD,
            ]
        return dp[0]
```

## Complexity

Time `O(k)`, space `O(1)`. (Fast exponentiation of the 4 × 4 transition matrix gives `O(log k)`.)

## Mistakes to Avoid

- Keep one meaning for `dp`: the class total, not one cell's count.
- You cannot stay in place, so within-class transitions are `m - 2` and `n - 2`, not `m - 1` and `n - 1`.

## Interview Explanation

There are many cells, but only four classes relative to the destination, and cells in a class behave the same. I store in `dp` the total ways across each class; counting how many cells of each class one cell can reach gives the transition coefficients. After `k` steps I return the destination's class. Time `O(k)`.
