---
title: "LeetCode 174: Dungeon Game"
summary: "LeetCode 174 解題筆記，依照原始 learning note 重新整理"
description: "2026-06-30 的 LeetCode 174 學習紀錄，包含筆記修正點與正確解法"
date: 2026-06-30
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
第一次嘗試：2026-06-30
來源：Day 31 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 174`: pass after wording repair
- `LC 221` and `LC 174` are both 2D DP, but they are not the same recurrence family as the earlier grid problems.
- explain `LC 174` with reverse DP and the `minimum required health on entry` state

## 當天筆記摘錄

#### Problem 2 - LC 174 Dungeon Game
- **Pattern:** reverse 2D DP with minimum required resource.

#### Why This Fits
Forward DP feels tempting but usually creates the wrong state question.

The real requirement is not:
```text
what is the best health after arriving here?
```

It is:
```text
what minimum health must I have when entering this cell so that I can still survive to the goal?
```

That naturally points backward from the destination.

#### Core State / Invariant
```text
dp[r][c] = minimum health required upon entering cell (r, c) to guarantee survival through the destination
```

This is the interview-safe state because it encodes the safety guarantee directly.

#### Transition
Let the cheaper required next state be:
```text
need_next = min(dp[r + 1][c], dp[r][c + 1])
```

Then:
```text
dp[r][c] = max(1, need_next - dungeon[r][c])
```

Why:
- if the current cell gives health, required entry health can drop
- if the current cell deals damage, required entry health rises
- health can never be below `1`

#### Base Case
At the destination:
```text
dp[last_row][last_col] = max(1, 1 - dungeon[last_row][last_col])
```

Reason:
- after processing the last cell, the knight must still have at least `1` health

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
- trying to maximize remaining health instead of minimizing required entry health
- doing forward DP with an unstable state
- forgetting the clamp to `1`
- using `max(down, right)` instead of `min(down, right)` for the required next state
- getting the destination base case wrong

#### Strong Spoken Explanation
I solve this backward because the meaningful state is the minimum health required when entering a cell so that I can still reach the princess alive. From each cell, I only care about the cheaper of the two required next states, right or down. Then I subtract the current cell value because healing reduces the needed entry health and damage increases it. Finally I clamp the result to at least `1`, because the knight can never be dead or at zero health.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def calculateMinimumHP(self, dungeon: List[List[int]]) -> int:
        m, n = len(dungeon), len(dungeon[0])
        dp = [float('inf')] * (n + 1)
        dp[n - 1] = 1

        for r in range(m - 1, -1, -1):
            for c in range(n - 1, -1, -1):
                need = min(dp[c], dp[c + 1]) - dungeon[r][c]
                dp[c] = max(1, need)

        return dp[0]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Forward DP cannot know future minimum health constraints cleanly.
- Forgetting health must always be at least 1.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
