---
title: "LeetCode 449: Serialize and Deserialize BST"
summary: "LeetCode 449 note: for a BST, pre-order without null markers is enough; deserialize recursively with bounds in O(n)"
description: "LeetCode 449 record from 2026-10-25"
date: 2026-10-25
tags: ["medium", "string", "tree", "depth-first-search", "breadth-first-search", "design", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-25
- Submissions: Accepted ×3

## Approach

The difference from LC 297 is that this is a **BST**, so null markers are unnecessary and the string can be shorter.

- Serialize: pre-order, values only.
- Deserialize: the first pre-order value is the root. Recurse with a valid range `(low, high)` ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3): if the next value is outside the range, it does not belong to this subtree, so return `None` and let an ancestor take it. The left subtree's range is `(low, val)` and the right subtree's is `(val, high)`.

Each value is read once, so it is `O(n)`. It is the same technique as LC 1008 (BST from pre-order).

## My Attempts

All three submissions passed on the first try: on 10-25 with space separators and then commas, and a rewrite on 10-27.

The first version named its function `inorder`, but it appends before recursing, so it is actually **pre-order**. A real in-order sequence of a BST is just the sorted values, identical for every shape, and cannot be decoded.

## Solution

```python
class Codec:
    def serialize(self, root: Optional[TreeNode]) -> str:
        res = []

        def preorder(node):
            if not node:
                return
            res.append(str(node.val))
            preorder(node.left)
            preorder(node.right)

        preorder(root)
        return ",".join(res)

    def deserialize(self, data: str) -> Optional[TreeNode]:
        if not data:
            return None
        vals = deque(int(x) for x in data.split(","))

        def build(low, high):
            if not vals or not low < vals[0] < high:
                return None
            val = vals.popleft()
            node = TreeNode(val)
            node.left = build(low, val)
            node.right = build(val, high)
            return node

        return build(-inf, inf)
```

## Complexity

Both directions take `O(n)` time and `O(n)` space.

## Mistakes to Avoid

- An empty tree serializes to an empty string; `"".split(",")` gives `[""]` and `int("")` fails, so check first.
- Serialize in pre-order (or post-order), never in-order.
- Do not split the array at each level to find the boundary; that is `O(n^2)` in the worst case.

## Interview Explanation

Since it is a BST, I store only the pre-order values with no null markers. To deserialize, the first value is the root and I recurse with bounds: if the next value is out of range I return null and let an ancestor take it; the left subtree's upper bound and the right subtree's lower bound are the root's value. Each value is read once, so time is `O(n)`.
