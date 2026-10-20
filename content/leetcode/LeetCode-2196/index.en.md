---
title: "LeetCode 2196: Create Binary Tree From Descriptions"
summary: "LeetCode 2196 note: keep nodes in a dict and link them in one pass; the root is the only value that is nobody's child"
description: "LeetCode 2196 record from 2026-06-26"
date: 2026-06-26
tags: ["medium", "tree", "binary-tree", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-06-26
- Submissions: Accepted (first try)

## Approach

Two tasks:

1. **Find the root**: the only value that appears but is never anyone's child.
2. **Build the tree**: attach each child to the left or right of its parent as described.

## My Solution: a parent → children table, then build recursively

```python
from collections import defaultdict

class Solution:
    def createBinaryTree(self, descriptions: List[List[int]]) -> Optional[TreeNode]:
        parent_map = defaultdict(list)
        child_set = set()
        for parent, child, isLeft in descriptions:
            parent_map[parent].append((child, isLeft))
            child_set.add(child)

        root = (set(parent_map.keys()) - child_set).pop()

        def build_tree(node):
            if node.val not in parent_map:
                return node
            for child, isLeft in parent_map[node.val]:
                if isLeft:
                    node.left = build_tree(TreeNode(child))
                else:
                    node.right = build_tree(TreeNode(child))
            return node

        return build_tree(TreeNode(root))
```

Correct, with one risk: there can be `10^4` descriptions, and a chain-shaped tree makes the recursion `10^4` deep, past Python's default limit.

## Improved: a dict of nodes, linked in one loop

No recursion needed: map each value to its node and link nodes as you read each description.

```python
class Solution:
    def createBinaryTree(self, descriptions: List[List[int]]) -> Optional[TreeNode]:
        nodes = {}
        children = set()
        for parent, child, is_left in descriptions:
            if parent not in nodes:
                nodes[parent] = TreeNode(parent)
            if child not in nodes:
                nodes[child] = TreeNode(child)
            if is_left:
                nodes[parent].left = nodes[child]
            else:
                nodes[parent].right = nodes[child]
            children.add(child)

        root = next(v for v in nodes if v not in children)
        return nodes[root]
```

## Complexity

Time `O(n)`, space `O(n)`, where `n` is the number of descriptions.

## Mistakes to Avoid

- Calling `TreeNode(...)` every time a value appears: one value becomes several different nodes and the tree falls apart.
- Recursive building that hits the recursion limit on a chain-shaped tree.

## Interview Explanation

I map each value to a single node in a dict, scan the descriptions once to attach each child to its parent's left or right, and record every child I see. The root is the only value not in the child set. There is no recursion, so depth is not an issue, and time and space are `O(n)`.
