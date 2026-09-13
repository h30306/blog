---
title: "LeetCode 1289: Minimum Falling Path Sum II"
summary: "LeetCode 1289 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-05 的 LeetCode 1289 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-05
tags: ["hard", "dynamic-programming", "grid-dp"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-05
來源：Day 34 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 1289`: pass after state-vs-optimization repair
- explain `LC 1289` with the exact state and why the min/second-min optimization is needed

## 當天筆記摘錄

#### Problem 1 - LC 1289 Minimum Falling Path Sum II
- **Pattern:** row-by-row optimization DP with forbidden same-column reuse.

#### Why This Fits
This is still DP because:
- the path is built one row at a time
- the best answer for the current row depends only on the previous row

But the rule changed:
```text
the next row cannot choose the same column as the previous row
```

The naive recurrence is still correct:
```text
dp[r][c] = grid[r][c] + min(dp[r - 1][prev_c] for all prev_c != c)
```

But that costs `O(n)` per cell and becomes:
```text
O(n^3)
```

#### Core State / Invariant
```text
dp[r][c] = minimum falling path sum ending at row r, column c,
subject to not using the same column in adjacent rows
```

#### Key Optimization
For the previous row, track:
- smallest value
- column of that smallest value
- second-smallest value

Then for current column `c`:
- if `c` is not the min column from the previous row, use previous-row min
- otherwise use previous-row second min

#### Optimized Transition
```text
dp[r][c] = grid[r][c] + (
    prev_min if c != prev_min_col else prev_second_min
)
```

#### Base Case
First row:
```text
dp[0][c] = grid[0][c]
```

#### Final Answer
```text
min(dp[last_row][c] for all c)
```

#### Complexity
Naive:
```text
Time: O(n^3)
Space: O(n^2)
```

Optimized:
```text
Time: O(n^2)
Space: O(n^2)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- giving the naive recurrence but not noticing it is too slow
- forgetting why second-minimum is needed
- mixing up min value with min column
- returning one fixed cell instead of the min of the last row

#### Strong Spoken Explanation
I still define `dp[r][c]` as the minimum valid falling path sum ending at `(r, c)`, but the constraint is that adjacent rows cannot use the same column. The naive transition checks every previous-row column except `c`, which is correct but too slow. The optimization is to keep the smallest and second-smallest DP values from the previous row. Then for each current column, I use the previous-row minimum unless it came from the same column, in which case I use the second minimum. That reduces the time from `O(n^3)` to `O(n^2)`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def minFallingPathSum(self, grid: List[List[int]]) -> int:
        n = len(grid)
        prev = grid[0][:]

        for r in range(1, n):
            min1 = min2 = float('inf')
            idx1 = -1
            for c, val in enumerate(prev):
                if val < min1:
                    min2 = min1
                    min1 = val
                    idx1 = c
                elif val < min2:
                    min2 = val

            curr = [0] * n
            for c in range(n):
                best_prev = min2 if c == idx1 else min1
                curr[c] = grid[r][c] + best_prev
            prev = curr

        return min(prev)
```

## 複雜度

Time O(n^2), Space O(n).

## 要特別避免的錯誤

- Using the same column from the previous row.
- Doing O(n^3) by scanning every previous column for every cell.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
