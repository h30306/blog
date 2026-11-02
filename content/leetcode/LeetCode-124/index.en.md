---
title: "LeetCode 124: Binary Tree Maximum Path Sum"
summary: "LeetCode 124 note: DFS returns the best downward chain and updates the answer with left chain + node + right chain at every node; drop negative chains"
description: "LeetCode 124 record from 2026-10-24"
date: 2026-10-24
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-24
- Submissions: Wrong Answer ×4 → Accepted

## Approach

A path can "bend" at any node. Use the DFS return-value pattern ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1):

- `dfs(node)` returns the best sum of a chain going **down** from `node`. Only one side can be returned upward, because a path cannot fork.
- At every node, update the answer with left chain + node + right chain: the best path that bends here.
- A negative chain is not worth taking, so clamp it to 0: `left = max(0, dfs(node.left))`.

Start the answer at `-inf`, since every value may be negative.

## My Attempts

Four wrong answers before passing, all about negative numbers:

1. Negative chains were not dropped: `[-2,-5]` returned -5, the answer is -2. The root alone is -2, but the update always added the left chain -5.
2. Added `node.val` alone as a candidate: `[1,5,-3]` returned 5, the answer is 6 (5 → 1). The update still added both sides (`5 + 1 - 3 = 3`) and never tried the left side alone.
3. Changed the return value to `max(left + val, right + val, val)` but still added both sides in the update: `[3,-4]` returned -1, the answer is 3. The fourth submission was identical.
4. Clamping both chains with `max(0, ...)` passed.

## Solution

```python
class Solution:
    def maxPathSum(self, root: Optional[TreeNode]) -> int:
        best = -inf

        def dfs(node):
            nonlocal best
            if not node:
                return 0
            left = max(0, dfs(node.left))
            right = max(0, dfs(node.right))
            best = max(best, left + right + node.val)
            return max(left, right) + node.val

        dfs(root)
        return best
```

With both chains clamped to be non-negative, returning `max(left, right) + node.val` is enough.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The value returned upward is **one chain** (one side); the value used for the answer adds **both sides**. They are different.
- Treat a negative child chain as 0, otherwise it is forced into the sum.
- Start the answer at `-inf`, not 0: if every value is negative, the answer is the largest negative value.

## Interview Explanation

I run a post-order DFS where each node returns the best downward chain sum, with negative chains treated as 0. At each node, left chain + node + right chain is the best path bending there, so I update the answer with it, and I return only the larger side plus the node because a path cannot fork. The answer starts at `-inf`. Time `O(n)`, space `O(h)`.
