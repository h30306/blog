---
title: "LeetCode 110: Balanced Binary Tree"
summary: "LeetCode 110 note: every node's subtree heights must differ by at most 1; return heights in post-order and propagate -1 once unbalanced"
description: "LeetCode 110 record from 2022-08-16"
date: 2022-08-16
tags: ["easy", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-16
- Submissions: Wrong Answer → Runtime Error ×2 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted → Wrong Answer ×2 → Accepted ×2 → Runtime Error → Accepted → Time Limit Exceeded → Accepted ×2 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2

## Approach

Balance requires **every node** to be balanced, not just the root ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). Return subtree heights in post-order, returning `-1` as soon as a node is unbalanced; ancestors seeing `-1` pass it up, so one pass suffices, `O(n)`.

## My Attempts

This took 18 submissions in 2022 and 5 more failures when rewriting it in 2026:

- Many were an unhandled empty tree (`None.left`) or an undefined variable.
- Two versions **checked only the root**: `abs(depth(root.left) - depth(root.right)) <= 1`. For `[5, 5, 1, 5, None, 5, 3, 4]` the root's sides differ by 1, but the left child has two levels on its left and nothing on its right, so the answer is `False`; they returned `True`.
- The 2026 versions still failed on the empty tree.

## Solution

```python
class Solution:
    def isBalanced(self, root: Optional[TreeNode]) -> bool:
        def height(node):
            if not node:
                return 0
            l, r = height(node.left), height(node.right)
            if l < 0 or r < 0 or abs(l - r) > 1:
                return -1                            # 已經不平衡
            return 1 + max(l, r)
        return height(root) >= 0
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Checking only the root's height difference is not enough; every node below must balance too.
- Recomputing heights at every node is `O(n²)`; propagating `-1` is `O(n)`.

## Interview Explanation

Every node must balance, so I return heights in post-order, propagating `-1` once a node fails, and check whether the root's result is `-1`. One pass, time `O(n)`.
