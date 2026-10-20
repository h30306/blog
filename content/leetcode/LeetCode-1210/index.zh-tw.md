---
title: "LeetCode 1210: Minimum Moves to Reach Target with Rotations"
summary: "LeetCode 1210 解題筆記：BFS 的狀態是 (蛇尾位置, 方向)，四種移動各自檢查需要空的格子；每步成本相同不需要 heap"
description: "2026-09-12 的 LeetCode 1210 解題紀錄"
date: 2026-09-12
tags: ["hard", "bfs", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-12
- 提交紀錄：Accepted（heap）→ Accepted（deque）→ Accepted（狀態改成三維）

## 解題思路

蛇佔兩格，一開始在 `(0,0)-(0,1)`，要走到 `(n-1,n-2)-(n-1,n-1)`。每一步可以往右、往下、或旋轉。

每一步成本都是 1，所以用 BFS。狀態用**蛇尾（左上那格）的位置加上方向**表示：`(r, c, d)`，`d = 0` 是水平、`d = 1` 是垂直。

四種移動各自需要哪些格子是空的：

| 目前方向 | 動作 | 需要空的格子 | 新狀態 |
|---|---|---|---|
| 水平 | 往右 | `(r, c+2)` | `(r, c+1, 0)` |
| 水平 | 往下 | `(r+1, c)`、`(r+1, c+1)` | `(r+1, c, 0)` |
| 水平 | 順時針轉 | `(r+1, c)`、`(r+1, c+1)` | `(r, c, 1)` |
| 垂直 | 往右 | `(r, c+1)`、`(r+1, c+1)` | `(r, c+1, 1)` |
| 垂直 | 往下 | `(r+2, c)` | `(r+1, c, 1)` |
| 垂直 | 逆時針轉 | `(r, c+1)`、`(r+1, c+1)` | `(r, c, 0)` |

水平時「往下」和「順時針轉」需要的格子一樣；垂直時「往右」和「逆時針轉」也一樣。

## 我的嘗試

第一版用 heap，存 `(步數, 蛇尾, 蛇頭, 方向)`。每一步成本都一樣，BFS 用普通 queue 就會依步數順序處理，heap 只是多了 `log` 的成本。第二版改成 deque。

第三版把狀態從「蛇尾加蛇頭的四個座標」簡化成「蛇尾加方向」，`visited` 改成三維陣列，也把六種移動整理成上面那張表的樣子。

## 正確解法

```python
from collections import deque

class Solution:
    def minimumMoves(self, grid: List[List[int]]) -> int:
        n = len(grid)
        seen = {(0, 0, 0)}
        q = deque([(0, 0, 0, 0)])                     # r, c, d, moves
        while q:
            r, c, d, moves = q.popleft()
            if (r, c, d) == (n - 1, n - 2, 0):
                return moves
            nxt = []
            if d == 0:
                if c + 2 < n and grid[r][c + 2] == 0:
                    nxt.append((r, c + 1, 0))
                if r + 1 < n and grid[r + 1][c] == 0 and grid[r + 1][c + 1] == 0:
                    nxt.append((r + 1, c, 0))
                    nxt.append((r, c, 1))
            else:
                if r + 2 < n and grid[r + 2][c] == 0:
                    nxt.append((r + 1, c, 1))
                if c + 1 < n and grid[r][c + 1] == 0 and grid[r + 1][c + 1] == 0:
                    nxt.append((r, c + 1, 1))
                    nxt.append((r, c, 0))
            for state in nxt:
                if state not in seen:
                    seen.add(state)
                    q.append((*state, moves + 1))
        return -1
```

## 複雜度

時間 `O(n^2)`：狀態最多 `2n^2` 個，每個最多 3 種移動。空間 `O(n^2)`。

## 要特別避免的錯誤

- 旋轉時只檢查蛇頭要去的那格：旋轉時掃過的對角格也必須是空的。
- 每步成本相同卻用 heap。
- 狀態用四個座標：可以，但用蛇尾加方向比較簡潔，也不容易寫錯。

## 面試口說整理

每一步成本都是 1，所以用 BFS。我用蛇尾的位置加上水平或垂直表示狀態，水平時可以往右、往下、順時針轉，垂直時可以往下、往右、逆時針轉，每種動作各自檢查需要空的格子；旋轉需要的格子跟平移到另一邊相同。第一次到達終點狀態時的步數就是答案，狀態數是 `O(n^2)`。
