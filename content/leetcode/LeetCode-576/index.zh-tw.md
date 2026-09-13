---
title: "LeetCode 576: Out of Boundary Paths"
summary: "LeetCode 576 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-05 的 LeetCode 576 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-05
tags: ["medium", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-05
來源：Day 34 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 576`: pass after base-case precision repair
- explain `LC 576` with the exact `(moves_left, row, col)` state and why leaving the grid returns `1`

## 當天筆記摘錄

#### Problem 2 - LC 576 Out of Boundary Paths
- **Pattern:** DP / memoization on position plus remaining moves.

#### Why This Fits
The target is not a destination cell.

The real question is:
```text
how many ways can I leave the grid if I start here with k moves remaining?
```

That makes the stable state:
- current position
- moves remaining

#### Core State / Invariant
For memo DFS:
```text
dp(moves_left, r, c) = number of ways to move out of the grid
starting from (r, c) with moves_left remaining
```

#### Base Cases
If already out of bounds:
```text
return 1
```

Reason:
```text
this path has successfully left the grid
```

If no moves remain and still in bounds:
```text
return 0
```

#### Transition
Try all four directions:
```text
up, down, left, right
```

So:
```text
dp(moves_left, r, c) =
    dp(moves_left - 1, r - 1, c) +
    dp(moves_left - 1, r + 1, c) +
    dp(moves_left - 1, r, c - 1) +
    dp(moves_left - 1, r, c + 1)
```

Take modulo at each step.

#### Complexity
With memo:
```text
Time: O(maxMove * m * n)
Space: O(maxMove * m * n)
```

#### Common Mistakes
- using a destination-style grid DP state
- forgetting that leaving the grid is a success state
- not memoizing and blowing up exponentially
- forgetting modulo

#### Strong Spoken Explanation
I model the state as `(moves_left, row, col)` because the number of valid ways depends on both the current position and how many moves I still have. If I step out of bounds, that contributes one successful path. If I run out of moves while still inside the grid, that contributes zero. From each in-bounds state, I try the four directions and sum the number of ways from the smaller subproblems. With memoization, each `(moves_left, row, col)` state is solved once, so the complexity becomes `O(maxMove * m * n)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def findPaths(self, m: int, n: int, maxMove: int, startRow: int, startColumn: int) -> int:
        mod = 10 ** 9 + 7
        dp = [[0] * n for _ in range(m)]
        dp[startRow][startColumn] = 1
        ans = 0
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        for _ in range(maxMove):
            ndp = [[0] * n for _ in range(m)]
            for r in range(m):
                for c in range(n):
                    if dp[r][c] == 0:
                        continue
                    for dr, dc in dirs:
                        nr, nc = r + dr, c + dc
                        if 0 <= nr < m and 0 <= nc < n:
                            ndp[nr][nc] = (ndp[nr][nc] + dp[r][c]) % mod
                        else:
                            ans = (ans + dp[r][c]) % mod
            dp = ndp

        return ans
```

## 複雜度

Time O(maxMove * m * n), Space O(mn).

## 要特別避免的錯誤

- Returning ways to reach a boundary cell instead of leaving the grid.
- Missing modulo.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
