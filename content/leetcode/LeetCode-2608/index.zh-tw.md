---
title: "LeetCode 2608: Shortest Cycle in a Graph"
summary: "LeetCode 2608 解題筆記：從每個點 BFS，遇到已拜訪而且不是 parent 的鄰居，就找到一個長度 dist[u] + dist[v] + 1 的環"
description: "2026-09-16 的 LeetCode 2608 解題紀錄"
date: 2026-09-16
tags: ["hard", "bfs", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-16
- 提交紀錄：Wrong Answer → Memory Limit Exceeded → Accepted

## 解題思路

無向圖的最短環。`n, m <= 1000`，所以可以**從每個點各做一次 BFS**。

從 `s` 做 BFS 時，記錄每個點的距離 `dist` 和它從哪裡來（parent）。如果從 `u` 看到一個**已經拜訪過、而且不是 `u` 的 parent** 的鄰居 `v`，代表有兩條從 `s` 出發的路徑在 `u-v` 這條邊相遇，形成一個環，長度最多是 `dist[u] + dist[v] + 1`。

這個長度不一定剛好是環的長度（兩條路徑可能在離 `s` 比較近的地方就會合了），但會是某個環的長度上界；而對最短環上的任一點做 BFS 時，一定能算出它的正確長度。所以所有起點、所有這種邊取最小值，就是答案。

## 我的嘗試

### Wrong Answer：用「走過的邊」當狀態

第一版的 BFS 狀態是 `(長度, 目前節點, 走過的邊的位元遮罩)`，想直接找「回到同一個點、但沒有重複用邊」的路徑。除了思路太重，位元檢查也寫錯了：

```python
if not (visited_edge >> edge):            # 應該是 (visited_edge >> edge) & 1
```

`visited_edge >> edge` 只要比 `edge` 更高的位元有任何一個是 1 就是 True，不是只看第 `edge` 位。

### Memory Limit Exceeded：狀態數爆炸

修好位元檢查之後，每條路徑都帶著自己的邊遮罩，同一個節點會以非常多種不同的遮罩被推進 queue，記憶體爆掉。

最後改成標準做法：每個點 BFS 一次，只記距離和 parent。

## 正確解法

```python
from collections import defaultdict, deque

class Solution:
    def findShortestCycle(self, n: int, edges: List[List[int]]) -> int:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        best = float("inf")
        for s in range(n):
            dist = [-1] * n
            dist[s] = 0
            q = deque([(s, -1)])
            while q:
                u, parent = q.popleft()
                for v in adj[u]:
                    if dist[v] == -1:
                        dist[v] = dist[u] + 1
                        q.append((v, u))
                    elif v != parent:
                        best = min(best, dist[u] + dist[v] + 1)
        return -1 if best == float("inf") else best
```

## 複雜度

時間 `O(n · (n + m))`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 用走過的邊集合當狀態：狀態數是指數級。
- 位元檢查少了 `& 1`。
- 把 parent 也當成環：無向圖每條邊都會被雙向看到，要排除剛走過來的那條邊。

## 面試口說整理

我從每個點各做一次 BFS，記錄距離和 parent。遇到一個已經拜訪過、而且不是 parent 的鄰居，就代表兩條路徑在這條邊相遇，形成長度 `dist[u] + dist[v] + 1` 的環。對最短環上的點做 BFS 時一定能得到它的正確長度，所以全部取最小值就是答案。總共 `n` 次 BFS，時間 `O(n(n + m))`。
