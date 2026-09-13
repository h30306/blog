---
title: "LeetCode 210: Course Schedule II"
summary: "LeetCode note for Course Schedule II, rebuilt from the original learning note"
description: "Cleaned LeetCode 210 article from 2026-04-08 with note repair points and final solution"
date: 2026-04-08
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
First Attempt: 2026-04-08
Source: Day 1 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Learning Note Extract

#### LC 210 — Course Schedule II (Topological Sort / Return Order)
- **Pattern:** Same as LC 207 but return the actual ordering
- **Key insight:** The order nodes are popped from the queue IS the topological order
- **Difference from LC 207:** Append each popped node to result list. If `len(result) == numCourses` → valid order exists.

## Organized Notes

This is the order-returning version of `LC 207`. The graph and indegree construction are identical: an edge goes from prerequisite to course. The difference is that every popped node is appended to `order`, and the result is valid only if the order covers every course. If a cycle remains, some indegrees never drop to zero, so returning the partial order would be wrong.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import deque
from typing import List

class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        graph = [[] for _ in range(numCourses)]
        indeg = [0] * numCourses
        for course, pre in prerequisites:
            graph[pre].append(course)
            indeg[course] += 1

        q = deque(i for i in range(numCourses) if indeg[i] == 0)
        order = []
        while q:
            node = q.popleft()
            order.append(node)
            for nei in graph[node]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return order if len(order) == numCourses else []
```

## Complexity

Time O(V+E), Space O(V+E).

## Mistakes To Watch

- Returning partial order when a cycle remains.
- Confusing prerequisite edge direction.

## Final Interview Explanation

I would use the same Kahn topo process as Course Schedule, but append each popped course to an order list. The order is valid only if it contains all courses; otherwise a cycle blocked some courses, and the correct return value is an empty list.
