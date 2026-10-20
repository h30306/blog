---
title: "LeetCode 2509: Cycle Length Queries in a Tree"
summary: "LeetCode 2509 note: in heap numbering the parent is v // 2, so climb the larger node until both meet at the LCA"
description: "LeetCode 2509 record from 2026-09-11"
date: 2026-09-11
tags: ["hard", "tree", "binary-tree", "lca"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-11
- Submissions: Accepted (first try)

## Approach

Adding an edge between `a` and `b` creates a cycle made of the tree path from `a` to `b` plus the new edge, so:

```text
cycle length = dist(a, b) + 1
```

The tree is numbered like a heap: the root is 1, the children of `v` are `2v` and `2v + 1`, and the parent is `v // 2`.

To get `dist(a, b)`, climb both nodes to their lowest common ancestor (LCA). **The larger value is always on the same level or deeper**, so repeatedly halve the larger one until both are equal; the number of steps is the distance.

## My Solution

```python
class Solution:
    def cycleLengthQueries(self, n: int, queries: List[List[int]]) -> List[int]:
        res = []
        for x, y in queries:
            step = 1                  # the newly added edge
            while x != y:
                if x > y:
                    x //= 2
                else:
                    y //= 2
                step += 1
            res.append(step)
        return res
```

## Complexity

Each query climbs at most `2n` steps (the tree height is `n`), so time is `O(m * n)` with `n <= 30`. Space `O(1)` excluding the output.

## Mistakes to Avoid

- Building the tree and running BFS: it has `2^30` nodes and cannot be built.
- Forgetting the added edge, which makes the answer one short.
- Climbing only one node: always move the deeper one.

## Interview Explanation

The cycle formed by the new edge has length equal to the tree distance plus 1. The tree uses heap numbering, so the parent is `v // 2`, and a larger value is never shallower. I keep halving the larger value until the two nodes match; the step count is the distance. Each query takes at most `O(n)` steps, with `n` at most 30.
