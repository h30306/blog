---
title: "LeetCode 1971: Find if Path Exists in Graph"
summary: "LeetCode 1971 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-08 的 LeetCode 1971 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-08
tags: ["easy", "graph", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-08
來源：Day 2 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 1971 — Find if Path Exists in Graph
- **Pattern:** BFS/DFS OR Union-Find
- **Critical:** This is an **undirected** graph — add both directions when building adjacency list
- **BFS approach:** Standard BFS from source. Return true if destination is reached.
- **Union-Find approach:** Group all connected nodes. Return `find(source) == find(destination)`
- **Common bugs:**
  1. Building directed adjacency list for undirected graph
  2. Applying Kahn's in-degree logic to undirected graph — in-degree is meaningless here
  3. Never calling `union` on edges — nodes stay in separate components
  4. Calling `union(x, y)` with raw nodes instead of roots `union(find(x), find(y))`
  5. Wrong rank increment — only increment when two trees of equal rank merge

- **Union-Find template:**
```python
parent = [i for i in range(n)]
rank = [0] * n

def find(x):
    if parent[x] != x:
        parent[x] = find(parent[x])  # path compression
    return parent[x]

def union(x, y):
    rx, ry = find(x), find(y)
    if rx == ry:
        return
    if rank[rx] > rank[ry]:
        parent[ry] = rx
    elif rank[rx] < rank[ry]:
        parent[rx] = ry
    else:
        parent[rx] = ry
        rank[ry] += 1
```

- **Trade-off:** BFS = simpler, good for single query. Union-Find = better for multiple path queries on same graph (near O(1) per query after O(V+E) build).

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def validPath(self, n: int, edges: List[List[int]], source: int, destination: int) -> bool:
        parent = list(range(n))
        rank = [0] * n

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(a, b):
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if rank[ra] < rank[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            if rank[ra] == rank[rb]:
                rank[ra] += 1

        for a, b in edges:
            union(a, b)

        return find(source) == find(destination)
```

## 複雜度

Time O((n+e) alpha(n)), Space O(n).

## 要特別避免的錯誤

- Treating the graph as directed.
- Forgetting path compression / union is enough for connectivity.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
