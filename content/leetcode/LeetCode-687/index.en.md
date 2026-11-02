---
title: "LeetCode 687: Longest Univalue Path"
summary: "LeetCode 687 note: DFS returns the longest same-value downward chain in edges, and each node updates the answer with left + right"
description: "LeetCode 687 record from 2026-10-24"
date: 2026-10-24
tags: ["medium", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
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
- Submissions: Wrong Answer ×2 → Accepted ×2

## Approach

It is the diameter pattern (LC 543), a DFS return value ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1), with the extra rule that values must match:

- `dfs(node)` returns the longest downward chain (in edges) from `node` where every value equals `node.val`.
- If the left child has the same value, `left = dfs(node.left) + 1`, otherwise `left = 0`. Same for the right.
- The path bending at `node` has length `left + right` and updates the answer; return `max(left, right)` upward.

## My Attempts

1. Passed the node object instead of its value down as the parent value, so `node.val == parent` was always `False` and every node returned 0: `[2,2]` returned 0, the answer is 1.
2. Passed `node.val`, but an empty tree returned `0 - 1 = -1`; the answer is 0.
3. Adding the empty-tree check passed.
4. Rewrote it to count edges directly without passing the parent value; also accepted.

## Solution

```python
class Solution:
    def longestUnivaluePath(self, root: Optional[TreeNode]) -> int:
        self.longest = 0

        def dfs(node):
            if not node:
                return 0
            left_len = dfs(node.left)
            right_len = dfs(node.right)
            left = left_len + 1 if node.left and node.left.val == node.val else 0
            right = right_len + 1 if node.right and node.right.val == node.val else 0
            self.longest = max(self.longest, left + right)
            return max(left, right)

        dfs(root)
        return self.longest
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Recurse into both children even when their values differ; a longer same-value path may lie below.
- Count **edges**. Counting nodes and subtracting 1 gives -1 for an empty tree.
- Pass `node.val`, not the node itself.

## Interview Explanation

This is the diameter pattern: DFS returns the longest downward chain, but a child only extends it when its value equals the node's, otherwise that side is 0. At each node, left chain plus right chain updates the answer, and the longer side is returned upward. The answer counts edges; time `O(n)`.
