---
title: "LeetCode 221: Maximal Square"
summary: "LeetCode 221 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-30 的 LeetCode 221 學習紀錄，包含筆記修正點與正確解法"
date: 2026-06-30
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
第一次嘗試：2026-06-30
來源：Day 31 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 221`: pass after wording repair
- `LC 221` and `LC 174` are both 2D DP, but they are not the same recurrence family as the earlier grid problems.
- explain `LC 221` with the exact state, why the diagonal matters, and why the recurrence uses `min`

## 當天筆記摘錄

#### Problem 1 - LC 221 Maximal Square
- **Pattern:** 2D DP on local square geometry.

#### Why This Fits
To know the largest all-`1` square ending at `(r, c)`, it is not enough to know one direction.

The cell can only extend a larger square if:
- the current cell is `1`
- the top cell can support a square
- the left cell can support a square
- the top-left diagonal can support the smaller inner square

This is a clean local-structure DP.

#### Core State / Invariant
```text
dp[r][c] = side length of the largest all-1 square whose bottom-right corner is (r, c)
```

That state is exact enough because the question asks for:
```text
the largest square area anywhere in the matrix
```

If we know the best square ending at every cell, the global maximum is easy to track.

#### Transition
If `matrix[r][c] == '0'`:
```text
dp[r][c] = 0
```

If `matrix[r][c] == '1'` and the cell is not on the top row or left column:
```text
dp[r][c] = 1 + min(dp[r - 1][c], dp[r][c - 1], dp[r - 1][c - 1])
```

Boundary cells with `1` have:
```text
dp[r][c] = 1
```

#### Why The `min(...)` Is Correct
The new square can only be as large as its weakest supporting side:
- top limits vertical extension
- left limits horizontal extension
- top-left limits the inner square

If any one of those is smaller, the larger square is impossible.

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- using `max(...)` instead of `min(...)`
- forgetting the state is side length, not area
- failing to special-case first row / first column
- saying the diagonal is optional
- returning the max side length instead of squaring it for area

#### Strong Spoken Explanation
I define `dp[r][c]` as the side length of the largest all-1 square ending at cell `(r, c)`. If the current cell is `0`, no square can end here. If it is `1`, the square can only grow if the top, left, and top-left neighbors can all support a square of the smaller size. That is why the recurrence is `1 + min(top, left, diagonal)`. I track the largest side seen and square it at the end to get the area.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def maximalSquare(self, matrix: List[List[str]]) -> int:
        m, n = len(matrix), len(matrix[0])
        dp = [0] * (n + 1)
        best = 0

        for r in range(1, m + 1):
            prev_diag = 0
            for c in range(1, n + 1):
                old = dp[c]
                if matrix[r - 1][c - 1] == '1':
                    dp[c] = 1 + min(dp[c], dp[c - 1], prev_diag)
                    best = max(best, dp[c])
                else:
                    dp[c] = 0
                prev_diag = old

        return best * best
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Returning side length instead of area.
- Ignoring the diagonal dependency.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
