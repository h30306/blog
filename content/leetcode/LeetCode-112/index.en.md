---
title: "LeetCode 112: Path Sum"
summary: "LeetCode 112 note: subtract each value from targetSum on the way down; it works if the remainder matches at a leaf"
description: "LeetCode 112 record from 2022-08-16"
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
- Submissions: Runtime Error → Accepted → Wrong Answer → Runtime Error → Accepted
- 2026-10-27 rewrite: Wrong Answer ×2 → Accepted ×3

## Approach

Subtract the current value from the target on the way down ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). At a **leaf**, the path works if the remaining target equals the leaf's value. Only leaves count; hitting the sum at an internal node does not.

## My Attempts

One version wrote `root == targetSum`, comparing **the node itself** with an integer, never equal: `[5]`, `targetSum = 5` returned `False`. Two others had an undefined variable and a type error.

## Solution

```python
class Solution:
    def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
        if not root:
            return False
        if not root.left and not root.right:
            return root.val == targetSum
        rest = targetSum - root.val
        return self.hasPathSum(root.left, rest) or self.hasPathSum(root.right, rest)
```

## 2026-10 Rewrite

This time I used BFS with `(node, sum up to the parent)` in the queue, and got it wrong twice:

1. Checked `curr == targetSum`, where `curr` **excludes the node itself**, so the root's value was never added: `[5]`, `targetSum = 5` returned `False`.
2. Changed it to `curr + node.val == targetSum` but **did not check for a leaf**: `[1,2]`, `targetSum = 1` returned `True` at the root, the answer is `False` (the only path is 1→2, summing to 3).
3. Adding `not node.left and not node.right` passed.
4. Finally the recursive version, the same as above, accepted on the first try.

The second mistake is exactly the "it only counts at a leaf" point above.

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- Compare `root.val`, not the node.
- Check only at leaves.

## Interview Explanation

Recursing down, I subtract each value from the target and check at leaves whether the remainder equals the leaf; either side succeeding returns `True`. Time `O(n)`.
