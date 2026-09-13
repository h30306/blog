---
title: "LeetCode 802: Find Eventual Safe States"
summary: "LeetCode 802 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-13 的 LeetCode 802 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-13
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
第一次嘗試：2026-04-13
來源：Day 4 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 802 - Find Eventual Safe States
- **Status:** Completed.
- **Pattern:** Reverse graph + remaining outdegree topo.
- **Key correction:** 這題不是假設輸入是 DAG。輸入可以有 cycle；目標是找出不在 cycle 裡、也不會走到 cycle 的節點。
- **Correct model:** 建 `reverse_graph[v] = predecessors that point to v`，並追蹤 `outdegree[u] = len(graph[u])`。
- **Queue initialization:** 從 terminal nodes，也就是 `outdegree == 0` 的節點開始。
- **Propagation:** 當一個 safe node 被處理，就把它所有 predecessor 的剩餘 outdegree 減 1。如果 predecessor 的 outdegree 變成 0，代表它所有 outgoing paths 都通往 safe nodes，所以它也 safe。
- **Naming issue fixed:** 這個 counter 是 `outdegree`，不是 `in_degree`。命名錯會讓解釋很混亂，即使程式剛好過。
- **Complexity:** O(V + E)，如果最後排序結果則多 sorting cost。


## 整理補充

這題原 note 想用的是 reverse-graph topological trimming。Terminal nodes 一開始就是 safe。當某個 node 被證明 safe，所有指向它的 predecessors 就少了一條可能通往危險的 outgoing edge；如果 predecessor 的剩餘 outdegree 歸零，代表它所有 outgoing edges 都通往 safe nodes，所以它也 safe。這跟普通 DAG cycle detection 不同，因為輸入可以有 cycle，答案是「不會走到 cycle」的 nodes。

## 正確解法

上面的筆記保留了原始 repair 的 reverse-graph model。下面的提交版直接照這個模型寫，讓程式和筆記一致。

```python
from collections import deque
from typing import List

class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        n = len(graph)
        reverse_graph = [[] for _ in range(n)]
        outdegree = [0] * n

        for node, neighbors in enumerate(graph):
            outdegree[node] = len(neighbors)
            for nei in neighbors:
                reverse_graph[nei].append(node)

        q = deque(i for i in range(n) if outdegree[i] == 0)
        safe = [False] * n

        while q:
            node = q.popleft()
            safe[node] = True
            for prev in reverse_graph[node]:
                outdegree[prev] -= 1
                if outdegree[prev] == 0:
                    q.append(prev)

        return [i for i, ok in enumerate(safe) if ok]
```


## 複雜度

Time O(V+E), Space O(V).

## 要特別避免的錯誤

- Only checking immediate outgoing edges.
- Forgetting a node with no outgoing edges is safe.

## 面試口說整理

我會從 terminal nodes 反向證明 safe。某個 node safe 之後，它的 predecessors 就少一條可能通往 cycle 的 outgoing edge；當某個 predecessor 的剩餘 outdegree 變成 0，代表它所有路徑都通往 safe nodes，所以它也 safe。
