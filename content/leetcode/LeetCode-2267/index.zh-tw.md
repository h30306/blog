---
title: "LeetCode 2267: Check if There Is a Valid Parentheses String Path"
summary: "LeetCode 2267 解題筆記：狀態是 (r, c, 左括號餘額)；餘額不能是負的，也不能超過剩下的步數；BFS / DP 搜尋這些狀態，走到終點時餘額為 0 就成立"
description: "2026-10-13 的 LeetCode 2267 解題紀錄"
date: 2026-10-13
tags: ["hard", "dynamic-programming", "grid-dp", "matrix", "bracket-sequences"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-13
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

括號字串是否合法，只需要知道**目前的餘額**（左括號數 − 右括號數）：過程中不能是負的、最後要是 0。所以狀態是 `(r, c, bal)`。

剪枝：

- 路徑長度 `m + n - 1` 是奇數、起點是 `)`、終點是 `(`：一定不行。
- `bal < 0`：已經不合法。
- `bal > 剩下的步數`：剩下的全部是 `)` 也關不完。

從 `(0, 0, 1)` 開始往右 / 下 BFS，用 `seen` 避免重複的狀態，走到終點而且 `bal == 0` 就回傳 `True`。

## 我的嘗試

前兩版想用一個 stack 模擬括號，但所有路徑**共用同一個 list**：`queue.append((nr, nc, stack))` 放進去的是同一個物件，一條路徑的 push / pop 會影響其他路徑。

| 版本 | 問題 |
|---|---|
| 第一版 | 起點時 stack 已經放了 `grid[0][0]`，處理起點時又放一次，起點的左括號被算兩次。例如 `[["(", ")"]]`：答案是 `True`，回傳 `False` |
| 第二版 | 修好起點，但 stack 還是共用的。例如 `[["(", ")"], ["(", ")"]]`：路徑長度是 3，不可能合法，答案是 `False`，回傳 `True` |
| AC | 改成用整數 `bal` 當狀態，加上剪枝和 `seen` |

## 正確解法

```python
from collections import deque

class Solution:
    def hasValidPath(self, grid: List[List[str]]) -> bool:
        m, n = len(grid), len(grid[0])
        if (m + n - 1) % 2 or grid[0][0] == ")" or grid[-1][-1] == "(":
            return False

        start = (0, 0, 1)
        seen = {start}
        queue = deque([start])
        while queue:
            r, c, bal = queue.popleft()
            if r == m - 1 and c == n - 1 and bal == 0:
                return True
            for nr, nc in ((r + 1, c), (r, c + 1)):
                if nr < m and nc < n:
                    nb = bal + (1 if grid[nr][nc] == "(" else -1)
                    remaining = (m - 1 - nr) + (n - 1 - nc)
                    if 0 <= nb <= remaining and (nr, nc, nb) not in seen:
                        seen.add((nr, nc, nb))
                        queue.append((nr, nc, nb))
        return False
```

## 複雜度

時間 `O(mn(m + n))`（餘額最多是路徑長度），空間一樣。

## 要特別避免的錯誤

- 把可變的 list 放進 queue：所有路徑共用同一個物件。
- 起點的括號不要重複算。
- 不剪 `bal > remaining` 會多搜很多不可能的狀態。

## 面試口說整理

括號合不合法只看餘額，所以狀態是位置加上餘額。我從起點往右 / 下 BFS，餘額不能是負的，也不能超過剩下的步數，用 `seen` 去掉重複的狀態，走到終點餘額剛好是 0 就成立。先排除路徑長度是奇數、起點是右括號、終點是左括號的情況。時間 `O(mn(m + n))`。
