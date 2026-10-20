---
title: "Interval DP"
summary: "Interval DP (choose the last step / merge equal ends), partition DP into k segments, palindrome tables plus partitioning, and memoizing the whole state when it is too tangled to split"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["dynamic-programming", "interval-dp", "memoization", "binary-search"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

In interval DP the state is a range `dp[i][j]`, built from **shorter ranges**, so fill the table **by length from short to long** (or use memoized recursion).

Common transitions:

| Form | Transition | Example |
|---|---|---|
| Choose the last step | `dp[i][j] = max(dp[i][k] + dp[k][j] + cost(i, k, j))` | Burst Balloons |
| Merge equal ends | handle `arr[i]` together with an equal `arr[k]` | Palindrome Removal |
| Split into k segments | `dp[i][k] = min(cost(i..j) + dp[j+1][k-1])` | job scheduling, split array |

Complexity is usually `O(n^3)` (`n^2` ranges × one split point each), so `n` is mostly at most about 500.

## Template 1: Choose the last step

**Think about the last action, not the first**: an early action changes the neighbors on both sides, so the subproblems are no longer independent; when the last action happens, both sides are finished and the neighbors are fixed.

```python
val = [1] + nums + [1]                   # pad both ends with 1
n = len(val)
dp = [[0] * n for _ in range(n)]         # dp[i][j]: open range (i, j) fully processed
for length in range(2, n):
    for i in range(n - length):
        j = i + length
        dp[i][j] = max(dp[i][k] + dp[k][j] + val[i] * val[k] * val[j]
                       for k in range(i + 1, j))   # k is the last balloon burst in (i, j)
return dp[0][n - 1]
```

(LC 312)

## Template 2: Merge equal ends

Removing palindromic subarrays: `arr[i]` is either removed on its own or together with a later equal `arr[k]` (once the middle is gone, the two ends become a palindrome's first and last):

```python
dp[i][j] = 1 + dp[i + 1][j]                       # remove arr[i] alone
if arr[i] == arr[j]:
    dp[i][j] = min(dp[i][j], dp[i + 1][j - 1] if j - i > 1 else 1)
for k in range(i, j):
    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k + 1][j])   # split into two parts
```

(LC 1246). For palindromic subsequences and insertion counts, see Interval Palindrome DP in [String DP]({{< relref "/algorithm/String-DP" >}}).

## Template 3: Split into k segments

Cut an array in order into `k` segments with a cost each, minimizing the total (or the largest segment):

```python
@cache
def dp(i, k):                            # start at i, k segments left
    if k == 1:
        return cost(i, n - 1)
    best = inf
    for j in range(i, n - k + 1):        # this segment is i..j; leave at least k - 1 items
        best = min(best, cost(i, j) + dp(j + 1, k - 1))
    return best
```

- **A day's difficulty is its hardest job** (LC 1335): `cost` is a range max, updated while enumerating instead of recomputed.
- **Minimize the largest segment** (LC 410): DP works, but the answer is monotonic (a higher cap makes splitting easier), so **binary search on the answer** is faster.
- **Split into 3 palindromes** (LC 1745): build `is_pal[i][j]` with interval DP first, then try both cut points, `O(n^2)`.

## When the state is too tangled: memoize the whole state

In Zuma (LC 488) an insertion triggers chain removals, so the board cannot be split into independent ranges. But the board and hand are short, so DFS with memoization on the whole `(board, hand)` works, with pruning: insert only next to a same-colored ball or between two equal balls.

## No DP needed: greedy

**Longest chunked palindrome** (LC 1147): move in from both ends and cut as soon as the left and right strings match; cutting early is always best, `O(n^2)` or `O(n)` with rolling hashes.

## Key Parameters

- Fill order: by length from short to long, or `i` descending with `j` ascending, so `dp[i + 1][...]` and `dp[...][j - 1]` are ready.
- Decide open vs closed ranges up front. Burst Balloons is easier with the open range `(i, j)` and 1s padded at the ends.
- When splitting, leave enough items for the remaining segments: `j` goes up to `n - k`.

## Complexity

Interval DP `O(n^3)`; `k` segments `O(k · n^2)`; binary search on the answer `O(n log(sum))`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **The min update outside the loop**: only the last split point was compared (LC 1335).
- **Recursion without memoization**: the same `(i, k)` recomputed many times, TLE (LC 1335).
- **A misspelled variable**: mixing `max_coin` and `max_coins`, UnboundLocalError (LC 312).
- **Wrong split ranges**: allowing an empty middle part, or excluding a last part of one character (LC 1745).
- **Over-pruning**: inserting only next to a same-colored ball misses splitting two equal balls in Zuma; after adding that, the insertion index was off by one (LC 488).

## Related LeetCode

- `LC 312` Burst Balloons
- `LC 1246` Palindrome Removal
- `LC 1335` Minimum Difficulty of a Job Schedule
- `LC 410` Split Array Largest Sum
- `LC 1745` Palindrome Partitioning IV
- `LC 488` Zuma Game
- `LC 1147` Longest Chunked Palindrome Decomposition
