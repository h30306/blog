---
title: "LeetCode 3313: Find the Last Marked Nodes in Tree"
summary: "LeetCode 3313 解題筆記：最後被標記的就是最遠的點，而最遠點一定能取直徑端點"
description: "2026-09-17 的 LeetCode 3313 解題紀錄"
date: 2026-09-17
tags: ["hard", "tree", "bfs", "graph", "tree-diameter"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-17
- 提交紀錄：Accepted（一次通過）

## 解題思路

從節點 `i` 開始，每秒把所有相鄰的點標記起來，這就是 BFS 擴散。**最後被標記的點，就是離 `i` 最遠的點。**

對每個點都做一次 BFS 是 `O(n^2)`，`n` 到 `10^5` 會超時。

關鍵性質：**對任何節點來說，樹的直徑兩端 `u`、`v` 之中，至少有一個是離它最遠的點。** 所以只要：

1. 從任意點 BFS 找到最遠點 `u`。
2. 從 `u` BFS 找到最遠點 `v`，`u`、`v` 就是直徑的兩端。
3. 再從 `v` BFS 一次。
4. 對每個點 `i`，比較 `dist_u[i]` 和 `dist_v[i]`，比較遠的那個端點就是答案。

## 我的解法

```python
from collections import defaultdict, deque

class Solution:
    def lastMarkedNodes(self, edges: List[List[int]]) -> List[int]:
        n = len(edges) + 1
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)

        def bfs(start):
            dist = [-1] * n
            dist[start] = 0
            q = deque([start])
            while q:
                node = q.popleft()
                for nei in adj[node]:
                    if dist[nei] == -1:
                        dist[nei] = dist[node] + 1
                        q.append(nei)
            return node, dist                  # 最後彈出的就是最遠點

        u, _ = bfs(0)
        v, dist_u = bfs(u)
        _, dist_v = bfs(v)
        return [u if dist_u[i] > dist_v[i] else v for i in range(n)]
```

原本的版本把函式取名叫 `dfs`，但做的其實是 BFS，而且另外維護 `farthest` 這個 tuple。BFS 最後彈出的節點本來就是最遠的，可以直接回傳。

## 複雜度

三次 BFS，時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 對每個點各跑一次 BFS，`O(n^2)` 超時。
- 只從直徑的一端算距離：有些點離另一端比較遠。

## 面試口說整理

從 `i` 開始擴散標記，最後被標記的就是離 `i` 最遠的點。樹上任何點的最遠點，都可以取直徑的其中一端，所以我用兩次 BFS 找出直徑兩端 `u`、`v`，再從兩端各算一次距離，每個點選比較遠的那一端。三次 BFS，時間 `O(n)`。
