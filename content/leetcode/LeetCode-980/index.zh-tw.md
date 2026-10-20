---
title: "LeetCode 980: Unique Paths III"
summary: "LeetCode 980 解題筆記：網格回溯，原地標記走過的格子，到終點時檢查是否走過所有空格"
description: "2026-07-26 的 LeetCode 980 解題紀錄"
date: 2026-07-26
tags: ["hard", "backtracking", "matrix", "dfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-26
- 提交紀錄：Accepted（一次通過）

## 解題思路

從起點走到終點，**每個非障礙格都要剛好走過一次**。網格最多 20 格，可以直接回溯所有路徑。

1. 先數出非障礙格的總數 `total`（包含起點和終點）。
2. 從起點 DFS，走過的格子原地標成 `-1`，回來時還原。
3. 走到終點時，如果已經走過 `total` 格，就是一條合法路徑。

## 我的解法

```python
class Solution:
    def uniquePathsIII(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        total = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] != -1:
                    total += 1
                if grid[i][j] == 1:
                    start = (i, j)

        def dfs(r: int, c: int, visited: int) -> int:
            if grid[r][c] == 2:
                return 1 if visited == total else 0      # 到終點就停
            original = grid[r][c]
            grid[r][c] = -1
            count = 0
            for dr, dc in ((0, 1), (1, 0), (-1, 0), (0, -1)):
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] != -1:
                    count += dfs(nr, nc, visited + 1)
            grid[r][c] = original
            return count

        return dfs(*start, 1)
```

`visited` 是包含目前這格在內、已經走過的格數，從起點開始算 1。

原本的版本在終點但步數不對時沒有停下來，會從終點繼續往外走。終點會被標成走過，所以之後不可能再回到終點，結果不會算錯，只是多走了一些不可能成功的路。上面改成到終點就直接回傳。

## 複雜度

最壞 `O(3^k)`，`k` 是非障礙格數：除了第一步，每一步最多有 3 個方向可以走（不能走回頭）。空間 `O(k)`，遞迴深度。

## 要特別避免的錯誤

- 步數的計算差 1：要想清楚 `total` 有沒有包含起點和終點、`visited` 從 0 還是 1 開始。
- 走到終點後繼續走。
- 回溯時沒有把格子還原。

## 面試口說整理

網格最多 20 格，所以我直接回溯所有路徑。先數出所有非障礙格的數量，從起點 DFS，走過的格子原地標記，回來時還原。走到終點時，如果走過的格數剛好等於非障礙格總數，就是一條合法路徑，否則這條路不算；到終點後就不再往外走。
