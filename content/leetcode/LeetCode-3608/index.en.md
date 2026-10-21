---
title: "LeetCode 3608: Minimum Time for K Connected Components"
summary: "LeetCode 3608 note: add edges back from the largest time; the time of the first edge that drops the component count below k is the answer"
description: "LeetCode 3608 record from 2025-07-06"
date: 2025-07-06
tags: ["medium", "union-find", "graph", "sorting", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-06
- Submissions: Wrong Answer → Accepted

## Approach

After removing every edge with time `<= t`, the edges with time `> t` remain. Larger `t` leaves fewer edges and more components, so it is monotonic and could be binary searched, but **adding edges back in reverse** is more direct ([Union-Find]({{< relref "/algorithm/Union-Find" >}}), edges sorted by weight):

- Add edges to Union-Find from the largest time down.
- Before adding an edge with time `t`, the graph only has edges with time `>= t`, and there are still `>= k` components.
- If adding it drops the count below `k` for the first time, keeping it leaves too few components, so it must be removed and the answer is `t`.
- If the count stays `>= k` after everything, nothing needs removing, so the answer is 0.

## My Attempts

Attempt 1's `union` wrote `parent[x] = root_y`, **attaching node `x`, not its root**. For `n = 3`, `edges = [[0, 2, 3], [0, 1, 6], [2, 1, 1]]`, `k = 1` there is already 1 component, so the answer is 0.

By decreasing time it first merged 0 and 1 (`parent[0] = 1`), then, merging 0 and 2, changed `parent[0]` to 2 **and left 1 behind**. Merging 2 and 1 then saw different roots and counted another merge, bringing the count to 0, and it returned 1. Changing to `parent[root_x] = root_y` passed.

## Solution

```python
class Solution:
    def minTime(self, n: int, edges: List[List[int]], k: int) -> int:
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        groups = n
        for u, v, t in sorted(edges, key=lambda e: -e[2]):
            ru, rv = find(u), find(v)
            if ru != rv:
                parent[ru] = rv
                groups -= 1
                if groups < k:
                    return t
        return 0
```

## Complexity

Time `O(E log E + E · α(n))`, space `O(n)`.

## Mistakes to Avoid

- `union` must attach a **root** to another root.
- The count only drops on a real merge; edges inside one component do not count.

## Interview Explanation

Removal is awkward, so I go backward and add edges from the largest time down. Before an edge is added only larger-time edges exist and there are enough components; if adding it leaves too few for the first time, that edge must be removed, so its time is the answer. If there are always enough, return 0. Time `O(E log E)`.
