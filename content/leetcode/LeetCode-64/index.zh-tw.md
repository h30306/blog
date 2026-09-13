---
title: "LeetCode 64: Minimum Path Sum"
summary: "LeetCode 64 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-27 的 LeetCode 64 學習紀錄，包含筆記修正點與正確解法"
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
來源：Day 30 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 1 - LC 64 Minimum Path Sum
- **Pattern:** 2D optimization DP on a grid.

#### Why This Fits
From each cell, you can still only arrive from:
- up
- left

But the question changed from:
```text
how many ways?
```

to:
```text
what is the minimum cost?
```

So the DP state now stores best cost, not count.

#### Core State / Invariant
```text
dp[r][c] = minimum path sum from the top-left corner to cell (r, c)
```

#### Base Cases
Start cell:
```text
dp[0][0] = grid[0][0]
```

First row:
- can only be reached from the left

So:
```text
dp[0][c] = dp[0][c - 1] + grid[0][c]
```

First column:
- can only be reached from above

So:
```text
dp[r][0] = dp[r - 1][0] + grid[r][0]
```

#### Transition
For interior cells:
```text
dp[r][c] = min(dp[r - 1][c], dp[r][c - 1]) + grid[r][c]
```

#### Why This Differs From LC 62
- `LC 62` counts valid paths:
  - add paths from up and left
- `LC 64` optimizes path cost:
  - choose the cheaper predecessor and add current cell cost

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
- mixing invalid directions into the recurrence with `0`
- forgetting explicit first-row / first-column initialization
- saying it is "same as LC 62" without noting count-vs-cost difference
- using `inf` in Python without importing it

#### Strong Spoken Explanation
I define `dp[r][c]` as the minimum path sum to reach cell `(r, c)`. The start cell is `grid[0][0]`. The first row and first column are accumulated sums because each boundary cell has only one legal incoming direction. For interior cells, the path must come from either above or left, so I take the smaller predecessor sum and add the current cell value. This is optimization DP, not counting DP, so the recurrence is `min(...) + grid[r][c]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def minPathSum(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        dp = [float('inf')] * n
        dp[0] = 0

        for r in range(m):
            for c in range(n):
                if c == 0:
                    dp[c] += grid[r][c]
                else:
                    dp[c] = grid[r][c] + min(dp[c], dp[c - 1])

        return dp[-1]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Using count-path recurrence instead of min-cost recurrence.
- Bad first row/column initialization.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
