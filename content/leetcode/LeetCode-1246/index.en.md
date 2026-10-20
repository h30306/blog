---
title: "LeetCode 1246: Palindrome Removal"
summary: "LeetCode 1246 note: interval DP taking the minimum of removing arr[i] alone, removing equal ends together with the inside, or splitting into two parts"
description: "LeetCode 1246 record from 2026-09-12"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "interval-dp", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-12
- Submissions: Accepted (first try)

## Approach

`dp[i][j]` = the fewest moves to remove all of `arr[i..j]`. Three cases:

1. **Remove `arr[i]` alone**: `1 + dp[i + 1][j]`.
2. **Equal ends** (`arr[i] == arr[j]`): remove the middle down to a single palindrome, then take both ends along with that final removal, costing the same as the middle alone: `dp[i + 1][j - 1]` (1 when the middle is empty).
3. **Split into two parts**: `dp[i][k] + dp[k + 1][j]`.

Fill by length from short to long.

## My Solution

```python
class Solution:
    def minimumMoves(self, arr: List[int]) -> int:
        n = len(arr)
        dp = [[0] * n for _ in range(n)]           # dp[i][j]: fewest moves to clear arr[i..j]
        for i in range(n):
            dp[i][i] = 1
        for length in range(2, n + 1):
            for i in range(n - length + 1):
                j = i + length - 1
                dp[i][j] = 1 + dp[i + 1][j]        # remove arr[i] alone
                if arr[i] == arr[j]:               # ends go with the middle's final removal
                    dp[i][j] = min(dp[i][j], dp[i + 1][j - 1] if length > 2 else 1)
                for k in range(i, j):              # split into two parts
                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j])
        return dp[0][n - 1]
```

## Complexity

Time `O(n^3)` with `n <= 100`. Space `O(n^2)`.

## Mistakes to Avoid

- With equal ends the cost is `dp[i + 1][j - 1]`, not one more: the ends ride along with the middle's final removal.
- For length 2 the middle is empty, so the cost is 1.

## Interview Explanation

`dp[i][j]` is the fewest moves to clear the range. The left end can go alone; if the ends match, clear the middle down to one palindrome and remove the ends with that final move, costing the same as the middle; or split somewhere and clear both parts. Take the minimum, filling by length, `O(n^3)`.
