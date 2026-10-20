---
title: "LeetCode 865: Smallest Subtree with all the Deepest Nodes"
summary: "LeetCode 865 note: BFS to the last level and climb together, or one DFS returning (depth, node)"
description: "LeetCode 865 record from 2026-01-09"
date: 2026-01-09
tags: ["medium", "tree", "binary-tree", "bfs", "dfs", "lca"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-09
- Submissions: Accepted (first try)
- Same problem: LC 1123 Lowest Common Ancestor of Deepest Leaves

## Approach

"The smallest subtree containing all the deepest nodes" is **the lowest common ancestor (LCA) of all the deepest nodes**.

## My Solution: BFS to the last level, then climb as a group

1. BFS while recording each node's parent, keeping the nodes of the last level.
2. Put the last level in a set and move the whole set up one level at a time until one node is left.

```python
from collections import deque

class Solution:
    def subtreeWithAllDeepest(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        if not root:
            return None

        parent = {root: None}
        q = deque([root])
        last_level = []
        while q:
            last_level = []
            for _ in range(len(q)):
                node = q.popleft()
                last_level.append(node)
                if node.left:
                    parent[node.left] = node
                    q.append(node.left)
                if node.right:
                    parent[node.right] = node
                    q.append(node.right)

        deepest = set(last_level)
        while len(deepest) > 1:
            deepest = {parent[node] for node in deepest}
        return deepest.pop()
```

All deepest nodes are on the same level, so moving them up together keeps their depths equal. The first time the set collapses to one node, that node is the LCA.

## Alternative: one DFS returning (depth, answer)

Each node returns the maximum depth of its subtree and the answer node for that subtree:

- Left is deeper: the answer is in the left subtree.
- Right is deeper: the answer is in the right subtree.
- Equal depth: both sides contain deepest nodes, so the answer is the current node.

```python
class Solution:
    def subtreeWithAllDeepest(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        def dfs(node):
            if not node:
                return 0, None
            left_depth, left_ans = dfs(node.left)
            right_depth, right_ans = dfs(node.right)
            if left_depth > right_depth:
                return left_depth + 1, left_ans
            if right_depth > left_depth:
                return right_depth + 1, right_ans
            return left_depth + 1, node

        return dfs(root)[1]
```

## Complexity

| Approach | Time | Space |
|---|---|---|
| BFS + climbing | worst `O(n * h)`, each climb step touches the whole set | `O(n)` |
| DFS returning a tuple | `O(n)` | `O(h)` |

## Mistakes to Avoid

- Returning one deepest node: there can be several.
- In the DFS version, returning a child instead of the current node on a tie.

## Interview Explanation

The smallest subtree containing all deepest nodes is their LCA. I run one post-order DFS where each node returns its subtree's maximum depth and the answer: whichever side is deeper holds the answer, and if both sides are equally deep, the deepest nodes are split across them, so the answer is the current node. Time `O(n)`, space is the tree height.
