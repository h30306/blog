---
title: "LeetCode 1782: Count Pairs Of Nodes"
summary: "LeetCode 1782 note: count pairs with deg[a] + deg[b] > q using sorted degrees and converging pointers, then correct the over-count for pairs that share edges"
description: "LeetCode 1782 record from 2026-01-24"
date: 2026-01-24
tags: ["hard", "two-pointers", "graph", "sorting", "hash-table", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-01-24
- Submissions: Wrong Answer → Runtime Error ×2 → Accepted

## Approach

`incident(a, b) = deg[a] + deg[b] - shared(a, b)`, where `shared(a, b)` is the number of edges between `a` and `b` (there can be duplicates).

Enumerating all pairs is `O(n^2)`, too slow. Split it into two steps:

1. **Ignore `shared` first**: count pairs with `deg[a] + deg[b] > q`. Sort the degrees and use converging pointers:
   - `deg[left] + deg[right] > q`: every index in `left..right - 1` works with `right`, so add `right - left` and move `right` left.
   - Otherwise move `left` right.
2. **Correct**: only connected pairs have `shared > 0`. For each connected `(u, v)`, if `deg[u] + deg[v] > q` but `deg[u] + deg[v] - shared <= q`, step 1 over-counted it, so subtract 1.

There are at most `E` connected pairs, so each query is `O(n + E)`.

## My Attempts

1. **Attempt 1, WA**: the `shared` key was `(u, v)` as given, without putting the smaller node first, so the duplicate edges `[1, 2]` and `[2, 1]` became two different pairs with one shared edge each, and the correction was wrong. For `n = 2`, `edges = [[1, 2], [2, 1]]`, `queries = [2]`, `incident(1, 2) = 2`, which is not greater than 2, so the answer is `[0]`; this returned `[1]`.
2. **Two REs**: typos in the swap, once using `u, v` before they were defined and once writing `i, j = j, v`.

## Solution

```python
class Solution:
    def countPairs(self, n: int, edges: List[List[int]], queries: List[int]) -> List[int]:
        deg = [0] * (n + 1)
        shared = Counter()
        for u, v in edges:
            deg[u] += 1
            deg[v] += 1
            shared[(min(u, v), max(u, v))] += 1   # merge duplicate edges under one key

        sorted_deg = sorted(deg[1:])
        ans = []
        for q in queries:
            count = 0
            left, right = 0, n - 1
            while left < right:
                if sorted_deg[left] + sorted_deg[right] > q:
                    count += right - left
                    right -= 1
                else:
                    left += 1
            for (u, v), c in shared.items():
                if deg[u] + deg[v] > q >= deg[u] + deg[v] - c:
                    count -= 1                     # fails once shared edges are removed
            ans.append(count)
        return ans
```

## Complexity

Time `O(n log n + Q · (n + E))`, space `O(n + E)`.

## Mistakes to Avoid

- Not normalizing undirected edge keys, which splits duplicate edges into two pairs.
- Enumerating all pairs in `O(n^2)`.

## Interview Explanation

`incident(a, b)` is the two degrees added together minus the edges between them. I first ignore shared edges: sort the degrees and count pairs whose sum exceeds `q` with converging pointers. Then, for each connected pair, if the degree sum exceeds `q` but drops to `q` or below after removing shared edges, I subtract one. Each query is `O(n + E)`.
