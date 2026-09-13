---
title: "LeetCode 787: Cheapest Flights Within K Stops"
summary: "LeetCode 787 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-25 的 LeetCode 787 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-25
tags: ["medium", "graph", "bellman-ford", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-25
來源：Day 11 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 5. Explain why `LC 787` cannot use plain `visited = set(city)`.

## 當天筆記摘錄

#### Problem 3 - LC 787 Cheapest Flights Within K Stops Review
- **Status:** Partial repair only; full Bellman-Ford practice deferred.
- **Current understanding:** Plain Dijkstra with `visited = set(city)` is wrong.

#### Why Plain `visited = set(city)` Is Wrong
The state is not only the city.

Reaching the same city with:
```text
lower price but too many stops
```

can be worse than:
```text
higher price but fewer stops used
```

because the second route may leave enough stop budget for a cheaper final path.

So the state must include:
```text
(city, stops_used)
```

or:
```text
(city, edges_used)
```

#### Week 3 Decision
Do not force Bellman-Ford learning in a rushed way.

Move full Bellman-Ford intro and full `LC 787` practice to:
```text
Week 3 Weekend Day 2
```

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        inf = float('inf')
        dist = [inf] * n
        dist[src] = 0

        for _ in range(k + 1):
            ndist = dist[:]
            for u, v, price in flights:
                if dist[u] != inf and dist[u] + price < ndist[v]:
                    ndist[v] = dist[u] + price
            dist = ndist

        return -1 if dist[dst] == inf else dist[dst]
```

## 複雜度

Time O((K+1)*E), Space O(V).

## 要特別避免的錯誤

- Using city-only visited in Dijkstra and pruning cheaper paths with more stops incorrectly.
- Doing K rather than K+1 edge layers.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
