---
title: "LeetCode 996: Number of Squareful Arrays"
summary: "LeetCode 996 note: with n at most 12, use bitmask DP: dp[mask][last] = permutations using the set mask and ending with last; dedupe by using equal values in index order"
description: "LeetCode 996 record from 2026-09-09"
date: 2026-09-09
tags: ["hard", "dynamic-programming", "bitmask", "backtracking", "math", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-09
- Submissions: Runtime Error → Accepted

## Approach

With `n <= 12`, a bitmask can record which numbers are used. `dp[mask][last]` = the number of valid arrangements using the positions in `mask` and ending with `nums[last]`:

- An unused `nxt` with `nums[last] + nums[nxt]` a perfect square moves to `dp[mask | 1 << nxt][nxt]`.
- The answer is `sum(dp[full][last])`.

**Deduplication**: swapping equal numbers gives the same permutation. Sort, and require equal values to be **used in index order**: when `nums[nxt] == nums[nxt - 1]`, `nxt` may be used only after `nxt - 1`. Each permutation then appears once.

## My Attempts

I wrote backtracking with pruning (after sorting, skip when the previous equal value is unused), the same dedupe idea. Attempt 1 hit a runtime error: a condition used `=` instead of `==`, a syntax error; that version also had `visited[num]`, `res += 1` without `nonlocal`, and recursion passing `i + 1` instead of `length + 1`. Fixing all of them passed (2.4 seconds).

## Solution

```python
from math import isqrt

class Solution:
    def numSquarefulPerms(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        is_sq = lambda x: isqrt(x) ** 2 == x
        ok = [[is_sq(nums[i] + nums[j]) for j in range(n)] for i in range(n)]

        dp = [[0] * n for _ in range(1 << n)]      # dp[mask][last]
        for i in range(n):
            if i == 0 or nums[i] != nums[i - 1]:   # equal values start from the first copy only
                dp[1 << i][i] = 1
        for mask in range(1 << n):
            for last in range(n):
                if not dp[mask][last]:
                    continue
                for nxt in range(n):
                    if mask >> nxt & 1 or not ok[last][nxt]:
                        continue
                    if nxt > 0 and nums[nxt] == nums[nxt - 1] and not mask >> (nxt - 1) & 1:
                        continue                   # equal values in index order
                    dp[mask | 1 << nxt][nxt] += dp[mask][last]
        return sum(dp[(1 << n) - 1])
```

Backtracking version:

```python
from math import isqrt

class Solution:
    def numSquarefulPerms(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        used = [False] * n

        def backtrack(length: int, prev: int) -> int:
            if length == n:
                return 1
            count = 0
            for i in range(n):
                if used[i]:
                    continue
                if i > 0 and nums[i] == nums[i - 1] and not used[i - 1]:
                    continue                       # dedupe
                if length == 0 or isqrt(prev + nums[i]) ** 2 == prev + nums[i]:
                    used[i] = True
                    count += backtrack(length + 1, nums[i])
                    used[i] = False
            return count

        return backtrack(0, -1)
```

My accepted version used `visited[i - 1]` (skip if the previous equal value is already used); this one uses `not used[i - 1]`. Both dedupe, just fixing the opposite order of use.

## Complexity

Bitmask DP: time `O(2^n · n^2)`, space `O(2^n · n)`. Backtracking is exponential in the worst case too, but the square constraint prunes heavily.

## Mistakes to Avoid

- No deduplication: swapping equal numbers counts as different permutations.
- Test perfect squares with `math.isqrt`, not a floating-point square root.

## Interview Explanation

With `n` at most 12 I use bitmask DP: `dp[mask][last]` counts arrangements using the numbers in `mask` and ending with `last`, extended by any unused number whose sum with `last` is a perfect square. Repeated numbers must be used in index order, so each permutation counts once. Time `O(2^n · n^2)`. Backtracking with the same dedupe also works.
