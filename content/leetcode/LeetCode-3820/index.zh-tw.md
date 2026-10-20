---
title: "LeetCode 3820: Pythagorean Distance Nodes in a Tree"
summary: "LeetCode 3820 解題筆記：三次 BFS 算出每個點到三個目標的距離"
description: "2026-01-25 的 LeetCode 3820 解題紀錄"
date: 2026-01-25
tags: ["medium", "tree", "bfs", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個節點要知道它到 `x`、`y`、`z` 三個點的距離。與其對每個節點各做一次 BFS，不如**從三個目標點各做一次 BFS**，一次就得到所有節點到該目標的距離。

樹上兩點之間只有一條路徑，所以 BFS 的步數就是距離。

最後對每個節點，把三個距離排序，檢查 `a² + b² == c²`。

## 我的解法

```python
from collections import deque

class Solution:
    def specialNodes(self, n: int, edges: List[List[int]], x: int, y: int, z: int) -> int:
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        def bfs(start):
            dist = [-1] * n
            dist[start] = 0
            q = deque([start])
            while q:
                u = q.popleft()
                for v in graph[u]:
                    if dist[v] == -1:
                        dist[v] = dist[u] + 1
                        q.append(v)
            return dist

        dx, dy, dz = bfs(x), bfs(y), bfs(z)

        count = 0
        for i in range(n):
            a, b, c = sorted((dx[i], dy[i], dz[i]))
            if a * a + b * b == c * c:
                count += 1
        return count
```

## 複雜度

時間 `O(n)`：三次 BFS 加上一次掃描。空間 `O(n)`。

## 要特別避免的錯誤

- 對每個節點都做 BFS，會變成 `O(n^2)`。
- 只建單向邊：樹的邊是無向的。
- 忘記排序：畢氏定理的 `c` 必須是最大的那個。

## 面試口說整理

我需要每個節點到三個目標點的距離，所以反過來從三個目標點各做一次 BFS，得到三個距離陣列。樹上路徑唯一，BFS 步數就是距離。接著對每個節點把三個距離排序，檢查兩個小的平方和是否等於最大的平方。總共三次 BFS，時間 `O(n)`。
