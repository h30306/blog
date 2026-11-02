---
title: "LeetCode 173: Binary Search Tree Iterator"
summary: "LeetCode 173 note: flattening to an array is simple but uses O(n) space; the follow-up keeps the left spine on a stack for amortized O(1) and O(h) space"
description: "LeetCode 173 record from 2026-10-24"
date: 2026-10-24
tags: ["medium", "stack", "tree", "design", "binary-search-tree", "binary-tree", "iterator"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-24
- Submissions: Accepted (first try)

## Approach

`next()` must return the BST values in in-order.

The simplest way: do an in-order traversal in the constructor, store the values in an array, and read the next one in `next()`.

The follow-up asks for average `O(1)` `next()` / `hasNext()` with `O(h)` space. Split the iterative in-order traversal into steps ([Tree]({{< relref "/algorithm/Tree" >}}) Template 8):

- The stack holds the left spine of nodes not yet returned. The constructor pushes the root and keeps going left.
- `next()`: pop a node, which is the next smallest value, then push the left spine of its right subtree.

## My Attempts

Accepted on the first try with the flattened-array version.

```python
class BSTIterator:
    def __init__(self, root: Optional[TreeNode]):
        self.nodes = []
        self.curr = 0

        def dfs(node):
            if not node:
                return
            dfs(node.left)
            self.nodes.append(node.val)
            dfs(node.right)

        dfs(root)

    def next(self) -> int:
        node = self.nodes[self.curr]
        self.curr += 1
        return node

    def hasNext(self) -> bool:
        return self.curr < len(self.nodes)
```

## Solution: stack, O(h) space

```python
class BSTIterator:
    def __init__(self, root: Optional[TreeNode]):
        self.stack = []
        self._push_left(root)

    def _push_left(self, node):
        while node:
            self.stack.append(node)
            node = node.left

    def next(self) -> int:
        node = self.stack.pop()
        self._push_left(node.right)
        return node.val

    def hasNext(self) -> bool:
        return bool(self.stack)
```

## Complexity

| Approach | `next()` | Space |
|---|---|---|
| Flattened array | `O(1)` | `O(n)` |
| Stack | amortized `O(1)`, worst `O(h)` | `O(h)` |

In the stack version every node is pushed and popped once, so `n` calls to `next()` cost `O(n)` in total.

## Mistakes to Avoid

- The flattened version passes, but an interviewer will ask for the `O(h)` space version.
- After popping in `next()`, push the right subtree's left spine, or the right side is skipped.

## Interview Explanation

The simplest version flattens the tree in-order in the constructor, but that is `O(n)` space. For `O(h)`, I simulate the iterative in-order traversal: push the left spine in the constructor; `next()` pops the next smallest node and pushes the left spine of its right subtree. Each node enters and leaves the stack once, so `next()` is amortized `O(1)` with `O(h)` space.
