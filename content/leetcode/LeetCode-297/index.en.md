---
title: "LeetCode 297: Serialize and Deserialize Binary Tree"
summary: "LeetCode 297 note: pre-order with null markers identifies the tree uniquely; deserialize by consuming tokens from an iterator"
description: "LeetCode 297 record from 2026-10-25"
date: 2026-10-25
tags: ["hard", "string", "tree", "depth-first-search", "breadth-first-search", "design", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-25
- Submissions: Accepted ×2

## Approach

Pre-order alone does not determine the tree's shape, but it does once **null children are written out**. Serialize with a pre-order DFS, write `#` for null, and separate values with commas (values may be negative or have several digits).

Deserialize by reading in the same pre-order:

- On `#`, return `None`.
- Otherwise create the node, then recursively build the left subtree, then the right.

Every subtree ends with `#` markers, so the recursion knows where the left subtree stops without any extra length information.

## My Attempts

Accepted on the first try on 2026-10-25. I practiced it again on 10-27, switching the null marker from `N` to `#` and the iterator to a `deque`, and it passed on the first try again.

## Solution

```python
class Codec:
    def serialize(self, root):
        res = []

        def dfs(node):
            if not node:
                res.append("#")
                return
            res.append(str(node.val))
            dfs(node.left)
            dfs(node.right)

        dfs(root)
        return ",".join(res)

    def deserialize(self, data):
        vals = iter(data.split(","))

        def dfs():
            val = next(vals)
            if val == "#":
                return None
            node = TreeNode(int(val))
            node.left = dfs()
            node.right = dfs()
            return node

        return dfs()
```

## Complexity

Both directions take `O(n)` time and `O(n)` space.

## Mistakes to Avoid

- Without null markers, a pre-order (or in-order) sequence matches many trees.
- Without a separator, negative and multi-digit values run together.
- `list.pop(0)` is `O(n)` and makes the whole thing `O(n^2)`; use an iterator or a `deque`.
- A very skewed tree makes the recursion deep; a BFS level-order format avoids that.

## Interview Explanation

I serialize with a pre-order DFS, writing `#` for null and separating values with commas. To deserialize I read in the same pre-order: `#` returns null, otherwise I create the node and recursively build its left and then right subtree. Because nulls are marked, the recursion knows where each subtree ends. Both directions are `O(n)`.
