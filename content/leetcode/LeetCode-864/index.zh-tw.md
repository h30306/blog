---
title: "LeetCode 864: Shortest Path to Get All Keys"
summary: "LeetCode 864 解題筆記：BFS 的狀態是 (位置, 拿到的鑰匙遮罩)，同一格拿著不同鑰匙是不同的節點"
description: "2026-09-05 的 LeetCode 864 解題紀錄"
date: 2026-09-05
tags: ["hard", "bfs", "bit-manipulation", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-05
- 提交紀錄：Accepted → Accepted（整理一次）

## 解題思路

在網格上走，撿到鑰匙才能通過對應的鎖，求拿到所有鑰匙的最少步數。

只記位置不夠：同一格，拿著不同的鑰匙，接下來能走的地方不一樣。所以 **BFS 的狀態是 `(r, c, keys)`**，`keys` 用位元遮罩表示（最多 6 把，`2^6 = 64` 種）。

- 走到鑰匙：遮罩加上這把鑰匙。
- 走到鎖：只有遮罩裡有對應的鑰匙才能走。
- 遮罩等於「全部鑰匙」時，目前的步數就是答案。

## 我的解法

```python
from collections import deque

class Solution:
    def shortestPathAllKeys(self, grid: List[str]) -> int:
        m, n = len(grid), len(grid[0])
        total = 0
        for r in range(m):
            for c in range(n):
                if grid[r][c] == "@":
                    start = (r, c)
                elif grid[r][c].islower():
                    total += 1
        full = (1 << total) - 1

        q = deque([(start[0], start[1], 0, 0)])            # r, c, keys, steps
        seen = {(start[0], start[1], 0)}
        while q:
            r, c, keys, steps = q.popleft()
            if keys == full:
                return steps
            for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                if not (0 <= nr < m and 0 <= nc < n) or grid[nr][nc] == "#":
                    continue
                ch = grid[nr][nc]
                if ch.isupper() and not keys >> (ord(ch) - ord("A")) & 1:
                    continue                               # 沒有鑰匙，過不去
                nkeys = keys | (1 << (ord(ch) - ord("a"))) if ch.islower() else keys
                if (nr, nc, nkeys) not in seen:
                    seen.add((nr, nc, nkeys))
                    q.append((nr, nc, nkeys, steps + 1))
        return -1
```

## 複雜度

時間 `O(mn · 2^k)`，`k` 是鑰匙數量。空間 `O(mn · 2^k)`。

## 要特別避免的錯誤

- `visited` 只記位置：拿到鑰匙之後回頭走的路徑會被擋掉。
- 鑰匙數量寫死成 6：要依網格裡實際的鑰匙數算出「全部」的遮罩。
- 在網格上原地標記走過的格子：拿著不同鑰匙時會需要再經過同一格，標記要放在包含鑰匙遮罩的 `seen` 裡。

## 面試口說整理

因為同一格拿著不同的鑰匙，之後能走的範圍不同，我把 BFS 的狀態設成位置加上鑰匙的位元遮罩。走到鑰匙就把對應的位元加上去，走到鎖要檢查遮罩裡有沒有對應的鑰匙。`visited` 記整個狀態，第一次遮罩變成全滿時的步數就是答案。狀態數是 `mn · 2^k`，`k` 最多 6。
