---
title: "LeetCode 111: Minimum Depth of Binary Tree"
summary: "LeetCode 111 note: minimum depth must end at a leaf; with only one child, the empty side (depth 0) cannot count as the minimum"
description: "LeetCode 111 record from 2022-08-16"
date: 2022-08-16
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
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
- Submissions: Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×2

## Approach

Unlike maximum depth, when **only one child exists** the empty side is not a leaf and cannot count ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1):

- Empty tree: 0.
- Leaf: 1.
- One child: 1 + that side's minimum depth.
- Both children: 1 + the smaller of the two.

## My Attempts

Attempt 1 wrote `min(left, right) + 1`, treating the empty side (depth 0) as the minimum when only one child exists. For `[3, 3]` (left child only) the answer is 2; it returned 1.

## Solution

```python
class Solution:
    def minDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0
        if not root.left or not root.right:
            return 1 + self.minDepth(root.left or root.right)
        return 1 + min(self.minDepth(root.left), self.minDepth(root.right))
```

## Complexity

Time `O(n)`, space `O(h)`. A BFS that stops at the first leaf is faster in practice.

## Mistakes to Avoid

- With one child missing, the empty side has depth 0 but is not a leaf.

## Interview Explanation

Minimum depth must reach a leaf: with one child only that side counts, and with both I take the smaller; recursion handles the three cases. Time `O(n)`.
