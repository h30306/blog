---
title: "LeetCode 1203: Sort Items by Groups Respecting Dependencies"
summary: "LeetCode 1203 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-13 的 LeetCode 1203 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-13
tags: ["hard", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-13
來源：Day 4 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 1203 - Sort Items by Groups Respecting Dependencies
- **Status:** Deferred to end of topological sort section.
- **Reason:** This is a high-difficulty two-level topo sort problem. It requires group-level and item-level ordering, so it should be attempted after standard topo variants are stable.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import defaultdict, deque
from typing import List

class Solution:
    def sortItems(self, n: int, m: int, group: List[int], beforeItems: List[List[int]]) -> List[int]:
        for i in range(n):
            if group[i] == -1:
                group[i] = m
                m += 1

        item_graph = [[] for _ in range(n)]
        item_indeg = [0] * n
        group_graph = [[] for _ in range(m)]
        group_indeg = [0] * m

        for item in range(n):
            for prev in beforeItems[item]:
                item_graph[prev].append(item)
                item_indeg[item] += 1
                if group[prev] != group[item]:
                    group_graph[group[prev]].append(group[item])
                    group_indeg[group[item]] += 1

        def topo(graph, indeg):
            q = deque(i for i, d in enumerate(indeg) if d == 0)
            order = []
            while q:
                node = q.popleft()
                order.append(node)
                for nei in graph[node]:
                    indeg[nei] -= 1
                    if indeg[nei] == 0:
                        q.append(nei)
            return order if len(order) == len(graph) else []

        group_order = topo(group_graph, group_indeg)
        item_order = topo(item_graph, item_indeg)
        if not group_order or not item_order:
            return []

        items_by_group = defaultdict(list)
        for item in item_order:
            items_by_group[group[item]].append(item)

        ans = []
        for g in group_order:
            ans.extend(items_by_group[g])
        return ans
```

## 複雜度

Time O(n + m + edges), Space O(n + m + edges).

## 要特別避免的錯誤

- Ignoring ungrouped items; assign each -1 item a unique group.
- Only sorting groups and forgetting item-level order inside each group.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
