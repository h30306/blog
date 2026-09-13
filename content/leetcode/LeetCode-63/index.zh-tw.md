---
title: "LeetCode 63: Unique Paths II"
summary: "LeetCode 63 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-27 的 LeetCode 63 學習紀錄，包含筆記修正點與正確解法"
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

## 筆記中提到的相關提醒

- `LC 63`: pass after boundary pushback

## 當天筆記摘錄

#### Problem 2 - LC 63 Unique Paths II
- **Pattern:** 2D counting DP with blocked cells.

#### Why This Fits
This is the same table as `LC 62`, with one upgrade:
```text
some cells are unreachable because they are obstacles
```

So the real test is not a new pattern.

It is whether you can preserve the old state meaning under a new legality rule.

#### Core State / Invariant
```text
dp[r][c] = number of valid paths from the start to cell (r, c) without stepping on obstacles
```

#### Base Cases
If the start cell is blocked:
```text
answer = 0
```

Otherwise:
```text
dp[0][0] = 1
```

Boundary nuance:
- first row cells stay reachable only until the first obstacle appears
- first column cells stay reachable only until the first obstacle appears

Because after an obstacle on the boundary:
```text
there is no alternative route from above or left on that boundary
```

#### Transition
If the current cell is an obstacle:
```text
dp[r][c] = 0
```

Otherwise:
```text
dp[r][c] = dp[r - 1][c] + dp[r][c - 1]
```

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can also be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- forgetting that blocked start cell means immediate `0`
- filling the first row / first column with `1` even after an obstacle already appeared
- using the `LC 62` recurrence blindly without zeroing obstacle cells
- saying the obstacle cell is `-inf` or `None` instead of `0` ways

#### Strong Spoken Explanation
I keep the same state as `LC 62`: `dp[r][c]` is the number of valid paths to cell `(r, c)`. The difference is that obstacle cells contribute zero paths because I am not allowed to stand on them. If the start is blocked, the answer is immediately zero. For non-obstacle cells, the recurrence is still `up + left`, but the boundary initialization must stop once an obstacle appears because cells later on that boundary are no longer reachable from only one direction.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def uniquePathsWithObstacles(self, obstacleGrid: List[List[int]]) -> int:
        m, n = len(obstacleGrid), len(obstacleGrid[0])
        dp = [0] * n
        dp[0] = 1

        for r in range(m):
            for c in range(n):
                if obstacleGrid[r][c] == 1:
                    dp[c] = 0
                elif c > 0:
                    dp[c] += dp[c - 1]

        return dp[-1]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Not clearing dp[c] when hitting an obstacle.
- Assuming the start cell is always open.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
