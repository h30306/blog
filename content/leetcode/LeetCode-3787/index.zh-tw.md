---
title: "LeetCode 3787: Find Diameter Endpoints of a Tree"
summary: "LeetCode 3787 解題筆記：兩次 BFS 找到一條直徑的兩端 A、B；任一點最遠的點一定是 A 或 B，所以 max(dist(A,i), dist(B,i)) 等於直徑的點就是某條直徑的端點"
description: "2026-10-22 的 LeetCode 3787 解題紀錄"
date: 2026-10-22
tags: ["medium", "tree", "breadth-first-search", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-22
- 提交紀錄：Accepted（一次通過）

## 解題思路

要標出所有「某條直徑的端點」。直徑可能有很多條，不能只找一條。

先用兩次 BFS 找到一條直徑（[Tree]({{< relref "/algorithm/Tree" >}}) 模板五）：

1. 從任意點（0）BFS，最遠的點 `A` 一定是某條直徑的端點。
2. 從 `A` BFS，最遠的點 `B` 是另一端，`dist(A, B)` 就是直徑長度 `D`。

關鍵性質：**樹上任何一個點，離它最遠的點一定可以取 `A` 或 `B`**。所以節點 `i` 的最遠距離是 `max(dist(A, i), dist(B, i))`。

節點 `i` 是某條直徑的端點，等於它的最遠距離剛好是 `D`。所以從 `A`、`B` 各 BFS 一次，檢查 `max(dA[i], dB[i]) == D` 就好。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def findSpecialNodes(self, n: int, edges: List[List[int]]) -> str:
        graph = [[] for _ in range(n)]
        for u, v in edges:
            graph[u].append(v)
            graph[v].append(u)

        def bfs(s):
            dist = [-1] * n
            dist[s] = 0
            queue = deque([s])
            while queue:
                node = queue.popleft()
                for nei in graph[node]:
                    if dist[nei] < 0:
                        dist[nei] = dist[node] + 1
                        queue.append(nei)
            return dist

        d0 = bfs(0)
        a = d0.index(max(d0))
        dA = bfs(a)
        b = dA.index(max(dA))
        dB = bfs(b)
        diameter = dA[b]
        return "".join("1" if max(dA[i], dB[i]) == diameter else "0" for i in range(n))
```

## 複雜度

三次 BFS，時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 直徑不唯一，只標 `A`、`B` 兩個點會漏掉其他直徑的端點。
- 只有一個節點時直徑是 0，那個點自己就是端點，公式也成立。

## 面試口說整理

我先兩次 BFS 找到一條直徑的兩端 `A`、`B` 和長度 `D`。樹上任一點最遠的點一定可以是 `A` 或 `B`，所以一個點的最遠距離是它到 `A`、`B` 距離的較大值；這個值等於 `D` 的點就是某條直徑的端點。總共三次 BFS，時間 `O(n)`。
