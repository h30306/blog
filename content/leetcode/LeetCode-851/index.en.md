---
title: "LeetCode 851: Loud and Rich"
summary: "LeetCode note for Loud and Rich, rebuilt from the original learning note"
description: "Cleaned LeetCode 851 article from 2026-04-13 with note repair points and final solution"
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

#### LC 851 - Loud and Rich
- **Status:** Completed.
- **Pattern:** Topological BFS propagation.
- **Target:** Practice topo propagation on a medium-level dependency graph.
- **Interview focus:** Choose correct graph direction and propagate the quietest richer person from richer nodes to poorer nodes.
- **Graph direction:** `richer -> poorer`.
- **Why this direction:** The quietest person known for a richer node can affect every poorer node reachable from it.
- **State meaning:** `answer[i]` stores the person index of the quietest known person among people at least as rich as `i`, not the quiet value itself.
- **Update rule:** When processing `rich -> poor`, if `quiet[answer[rich]] < quiet[answer[poor]]`, set `answer[poor] = answer[rich]`.
- **Queue initialization:** Start from people with indegree 0, meaning nobody is richer than them.
- **Complexity:** O(n + richer.length), Space O(n + richer.length).


## Organized Notes

The key is that richer information flows from richer people to poorer people. `answer[i]` is an index, not a quietness value: it points to the quietest person currently known among everyone at least as rich as `i`. Starting from people with no richer predecessor lets that best-known answer propagate down the DAG. When processing `rich -> poor`, compare `quiet[answer[rich]]` with `quiet[answer[poor]]`, not the raw person ids.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import deque
from typing import List

class Solution:
    def loudAndRich(self, richer: List[List[int]], quiet: List[int]) -> List[int]:
        n = len(quiet)
        graph = [[] for _ in range(n)]
        indeg = [0] * n
        for rich, poor in richer:
            graph[rich].append(poor)
            indeg[poor] += 1

        ans = list(range(n))
        q = deque(i for i in range(n) if indeg[i] == 0)
        while q:
            person = q.popleft()
            for poor in graph[person]:
                if quiet[ans[person]] < quiet[ans[poor]]:
                    ans[poor] = ans[person]
                indeg[poor] -= 1
                if indeg[poor] == 0:
                    q.append(poor)

        return ans
```

## Complexity

Time O(n+e), Space O(n+e).

## Mistakes To Watch

- Reversing richer/poorer edge direction.
- Comparing person index instead of quiet value.

## Final Interview Explanation

I would explain that richer-to-poorer is the direction that lets quiet candidates propagate. `answer[i]` stores the quietest known richer-or-equal person for `i`. When a richer node is processed, its best answer can improve every poorer neighbor, and topo order ensures those improvements flow through the graph.
