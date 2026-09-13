---
title: "LeetCode 1631: Path With Minimum Effort"
summary: "LeetCode note for Path With Minimum Effort, rebuilt from the original learning note"
description: "Cleaned LeetCode 1631 article from 2026-04-25 with note repair points and final solution"
date: 2026-04-25
tags: ["medium", "graph", "dijkstra", "shortest-path"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-25
Source: Day 10 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- 4. Explain why `LC 1631` is still Dijkstra even though the path cost is not a sum.

## Learning Note Extract

#### Problem 3 - LC 1631 Path With Minimum Effort Review
- **Status:** Good enough after wording repair.
- **Pattern:** Dijkstra on a grid with non-sum path cost.

#### Why Dijkstra Still Works
The path cost is not the sum of edge weights.

Instead:
```text
new_effort = max(current_effort, abs(height_diff))
```

That means the path effort is:
```text
non-decreasing as the path extends
```

not strictly increasing.

That monotonic property is why Dijkstra still works.

#### Heap State
```text
(effort, row, col)
```

#### Transition
For each neighbor:
```text
new_effort = max(current_effort, abs(heights[r][c] - heights[nr][nc]))
```

#### Finalization Rule
```text
when a cell is popped from the min-heap for the first time, its minimum effort is finalized
```

#### Complexity
```text
Time: O(R * C * log(R * C))
Space: O(R * C)
```

#### Common Mistakes
- Do not say the effort strictly increases.
- Do not say time is just `O(R * C)`; heap operations add a log factor.
- Do not say a public key decrypts a signature in the TLS analogy. That was a separate wording issue from the topic block.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from heapq import heappop, heappush
from typing import List

class Solution:
    def minimumEffortPath(self, heights: List[List[int]]) -> int:
        m, n = len(heights), len(heights[0])
        dist = [[float('inf')] * n for _ in range(m)]
        dist[0][0] = 0
        heap = [(0, 0, 0)]
        dirs = [(1,0), (-1,0), (0,1), (0,-1)]

        while heap:
            effort, r, c = heappop(heap)
            if (r, c) == (m - 1, n - 1):
                return effort
            if effort != dist[r][c]:
                continue
            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n:
                    ne = max(effort, abs(heights[r][c] - heights[nr][nc]))
                    if ne < dist[nr][nc]:
                        dist[nr][nc] = ne
                        heappush(heap, (ne, nr, nc))
        return 0
```

## Complexity

Time O(mn log(mn)), Space O(mn).

## Mistakes To Watch

- Summing edge weights instead of taking max.
- Using plain BFS despite weighted efforts.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
