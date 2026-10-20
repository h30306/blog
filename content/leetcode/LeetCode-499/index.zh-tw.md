---
title: "LeetCode 499: The Maze III"
summary: "LeetCode 499 解題筆記：Dijkstra 的優先度用 (距離, 路徑字串)，滾動途中經過洞就要停下"
description: "2026-09-06 的 LeetCode 499 解題紀錄"
date: 2026-09-06
tags: ["hard", "graph", "dijkstra", "shortest-path", "heap", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-06
- 提交紀錄：Wrong Answer → Accepted → Accepted（同一天整理一次）

## 解題思路

球每次選一個方向，一直滾到撞牆才停，**途中經過洞就會掉進去**。要找走最少格子掉進洞的指令；距離相同時，取字典序最小的指令。

- 節點：球可以停下的位置。
- 邊：從一個停點往某方向滾到下一個停點，邊權是滾過的格子數。

邊權不一樣，所以要用 Dijkstra 而不是 BFS。距離相同時要比字典序，所以 heap 的優先度直接用 `(距離, 路徑字串)`：Python 的 tuple 比較會先比距離，再比字串。

## 我的嘗試：只比字典序，沒有比距離

```python
pq = [("", ball[0], ball[1])]       # 只用 path 當優先度
```

第一版的 heap 只依路徑字串排序，取出的是字典序最小的路徑，不是最短的路徑。另外一個停點被拜訪過就再也不更新，但更晚找到、距離更短的路徑也可能到達同一個停點。

AC 版改成 `(距離, 路徑)` 當優先度，並用 `visited[(r, c)] = (距離, 路徑)` 記錄每個停點目前最好的狀態，只有更好時才更新。

## 正確解法

```python
import heapq

class Solution:
    def findShortestWay(self, maze: List[List[int]], ball: List[int], hole: List[int]) -> str:
        m, n = len(maze), len(maze[0])
        directions = (("d", 1, 0), ("l", 0, -1), ("r", 0, 1), ("u", -1, 0))
        best = {(ball[0], ball[1]): (0, "")}
        heap = [(0, "", ball[0], ball[1])]

        while heap:
            dist, path, r, c = heapq.heappop(heap)
            if [r, c] == hole:
                return path
            if best[(r, c)] < (dist, path):
                continue                                   # 過期的資料
            for ch, dr, dc in directions:
                nr, nc, step = r, c, 0
                while 0 <= nr + dr < m and 0 <= nc + dc < n and maze[nr + dr][nc + dc] == 0:
                    nr += dr
                    nc += dc
                    step += 1
                    if [nr, nc] == hole:                   # 經過洞就停
                        break
                if step == 0:
                    continue
                state = (dist + step, path + ch)
                if (nr, nc) not in best or state < best[(nr, nc)]:
                    best[(nr, nc)] = state
                    heapq.heappush(heap, (*state, nr, nc))
        return "impossible"
```

## 複雜度

時間 `O(m n log(m n) · max(m, n))`：每次彈出要往四個方向滾，每次滾最多 `max(m, n)` 格。另外比較路徑字串也有成本。空間 `O(m n)`。

## 要特別避免的錯誤

- 只用字典序當優先度，沒有先比距離。
- 滾動時沒有檢查洞：球經過洞就會掉進去，不會滾到牆邊。
- 用 BFS：每次滾動的格子數不同，邊權不相等。
- 停點拜訪過就不再更新：之後可能找到距離更短或字典序更小的路徑。

## 面試口說整理

球停下的位置是節點，往一個方向滾到停是一條邊，邊權是滾過的格子數。邊權不同所以用 Dijkstra，而距離相同時要字典序最小，所以 heap 的優先度用 `(距離, 路徑字串)`。滾動時每走一格都檢查是不是洞，經過洞就停。用 dict 記錄每個停點最好的 `(距離, 路徑)`，只有更好才推入，第一次彈出洞的位置就是答案。
