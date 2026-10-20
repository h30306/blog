---
title: "LeetCode 552: Student Attendance Record II"
summary: "LeetCode 552 note: state machine DP with state \"A used × trailing L run\", 6 states; each day's P, A or L picks the next state"
description: "LeetCode 552 record from 2026-07-08"
date: 2026-07-08
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
First Attempt: 2026-07-08
- Submissions: Accepted ×3 (three styles on the same day)

## Approach

Validity depends on only two things: **how many A's in total** (0 or 1) and **how many L's at the end in a row** (0, 1 or 2). So the state is `(a, l)`, 6 in all, and `dp[a][l]` counts records of the current length in that state.

Each day picks a character:

- **P**: A unchanged, L resets → `(a, 0)`.
- **A**: only from `a = 0`, L resets → `(1, 0)`.
- **L**: A unchanged, `l + 1`, only from `l < 2` → `(a, l + 1)`.

Start with only `(0, 0)` at 1, run `n` days, and sum the 6 states.

## My Solution

```python
class Solution:
    def checkRecord(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        dp = [[0] * 3 for _ in range(2)]           # dp[a][l]
        dp[0][0] = 1
        for _ in range(n):
            ndp = [[0] * 3 for _ in range(2)]
            for a in range(2):
                for l in range(3):
                    cur = dp[a][l]
                    if not cur:
                        continue
                    ndp[a][0] = (ndp[a][0] + cur) % MOD            # P
                    if a == 0:
                        ndp[1][0] = (ndp[1][0] + cur) % MOD        # A
                    if l < 2:
                        ndp[a][l + 1] = (ndp[a][l + 1] + cur) % MOD   # L
            dp = ndp
        return sum(map(sum, dp)) % MOD
```

My first accepted version used 6 variables for the states and listed where each comes from (e.g. `(0, 0)` comes from `(0, 0)`, `(0, 1)`, `(0, 2)` with a P), which is faster (475ms vs over 2 seconds); the "push each state forward" style above is harder to get wrong.

## Complexity

Time `O(6n)`, space `O(1)`. (Matrix exponentiation can reach `O(log n)`.)

## Mistakes to Avoid

- Choosing A resets L, because the A breaks the run of L's.
- Use a fresh `ndp` each round instead of updating `dp` in place.

## Interview Explanation

Validity depends only on the number of A's and the trailing run of L's, so there are 2 × 3 = 6 states. Each day, P resets the L run, A is allowed only if no A has been used and also resets L, and L extends the run but not to 3. Running `n` days from the start state and summing every state gives the answer. Time `O(n)`.
