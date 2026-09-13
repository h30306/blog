---
title: "LeetCode 62: Unique Paths"
summary: "LeetCode 62 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-27 的 LeetCode 62 學習紀錄，包含筆記修正點與正確解法"
date: 2026-06-27
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
第一次嘗試：2026-06-27
來源：Day 29 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 62 Unique Paths
- **Pattern:** 2D counting DP on a grid.

#### Why This Fits
From any cell, the robot can only arrive from:
- the cell above
- the cell to the left

So the number of ways to reach one cell depends only on smaller subproblems directly adjacent to it.

#### Core State / Invariant
```text
dp[r][c] = number of valid paths from the start to cell (r, c)
```

This is the right state because the question asks for:
```text
how many ways to reach the bottom-right corner
```

So every cell should mean:
```text
answer for this prefix of the grid
```

#### Base Cases
Start cell:
```text
dp[0][0] = 1
```

First row:
- every cell has only one way to be reached:
  - keep moving right

First column:
- every cell has only one way to be reached:
  - keep moving down

So for the obstacle-free version:
```text
dp[0][c] = 1
dp[r][0] = 1
```

#### Transition
For every interior cell:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

Why:
- every valid path into `(r, c)` must come from exactly one of those two predecessor cells
- the two predecessor sets are disjoint

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

1D compression is possible:
```text
Space: O(n)
```

But the Week 6 interview bar is:
```text
draw or define the 2D table first, then compress only if you still preserve the invariant cleanly
```

#### Common Mistakes
- writing the recurrence before defining what `dp[r][c]` means
- mixing `m/n` dimensions and indexing incorrectly
- forgetting why the first row and first column are all `1`
- jumping to combinatorics instead of showing the DP state first

#### Strong Spoken Explanation
I define `dp[r][c]` as the number of valid paths from the start to cell `(r, c)`. That state fits because the robot can only move right or down, so every path into a cell must come from the cell above or the cell to the left. The start cell has one way to be reached, and every boundary cell in the obstacle-free grid also has only one path. For interior cells, I add the ways from above and from the left. The time complexity is `O(m * n)`, and the space can be either `O(m * n)` or compressed to `O(n)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        dp = [1] * n
        for _ in range(1, m):
            for c in range(1, n):
                dp[c] += dp[c - 1]
        return dp[-1]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Confusing this with weighted min path sum.
- Forgetting first row/column base cases.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
