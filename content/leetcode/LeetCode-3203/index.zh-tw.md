---
title: "LeetCode 3203: Find Minimum Diameter After Merging Two Trees"
summary: "LeetCode 3203 解題筆記：連接兩棵樹的中心，答案是 max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)"
description: "2026-10-15 的 LeetCode 3203 解題紀錄"
date: 2026-10-15
tags: ["hard", "tree", "bfs", "dfs", "graph", "tree-diameter"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-15
- 提交紀錄：Runtime Error ×2 → Accepted → Runtime Error → Accepted → Accepted（改成迭代 BFS）

## 解題思路

把兩棵樹用一條邊連起來，新的直徑只有三種可能：

1. 第一棵樹原本的直徑 `d1`。
2. 第二棵樹原本的直徑 `d2`。
3. 穿過新邊的路徑：從第一棵樹的某點走到連接點，跨過新邊，再走到第二棵樹的某點。

要讓第 3 種最短，連接點要選在**各自樹的中心**。從中心到最遠點的距離（半徑）是 `ceil(d / 2)`，所以：

```text
答案 = max(d1, d2, ceil(d1 / 2) + ceil(d2 / 2) + 1)
```

直徑用兩次 BFS 求：從任意點找最遠點 `a`，再從 `a` 找最遠的距離。

## 我的嘗試

### Runtime Error 1、2：複製貼上沒改大小

```python
m = len(edges2) + 1
seen = [0] * m
...
seen = [0] * n                 # 第二棵樹還用 n
```

第二棵樹的程式碼是從第一棵複製來的，`seen` 陣列的大小還是 `n`。`m > n` 時 index 超出範圍。第一次交的時候兩處都是 `n`，第二次只改了一處。

### Runtime Error 3：改了函式名稱，遞迴呼叫沒改

把 `bfs` 改名成 `dfs`（因為它其實是遞迴的 DFS），但函式內部還在呼叫 `bfs(...)`。

### 最後一版：改成迭代 BFS

遞迴 DFS 在 `10^5` 個節點的鏈狀樹上有遞迴深度的風險，而且兩棵樹的程式碼重複。最後改成一個 `diameter(edges)` 函式，裡面用迭代 BFS。

## 正確解法

```python
from collections import defaultdict, deque

class Solution:
    def minimumDiameterAfterMerge(self, edges1: List[List[int]], edges2: List[List[int]]) -> int:
        def diameter(edges: List[List[int]]) -> int:
            n = len(edges) + 1
            adj = defaultdict(list)
            for u, v in edges:
                adj[u].append(v)
                adj[v].append(u)

            def bfs(start: int):
                dist = [-1] * n
                dist[start] = 0
                q = deque([start])
                while q:
                    node = q.popleft()
                    for nei in adj[node]:
                        if dist[nei] == -1:
                            dist[nei] = dist[node] + 1
                            q.append(nei)
                return node, dist[node]          # 最遠點和它的距離

            far, _ = bfs(0)
            _, d = bfs(far)
            return d

        d1 = diameter(edges1)
        d2 = diameter(edges2)
        return max(d1, d2, (d1 + 1) // 2 + (d2 + 1) // 2 + 1)
```

`(d + 1) // 2` 就是 `ceil(d / 2)`，不需要浮點數。

## 複雜度

時間 `O(n + m)`，空間 `O(n + m)`。

## 要特別避免的錯誤

- 兩棵樹的程式碼複製貼上：抽成函式，大小只會用到自己的 `n`。
- 改函式名稱後沒有檢查所有呼叫的地方。
- 只考慮穿過新邊的路徑，忘記原本的直徑可能更長。

## 面試口說整理

連接後的新直徑，要嘛是原本兩棵樹的直徑之一，要嘛是穿過新邊的路徑。要讓穿過新邊的路徑最短，連接點要選兩棵樹的中心，從中心出發最遠是 `ceil(d/2)`，所以答案是 `max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)`。直徑用兩次 BFS 算，時間 `O(n + m)`。
