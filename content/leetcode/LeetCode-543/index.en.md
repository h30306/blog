---
title: "LeetCode 543: Diameter of Binary Tree"
summary: "LeetCode 543 note: the diameter may skip the root; return heights in post-order while updating the answer with left + right height at every node, counting edges"
description: "LeetCode 543 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Runtime Error ×5 → Wrong Answer ×3 → Runtime Error → Wrong Answer ×12 → Runtime Error ×2 → Accepted → Time Limit Exceeded → Accepted
- 2026-10-24 rewrite: Accepted ×2

## Approach

The longest path through a node has `left height + right height` edges ([Tree]({{< relref "/algorithm/Tree" >}}) Templates 1 and 5). The longest one **need not pass through the root**, so check every node. A post-order recursion returns heights and updates the answer along the way.

## My Attempts

This took 26 submissions in 2022, with three main errors:

- **Looking only at the root**: `maxDepth(root.left) + maxDepth(root.right)` fails when the longest path skips the root. For `[5, None, 8, 1, 7, 1, 2, 6]` the longest path lies in the right subtree with length 4; it returned 3.
- **Returning one side's height**: `max(left, right)`, e.g. `[4, 4, 8]` returned 1 instead of 2.
- **Counting nodes instead of edges**: a single node `[1]` returned 1 instead of 0.

## Solution

```python
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        best = 0
        def height(node):
            nonlocal best
            if not node:
                return 0
            l, r = height(node.left), height(node.right)
            best = max(best, l + r)                  # 經過這個節點的最長路徑
            return 1 + max(l, r)
        height(root)
        return best
```

## 2026-10 Rewrite

Both submissions passed on the first try:

1. A post-order returning `(longest path inside the subtree, height)`, with an empty node's height set to `-1`, so the path through a node is `left + right + 2`. No outer variable, but the `-1` and `+ 2` need care.
2. Rewrote it as above: heights start at 0, the answer lives in `self.diameter`, and the path through a node is simply `left + right`.

None of the three mistakes behind the 26 submissions in 2022 (only checking the root, returning one side, counting nodes instead of edges) came back.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The diameter counts edges, not nodes.
- It may skip the root; update at every node.

## Interview Explanation

The diameter may skip the root, so a post-order pass returns subtree heights and updates the answer with left plus right height at each node. One pass, time `O(n)`.
