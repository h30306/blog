---
title: "Topological Sort"
summary: "排序、cycle detection、dependency unlocking 與 graph propagation"
description: "演算法學習"
date: 2026-09-13
tags: ["graph", "topological-sort", "kahn"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Topological sort 用在 directed dependency graph。常見問題包含：

- 所有任務能不能完成？
- 有沒有一個合法的依賴順序？
- 哪些節點會在 prerequisite 滿足後被 unlock？
- 如何在 DAG 上傳遞資訊？

面試重點不是背模板，而是選對 graph direction，並講清楚 in-degree 代表什麼。

## 核心概念

Kahn's algorithm 會維護所有 prerequisite 已經滿足的節點：

```text
queue = all nodes with indegree 0
```

處理一個 node 後，它會 unlock outgoing neighbors：

```text
for nei in graph[node]:
    indegree[nei] -= 1
    if indegree[nei] == 0:
        queue.append(nei)
```

如果所有節點都能被處理，代表沒有 cycle。如果 queue 清空但還有節點沒處理，代表有 cycle 或 dependency 無法滿足。

## 模板

```python
from collections import deque
from typing import List

def topo_order(n: int, edges: List[List[int]]) -> List[int]:
    graph = [[] for _ in range(n)]
    indeg = [0] * n

    for pre, node in edges:
        graph[pre].append(node)
        indeg[node] += 1

    q = deque(i for i in range(n) if indeg[i] == 0)
    order = []

    while q:
        node = q.popleft()
        order.append(node)
        for nei in graph[node]:
            indeg[nei] -= 1
            if indeg[nei] == 0:
                q.append(nei)

    return order if len(order) == n else []
```

## 變形

### Cycle Detection

`LC 207` 只需要判斷：

```text
processed_count == numCourses
```

### Return An Ordering

`LC 210` 要回傳 queue pop 出來的 topological order。如果有 cycle，就回傳空陣列。

### Dependency Unlocking

Recipe 類題目的 queue 從已經 available 的 supplies 開始，不只是 indegree 0 的 graph nodes。

### Reverse Outdegree Trimming

Eventual safe states 是從 terminal nodes 往回證明 safe。這時追蹤的是 remaining outdegree，不是 indegree。

### Two-Level Topological Sort

Grouped items 類題目要同時排序 item dependencies 和 group dependencies，最後依照 group order 輸出 item buckets。

## 常見錯誤

- edge direction 反了，導致 in-degree 意義錯掉。
- 有 cycle 時回傳 partial order。
- 把 undirected graph 當成 topo 題。
- reverse trimming 題目把 outdegree counter 叫成 in-degree。
- propagation 題只寫排序，沒有講清楚 state 怎麼傳。

## 相關 LeetCode

- `LC 207` Course Schedule
- `LC 210` Course Schedule II
- `LC 269` Alien Dictionary
- `LC 310` Minimum Height Trees
- `LC 802` Find Eventual Safe States
- `LC 851` Loud and Rich
- `LC 1203` Sort Items by Groups Respecting Dependencies
- `LC 2115` Find All Possible Recipes from Given Supplies
- `LC 2192` All Ancestors of a Node in a DAG
