---
title: "LeetCode 802: Find Eventual Safe States"
summary: "LeetCode note for Find Eventual Safe States, rebuilt from the original learning note"
description: "Cleaned LeetCode 802 article from 2026-04-13 with note repair points and final solution"
date: 2026-04-13
tags: ["medium", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-13
Source: Day 4 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

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

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(V+E), Space O(V).

## Mistakes To Watch

- Only checking immediate outgoing edges.
- Forgetting a node with no outgoing edges is safe.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
