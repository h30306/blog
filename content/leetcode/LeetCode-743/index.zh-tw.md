---
title: "LeetCode 743: Network Delay Time"
summary: "LeetCode 743 解題筆記，依照原始 learning note 重新整理"
description: "2026-05-01 的 LeetCode 743 學習紀錄，包含筆記修正點與正確解法"
date: 2026-05-01
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-01
來源：Day 16 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- 3. Explain why `LC 743` needs Dijkstra instead of BFS.

## 當天筆記摘錄

#### Problem 3 - LC 743 Network Delay Time Review
- **Status:** Good enough no-hints recall.
- **Pattern:** Dijkstra / single-source shortest path.

#### Why Dijkstra Fits
We need:
```text
minimum travel time from one source node k to every other node
```

The graph is:
- directed
- weighted
- non-negative edge costs

That is the standard Dijkstra fit.

#### Core Data Structures
- adjacency list
- min-heap of `(time, node)`
- either:
  - shortest-distance table, or
  - finalized / visited set

#### Final Answer Meaning
This is not:
```text
the longest arbitrary path from source
```

It is:
```text
the maximum shortest-path arrival time from source to any reachable node
```

So:
- if some node is unreachable -> return `-1`
- else -> return the maximum shortest arrival time

#### Complexity
```text
Time: O((E + V) log V)
Space: O(E + V)
```

#### Common Mistakes
- using BFS even though edge weights differ
- saying the answer is the "longest path"
- forgetting to skip stale heap entries or revisits

#### Interview-Ready Explanation
I run Dijkstra from node `k` to compute the shortest signal arrival time to every node. If I cannot reach all nodes, I return `-1`. Otherwise I return the largest shortest arrival time, because that is when the last node receives the signal.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import defaultdict
from heapq import heappop, heappush
from typing import List

class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        graph = defaultdict(list)
        for u, v, w in times:
            graph[u].append((v, w))

        dist = {}
        heap = [(0, k)]
        while heap:
            d, node = heappop(heap)
            if node in dist:
                continue
            dist[node] = d
            for nei, w in graph[node]:
                if nei not in dist:
                    heappush(heap, (d + w, nei))

        return max(dist.values()) if len(dist) == n else -1
```

## 複雜度

Time O((V+E) log V), Space O(V+E).

## 要特別避免的錯誤

- Returning distance to one target instead of all nodes.
- Forgetting nodes are 1-indexed.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
