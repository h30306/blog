---
title: "LeetCode 310: Minimum Height Trees"
summary: "LeetCode 310 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-11 的 LeetCode 310 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-11
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-11
來源：Day 3 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 310 - Minimum Height Trees
- **Pattern:** Topological-style leaf trimming on an undirected tree
- **Key insight:** The root of a minimum height tree must be the center of the tree. A tree has either 1 or 2 centers.
- **Approach:** Build undirected adjacency sets and degree array. Start with all leaves where degree is 1. Remove leaves layer by layer. Each removal reduces neighbor degree. New leaves are added to the queue. Stop when remaining nodes <= 2.
- **Why leaf trimming works:** The farthest nodes from the center are leaves. Removing outer layers repeatedly leaves the center node(s).
- **Special case:** If `n == 1`, return `[0]`.
- **Complexity:** Time O(n), Space O(n)
- **Common bugs:** Treating this as directed topo sort, forgetting `n == 1`, returning removed leaves instead of remaining centers, not decrementing remaining node count.

#### Pattern Comparison
- **Alien Dictionary:** Directed graph ordering problem.
- **Recipes:** Directed dependency unlocking problem.
- **Minimum Height Trees:** Undirected tree center problem using topo-style pruning.
- **Interview distinction:** Topological sort is not only one template. The same in-degree idea can model ordering, availability, or layer removal, but the graph direction and meaning must be explained clearly.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def findMinHeightTrees(self, n: int, edges: List[List[int]]) -> List[int]:
        if n == 1:
            return [0]

        graph = [set() for _ in range(n)]
        for a, b in edges:
            graph[a].add(b)
            graph[b].add(a)

        leaves = deque(i for i in range(n) if len(graph[i]) == 1)
        remaining = n
        while remaining > 2:
            size = len(leaves)
            remaining -= size
            for _ in range(size):
                leaf = leaves.popleft()
                nei = graph[leaf].pop()
                graph[nei].remove(leaf)
                if len(graph[nei]) == 1:
                    leaves.append(nei)

        return list(leaves)
```

## 複雜度

Time O(n), Space O(n).

## 要特別避免的錯誤

- Trying every root with BFS, causing O(n^2).
- Forgetting n=1.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
