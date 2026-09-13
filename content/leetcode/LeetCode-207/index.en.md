---
title: "LeetCode 207: Course Schedule"
summary: "LeetCode note for Course Schedule, rebuilt from the original learning note"
description: "Cleaned LeetCode 207 article from 2026-04-08 with note repair points and final solution"
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

#### LC 207 - Course Schedule (Topological Sort / Cycle Detection)
- **Pattern:** Topological Sort (Kahn's BFS)
- **Key insight:** If a valid topological ordering exists -> no cycle -> return true
- **Approach:** Build adjacency list + in-degree array. Add all nodes with in-degree 0 to queue. Process queue; for each node, reduce each neighbor's in-degree, and when it reaches 0, add it to queue. If the number of processed courses equals `numCourses`, there is no cycle.
- **Complexity:** Time O(V + E), Space O(V + E)
- **Why deque over list:** `list.pop(0)` is O(n) because it shifts all elements. `deque.popleft()` is O(1).


## Organized Notes

This article should stay focused on the boolean cycle-detection version. `LC 210` uses the same topological process but returns the order; `LC 207` only needs to know whether every course can be processed. The two common repair points are edge direction (`pre -> course`) and not returning true until the processed count reaches `numCourses`.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import deque
from typing import List

class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        graph = [[] for _ in range(numCourses)]
        indeg = [0] * numCourses
        for course, pre in prerequisites:
            graph[pre].append(course)
            indeg[course] += 1

        q = deque(i for i in range(numCourses) if indeg[i] == 0)
        seen = 0
        while q:
            node = q.popleft()
            seen += 1
            for nei in graph[node]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return seen == numCourses
```

## Complexity

Time O(V+E), Space O(V+E).

## Mistakes To Watch

- Reversing edge direction inconsistently.
- Returning true before checking all nodes.

## Final Interview Explanation

I would build edges from prerequisite to course and count how many courses Kahn's algorithm can process. If a cycle exists, the queue eventually empties before all courses are processed. So `seen == numCourses` is the proof that all prerequisites can be satisfied.
