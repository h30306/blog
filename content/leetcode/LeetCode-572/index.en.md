---
title: "LeetCode 572: Subtree of Another Tree"
summary: "LeetCode 572 note: for every node of root, check whether its subtree equals subRoot; recurse with isSubtree, not by comparing only the children"
description: "LeetCode 572 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "string-matching", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-27
- Submissions: Wrong Answer ×2 → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Accepted ×2 → Runtime Error ×3 → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted → Wrong Answer ×3 → Accepted

## Approach

A subtree must match from some node all the way down ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1). So compare at **every node** of `root` with LC 100's check:

- If the tree rooted here equals `subRoot`, return `True`.
- Otherwise **keep searching** the left and right subtrees (call `isSubtree`, not `isSame`).

## My Attempts

This took 23 submissions:

- Attempt 1's stack only popped, never pushed children, and never really compared trees, so even `[1]` and `[1]` returned `False`.
- Many later versions had the same bug: after checking the root, they called only `isSame(root.left, subRoot)` and `isSame(root.right, subRoot)`, **reaching just the second level**. With root `[1, 1, 1, 2]` and subRoot `[2]`, the `2` is on the third level, so the answer is `True`; they returned `False`.

## Solution

```python
class Solution:
    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        def same(a, b):
            if not a or not b:
                return a is b
            return a.val == b.val and same(a.left, b.left) and same(a.right, b.right)
        if not root:
            return False
        return same(root, subRoot) or self.isSubtree(root.left, subRoot) or self.isSubtree(root.right, subRoot)
```

## Complexity

Time `O(m · n)`, space `O(h)`. Serializing and string matching gives `O(m + n)`.

## Mistakes to Avoid

- Recurse with `isSubtree` when searching down, or only the second level gets checked.
- An empty `root` returns `False` (`subRoot` has at least one node).

## Interview Explanation

At every node of the main tree I check whether its subtree is identical to the target, returning `True` on a match and otherwise searching both subtrees. Time `O(mn)`.
