---
title: "LeetCode 773: Sliding Puzzle"
summary: "LeetCode 773 解題筆記：盤面只有 6! = 720 種，把盤面攤平成字串當 BFS 的狀態，0 跟相鄰格交換就是下一個狀態"
description: "2026-09-07 的 LeetCode 773 解題紀錄"
date: 2026-09-07
tags: ["hard", "breadth-first-search", "dynamic-programming", "memoization", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-07
- 提交紀錄：Accepted（一次通過）

## 解題思路

2 × 3 的盤面只有 `6! = 720` 種排列，可以把整個盤面當成一個狀態做 **BFS**，第一次走到目標的步數就是最少步數（見 [BFS]({{< relref "/algorithm/BFS" >}}) 的狀態空間 BFS）。

- 狀態：把盤面攤平成長度 6 的字串，例如 `"412503"`。
- 轉移：找到 `0` 的位置，跟相鄰的格子交換。攤平後每個位置的鄰居是固定的，先寫成表：

```text
0 1 2
3 4 5
```

`0: [1, 3]`、`1: [0, 2, 4]`、`2: [1, 5]`、`3: [0, 4]`、`4: [1, 3, 5]`、`5: [2, 4]`。

BFS 結束都沒碰到 `"123450"` 就回傳 -1。

## 我的解法

```python
from collections import deque

class Solution:
    def slidingPuzzle(self, board: List[List[int]]) -> int:
        start = "".join(str(x) for row in board for x in row)
        target = "123450"
        neighbors = {0: [1, 3], 1: [0, 2, 4], 2: [1, 5], 3: [0, 4], 4: [1, 3, 5], 5: [2, 4]}

        queue = deque([(start, 0)])
        seen = {start}
        while queue:
            state, moves = queue.popleft()
            if state == target:
                return moves
            z = state.index("0")
            for nb in neighbors[z]:
                s = list(state)
                s[z], s[nb] = s[nb], s[z]
                nxt = "".join(s)
                if nxt not in seen:
                    seen.add(nxt)
                    queue.append((nxt, moves + 1))
        return -1
```

## 複雜度

最多 720 個狀態，每個最多 3 個鄰居，常數時間。

## 要特別避免的錯誤

- 用 list 當狀態：list 不能放進 `set`，要轉成字串或 tuple。
- 攤平後左右的鄰居要注意換行：位置 2 和位置 3 不相鄰。

## 面試口說整理

盤面只有 720 種，所以我把整個盤面攤平成字串當 BFS 的狀態，每一步把 0 跟相鄰的格子交換，用 `seen` 去重，第一次走到目標就是最少步數，走不到就回傳 -1。鄰居關係先寫成表，避免攤平後誤把換行的兩格當成相鄰。
