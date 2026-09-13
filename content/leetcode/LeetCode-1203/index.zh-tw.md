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

## 整理補充

原 note 把這題標成 deferred，所以文章必須補上 capstone 解法。這題本質是兩層 topological sort。先把所有 `group[i] == -1` 的 item 分配一個獨立 synthetic group，讓每個 item 都有 group。接著對所有 dependency 建 item-level graph；只有跨 group 的 dependency 才建 group-level graph。任一層 topo sort 失敗都代表無解。兩層都成功後，依照 item topo order 把 item 放進各 group bucket，再依 group topo order 輸出 bucket，就同時保住 group 間與 item 間的限制。

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

我會把這題講成兩個協調好的 topo sort。Item topo order 保證所有 item dependency；group topo order 保證跨 group dependency。兩者都合法後，依 item order 分桶，再依 group order 輸出。
