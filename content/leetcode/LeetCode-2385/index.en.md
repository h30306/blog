---
title: "LeetCode 2385: Amount of Time for Binary Tree to Be Infected"
summary: "LeetCode 2385 note: turn the tree into an undirected graph and BFS from start; the number of levels minus one is the answer"
description: "LeetCode 2385 record from 2026-11-01"
date: 2026-11-01
tags: ["medium", "hash-table", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-11-01
- Submissions: Accepted (first try)

## Approach

Infection spreads to children and to the parent, so as in LC 863, first turn the tree into an undirected graph ([Tree]({{< relref "/algorithm/Tree" >}}) Template 5), then BFS from `start`. Each level is one minute, and the time of the last level is the answer: the number of BFS levels minus one.

In other words, the answer is the distance from `start` to the farthest node.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def amountOfTime(self, root: Optional[TreeNode], start: int) -> int:
        graph = defaultdict(list)
        queue = deque([root])
        while queue:
            node = queue.popleft()
            for child in (node.left, node.right):
                if child:
                    graph[node.val].append(child.val)
                    graph[child.val].append(node.val)
                    queue.append(child)

        minutes = -1
        seen = {start}
        queue = deque([start])
        while queue:
            minutes += 1
            for _ in range(len(queue)):
                node = queue.popleft()
                for nei in graph[node]:
                    if nei not in seen:
                        seen.add(nei)
                        queue.append(nei)
        return minutes
```

Building the graph with BFS instead of a recursive DFS avoids the recursion limit on deep trees (up to `10^5` nodes).

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Start `minutes` at -1: the first level is `start` itself, at time 0.
- Searching only downward without a graph misses the direction toward the parent.

## Interview Explanation

Infection also spreads to the parent, so I convert the tree into an undirected graph and BFS from `start`, one level per minute; the last level's time is the answer, i.e. the distance from `start` to the farthest node. I build the graph with BFS to avoid deep recursion. Time and space `O(n)`.
