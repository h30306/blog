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
- **Key correction:** This is not a DAG problem. The input may contain cycles; the goal is to find nodes that are not in a cycle and cannot reach a cycle.
- **Correct model:** Build `reverse_graph[v] = predecessors that point to v`. Track `outdegree[u] = len(graph[u])`.
- **Queue initialization:** Start with terminal nodes where `outdegree == 0`.
- **Propagation:** When a safe node is processed, decrement the remaining outdegree of its predecessors. If a predecessor reaches 0, all of its outgoing paths lead to safe nodes, so it is safe.
- **Naming issue fixed:** The counter is `outdegree`, not `in_degree`. Calling it `in_degree` is misleading even if the code passes.
- **Complexity:** O(V + E) if returning by final scan; O(V + E + V log V) if sorting result.

#### LC 851 - Loud and Rich
- **Status:** Completed.
- **Reason for replacement:** `LC 1203 Sort Items by Groups Respecting Dependencies` is too difficult for the current point in the topo sequence and should be treated as a capstone problem.
- **Target:** Practice topo propagation on a medium-level dependency graph before attempting LC 1203.
- **Interview focus:** Choose correct graph direction and propagate the quietest richer person from richer nodes to poorer nodes.
- **Pattern:** Topological BFS propagation.
- **Graph direction:** `richer -> poorer`.
- **Why this direction:** The quietest person known for a richer node can affect every poorer node reachable from it.
- **State meaning:** `answer[i]` stores the person index of the quietest known person among people at least as rich as `i`, not the quiet value itself.
- **Update rule:** When processing `rich -> poor`, if `quiet[answer[rich]] < quiet[answer[poor]]`, set `answer[poor] = answer[rich]`.
- **Queue initialization:** Start from people with indegree 0, meaning nobody is richer than them.
- **Complexity:** O(n + richer.length), Space O(n + richer.length).

#### LC 269 - Alien Dictionary Review
- **Status:** Timed review attempted; needs repair.
- **Good:** Remembered invalid prefix case and cycle check.
- **Issue 1:** Compared every pair of words instead of adjacent word pairs only.
- **Why wrong:** Alien dictionary constraints only come from adjacent words in the sorted list. Comparing non-adjacent pairs can create invalid extra constraints.
- **Correct loop:** Compare `words[i]` with `words[i + 1]` only.
- **Issue 2:** Used list adjacency and incremented in-degree directly, which can double-count duplicate edges.
- **Fix:** Use `set` adjacency and only increment in-degree when adding a new edge.
- **Review verdict:** Pattern recognition is good, but implementation is not interview-ready yet. Re-solve once more later without notes.

#### LC 1203 - Sort Items by Groups Respecting Dependencies
- **Status:** Deferred to end of topological sort section.
- **Reason:** This is a high-difficulty two-level topo sort problem. It requires group-level and item-level ordering, so it should be attempted after standard topo variants are stable.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
from typing import List

class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        n = len(graph)
        color = [0] * n

        def dfs(node):
            if color[node] != 0:
                return color[node] == 2
            color[node] = 1
            for nei in graph[node]:
                if not dfs(nei):
                    return False
            color[node] = 2
            return True

        return [i for i in range(n) if dfs(i)]
```

## 複雜度

Time O(V+E), Space O(V).

## 要特別避免的錯誤

- Only checking immediate outgoing edges.
- Forgetting a node with no outgoing edges is safe.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
