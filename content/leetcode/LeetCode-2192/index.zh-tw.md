---
title: "LeetCode 2192: All Ancestors of a Node in a DAG"
summary: "LeetCode 2192 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-08 的 LeetCode 2192 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-08
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
第一次嘗試：2026-04-08
來源：Day 2 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### LC 2192 - All Ancestors of a Node in a DAG
- **Pattern:** Graph traversal，可以 DFS from each source，也可以用 Kahn topological order 做 set propagation。
- **Key insight:** Ancestors 是 transitive 的。如果 `0 -> 1 -> 3`，那 `0` 也是 `3` 的 ancestor。
- **DFS approach:** 對每個 `src` 跑 DFS，把 `src` 加到所有 reachable node 的 ancestor list。每次 DFS 都要用新的 `visited`，避免重複。
- **Common bugs:** 共用同一個 `visited`、append current `node` 而不是原始 `src`、或在 visited check 前 append 造成 duplicate。
- **BFS approach:** 用 Kahn topological sort。對每條 `node -> neighbor`，把 `ancestors[node]` 加上 `node` 一起傳給 `ancestors[neighbor]`。Topological order 保證傳出去前 ancestors 已完整。
- **Why BFS is faster:** DFS 會從很多 source 重複走圖；Kahn propagation 只處理 graph edges 一輪，主要成本在 set union。
- **Time complexity (BFS):** Worst case O(V^2 + E) propagation，最後 sorting 大量 ancestor list 時可到 O(V^2 log V)。


## 整理補充

這篇應該專注在 DAG 的 transitive ancestors。Kahn 解法成立是因為 node 被 pop 出來時，所有能透過前面節點傳到它的 ancestors 都已經累積好了。對每條 `u -> v`，`u` 本身和 `u` 的所有 ancestors 都是 `v` 的 ancestors。最後才排序，可以讓 propagation 邏輯保持簡單，也避免重複輸出。

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from collections import deque
from typing import List

class Solution:
    def getAncestors(self, n: int, edges: List[List[int]]) -> List[List[int]]:
        graph = [[] for _ in range(n)]
        indeg = [0] * n
        ancestors = [set() for _ in range(n)]

        for u, v in edges:
            graph[u].append(v)
            indeg[v] += 1

        q = deque(i for i in range(n) if indeg[i] == 0)
        while q:
            u = q.popleft()
            for v in graph[u]:
                ancestors[v].add(u)
                ancestors[v].update(ancestors[u])
                indeg[v] -= 1
                if indeg[v] == 0:
                    q.append(v)

        return [sorted(a) for a in ancestors]
```

## 複雜度

Time O(n^2 + e) in worst case, Space O(n^2).

## 要特別避免的錯誤

- Doing DFS from every node without controlling duplicate work.
- Forgetting sorted output.

## 面試口說整理

我會用 topological order 往前傳 ancestor sets。對每條 `u -> v`，`u` 和 `u` 的所有 ancestors 都要加入 `v`。因為是 topo order，`u` 被處理時它的 ancestors 已經完整。
