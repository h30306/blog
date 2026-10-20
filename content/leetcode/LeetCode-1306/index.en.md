---
title: "LeetCode 1306: Jump Game III"
summary: "LeetCode 1306 note: indices are nodes and the two jumps are edges; BFS or DFS decides whether a zero is reachable"
description: "LeetCode 1306 record from 2026-01-05"
date: 2026-01-05
tags: ["medium", "bfs", "dfs", "graph", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-05
- Submissions: Accepted (first try)

## Approach

From index `i` you can jump to `i + arr[i]` or `i - arr[i]`. Can you reach any index holding 0 from `start`?

With indices as nodes and the two jumps as edges, this is **reachability**: BFS or DFS both work, as long as visited indices are marked to avoid jumping back and forth.

## My Solution

The original was a recursive DFS:

```python
def dfs(idx):
    if arr[idx] == 0:
        return True
    reach[idx] = True
    res = False
    forward = idx + arr[idx]
    if forward < n and not reach[forward]:
        res |= dfs(forward)
    backward = idx - arr[idx]
    if backward >= 0 and not reach[backward]:
        res |= dfs(backward)
    return res
```

It passes, but with `n` up to `5 * 10^4` the recursion can exceed Python's limit. Also, `res |= ...` keeps exploring the other side after finding a zero, where it could return immediately. A BFS version:

```python
from collections import deque

class Solution:
    def canReach(self, arr: List[int], start: int) -> bool:
        n = len(arr)
        seen = [False] * n
        seen[start] = True
        q = deque([start])
        while q:
            i = q.popleft()
            if arr[i] == 0:
                return True
            for j in (i + arr[i], i - arr[i]):
                if 0 <= j < n and not seen[j]:
                    seen[j] = True
                    q.append(j)
        return False
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Not marking visited indices: the search bounces between two indices forever.
- Recursive DFS exceeding the recursion limit for large `n`.

## Interview Explanation

I treat each index as a node with two edges, the left and right jumps, so the question is whether a node with value 0 is reachable from `start`. BFS with a `seen` array visits each index at most once and returns `True` on reaching a zero, in `O(n)` time.
