---
title: "LeetCode 3905: Multi Source Flood Fill"
summary: "LeetCode 3905 解題筆記：多源 BFS 一次處理一層，先收集這一層每格的最大顏色，再一起寫回網格"
description: "2026-04-19 的 LeetCode 3905 解題紀錄"
date: 2026-04-19
tags: ["medium", "bfs", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-19
- 提交紀錄：Runtime Error → Accepted

## 解題思路

所有來源**同時**擴散，每一步都把顏色傳到上下左右還沒上色的格子；同一步有好幾個顏色到達同一格時，取最大的顏色。

這是多源 BFS，但要注意「同時」：

1. 一次處理一整層。
2. 先把這一層所有能到達的格子收集到 dict，同一格取最大的顏色。
3. 這一層處理完，才把結果寫回網格、推進下一層的 queue。

如果邊處理邊寫回網格，同一層先處理的來源會先佔住格子，後面顏色比較大的來源就進不去了。

## 我的嘗試：網格的長寬寫反

```python
matrix = [[0] * n for _ in range(m)]       # 應該是 [[0] * m for _ in range(n)]
```

題目的網格是 `n` 列、`m` 行，第一版建成了 `m` 列、`n` 行，`n != m` 時就越界。

## 正確解法

```python
from collections import deque

class Solution:
    def colorGrid(self, n: int, m: int, sources: List[List[int]]) -> List[List[int]]:
        grid = [[0] * m for _ in range(n)]
        q = deque()
        for r, c, color in sources:
            grid[r][c] = color
            q.append((r, c, color))

        while q:
            arrivals = {}
            for _ in range(len(q)):
                r, c, color = q.popleft()
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if 0 <= nr < n and 0 <= nc < m and grid[nr][nc] == 0:
                        arrivals[(nr, nc)] = max(arrivals.get((nr, nc), 0), color)
            for (nr, nc), color in arrivals.items():
                grid[nr][nc] = color
                q.append((nr, nc, color))
        return grid
```

原本的版本用兩層 `while`：內層把 queue 清空，外層再把這一層的結果推回去，效果一樣。

## 複雜度

時間 `O(nm)`，每格只會被上色一次。空間 `O(nm)`。

## 要特別避免的錯誤

- 網格的長寬寫反。
- 邊處理邊寫回網格：同一層的比較結果會被提早寫入的值影響。
- 顏色衝突時取了先到的而不是最大的。

## 面試口說整理

我用多源 BFS，一開始把所有來源放進 queue。因為擴散是同時發生的，我一次處理一整層：先把這一層能到達的空格收集起來，同一格取最大的顏色，這一層結束後才一起寫回網格並推進 queue。每格只會被上色一次，時間 `O(nm)`。
