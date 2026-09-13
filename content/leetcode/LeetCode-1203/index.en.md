---
title: "LeetCode 1203: Sort Items by Groups Respecting Dependencies"
summary: "LeetCode note for Sort Items by Groups Respecting Dependencies, rebuilt from the original learning note"
description: "Cleaned LeetCode 1203 article from 2026-04-13 with note repair points and final solution"
date: 2026-04-13
tags: ["hard", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-13
Source: Day 4 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### LC 1203 - Sort Items by Groups Respecting Dependencies
- **Status:** Deferred to end of topological sort section.
- **Reason:** This is a high-difficulty two-level topo sort problem. It requires group-level and item-level ordering, so it should be attempted after standard topo variants are stable.

## Organized Notes

The original note marked this as deferred, so the article needs the missing capstone explanation. The problem is two topological sorts glued together. First, assign every ungrouped item (`group[i] == -1`) a unique synthetic group so every item belongs to exactly one group. Then build item-level dependencies for all edges and group-level dependencies only when an edge crosses groups. If either topo sort has a cycle, no valid ordering exists. Otherwise, take the item topological order, bucket those items by group, and output buckets in group topological order so both within-group and cross-group constraints are preserved.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

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

## Complexity

Time O(n + m + edges), Space O(n + m + edges).

## Mistakes To Watch

- Ignoring ungrouped items; assign each -1 item a unique group.
- Only sorting groups and forgetting item-level order inside each group.

## Final Interview Explanation

I would explain this as two coordinated topological sorts. Item order enforces every dependency, while group order enforces cross-group dependencies. After both orders are valid, bucket items by group according to item order, then emit the buckets in group order.
