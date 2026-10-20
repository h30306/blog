---
title: "LeetCode 499: The Maze III"
summary: "LeetCode 499 note: Dijkstra prioritized by (distance, path string), and the ball stops when it rolls over the hole"
description: "LeetCode 499 record from 2026-09-06"
date: 2026-09-06
tags: ["hard", "graph", "dijkstra", "shortest-path", "heap", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-06
- Submissions: Wrong Answer → Accepted → Accepted (cleaned up the same day)

## Approach

Each move picks a direction and the ball rolls until it hits a wall, **dropping into the hole if it passes over it**. Find the instructions with the fewest cells traveled; on ties, the lexicographically smallest instructions.

- Nodes: positions where the ball can stop.
- Edges: rolling from one stop in a direction to the next stop, weighted by the cells rolled.

Edge weights differ, so use Dijkstra, not BFS. Ties are broken lexicographically, so the heap priority is simply `(distance, path string)`: Python compares tuples by distance first, then by string.

## My Attempt: comparing only the path string

```python
pq = [("", ball[0], ball[1])]       # path alone is the priority
```

The first heap ordered only by path string, so it popped the lexicographically smallest path, not the shortest. Also, a stop was never updated once visited, even though a shorter path found later could reach the same stop.

The accepted version uses `(distance, path)` as the priority and records `visited[(r, c)] = (distance, path)` as each stop's best state, updating only when a new state is better.

## Solution

```python
import heapq

class Solution:
    def findShortestWay(self, maze: List[List[int]], ball: List[int], hole: List[int]) -> str:
        m, n = len(maze), len(maze[0])
        directions = (("d", 1, 0), ("l", 0, -1), ("r", 0, 1), ("u", -1, 0))
        best = {(ball[0], ball[1]): (0, "")}
        heap = [(0, "", ball[0], ball[1])]

        while heap:
            dist, path, r, c = heapq.heappop(heap)
            if [r, c] == hole:
                return path
            if best[(r, c)] < (dist, path):
                continue                                   # stale entry
            for ch, dr, dc in directions:
                nr, nc, step = r, c, 0
                while 0 <= nr + dr < m and 0 <= nc + dc < n and maze[nr + dr][nc + dc] == 0:
                    nr += dr
                    nc += dc
                    step += 1
                    if [nr, nc] == hole:                   # stop at the hole
                        break
                if step == 0:
                    continue
                state = (dist + step, path + ch)
                if (nr, nc) not in best or state < best[(nr, nc)]:
                    best[(nr, nc)] = state
                    heapq.heappush(heap, (*state, nr, nc))
        return "impossible"
```

## Complexity

Time `O(m n log(m n) · max(m, n))`: each pop rolls in four directions, up to `max(m, n)` cells each, plus the cost of comparing path strings. Space `O(m n)`.

## Mistakes to Avoid

- Prioritizing by path string alone, without comparing distance first.
- Not checking for the hole while rolling: the ball falls in as it passes and never reaches the wall.
- Using BFS: rolls cover different numbers of cells, so edge weights are not equal.
- Never updating a visited stop: a shorter or lexicographically smaller path may arrive later.

## Interview Explanation

Stopping positions are nodes and each roll to a stop is an edge weighted by the cells rolled. Weights differ, so I use Dijkstra, and since ties need the lexicographically smallest instructions, the heap priority is `(distance, path string)`. While rolling I check every cell for the hole and stop there. A dict keeps each stop's best `(distance, path)`, pushing only improvements, and the first time the hole is popped is the answer.
