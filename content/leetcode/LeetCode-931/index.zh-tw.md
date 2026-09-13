---
title: "LeetCode 931: Minimum Falling Path Sum"
summary: "LeetCode 931 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-04 的 LeetCode 931 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-04
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
第一次嘗試：2026-07-04
來源：Day 32 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 931`: pass after wording repair
- explain `LC 931` with the exact state, legal predecessor set, and why the answer is the min of the last row

## 當天筆記摘錄

#### Problem 1 - LC 931 Minimum Falling Path Sum
- **Pattern:** 2D optimization DP with three incoming directions.

#### Why This Fits
Each cell in row `r` can be reached from exactly one of 3 cells in row `r - 1`:
- up-left
- up
- up-right

The graph is still acyclic and local, so DP fits cleanly.

#### Core State / Invariant
```text
dp[r][c] = minimum falling path sum that ends at cell (r, c)
```

That state is exact because the question asks for:
```text
the minimum sum of any valid falling path from the first row to the last row
```

#### Base Case
First row:
```text
dp[0][c] = matrix[0][c]
```

Reason:
- a falling path can start at any cell in the first row

#### Transition
For each lower-row cell:
```text
dp[r][c] = matrix[r][c] + min(
    dp[r - 1][c],
    dp[r - 1][c - 1] if valid,
    dp[r - 1][c + 1] if valid
)
```

#### Final Answer
```text
answer = min(dp[last_row][c] for all c)
```

Because the path may end at any column in the last row.

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- returning `dp[last_row][last_col]` instead of the min over the last row
- forgetting diagonal parents
- mixing invalid columns into the recurrence without guarding them
- saying it is the same as `LC 64` when the predecessor set and answer shape are different

#### Strong Spoken Explanation
I define `dp[r][c]` as the minimum falling path sum ending at cell `(r, c)`. The first row is the base case because a path can start at any top-row cell. For each later cell, I take the minimum among the legal parents from the previous row: up-left, up, and up-right, then add the current cell value. The final answer is the minimum value in the last row because a falling path can end in any column there.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def minFallingPathSum(self, matrix: List[List[int]]) -> int:
        n = len(matrix)
        prev = matrix[0][:]

        for r in range(1, n):
            curr = [0] * n
            for c in range(n):
                best = prev[c]
                if c > 0:
                    best = min(best, prev[c - 1])
                if c + 1 < n:
                    best = min(best, prev[c + 1])
                curr[c] = matrix[r][c] + best
            prev = curr

        return min(prev)
```

## 複雜度

Time O(n^2), Space O(n).

## 要特別避免的錯誤

- Returning bottom-right only; any bottom cell can end the path.
- Using LC 64 right/down movement instead of falling predecessors.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
