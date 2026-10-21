---
title: "LeetCode 783: Minimum Distance Between BST Nodes"
summary: "LeetCode 783 note: a BST's in-order is ascending, so the minimum difference is between in-order neighbors; remember the previous value and compare"
description: "LeetCode 783 record from 2022-09-06"
date: 2022-09-06
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-06
- Submissions: Runtime Error → Accepted ×3 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×6 → Runtime Error → Wrong Answer ×4 → Accepted

## Approach

A BST's in-order traversal is sorted, and in a sorted sequence the closest pair is adjacent ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Remember the previous value during the in-order walk and update the answer with each difference. This is the same problem as LC 530.

## My Attempts

This took 19 submissions, nearly all from one misunderstanding: assuming the smallest difference is always **between a parent and a child**, so the recursion compared each node with its children (or with values returned from subtrees). The closest two values are adjacent in the in-order traversal, not necessarily parent and child: in `[3, None, 8, 4]`, 3 and 4 are not parent and child and differ by 1; it returned 4. Several versions also subtracted from `-inf` / `inf` initial values and returned `inf`.

## Solution

```python
class Solution:
    def minDiffInBST(self, root: Optional[TreeNode]) -> int:
        best, prev = float("inf"), None
        stack, cur = [], root
        while cur or stack:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            if prev is not None:
                best = min(best, cur.val - prev)
            prev = cur.val
            cur = cur.right
        return best
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The closest values need not be parent and child; compare in-order neighbors.

## Interview Explanation

A BST's in-order is sorted and the minimum difference lies between neighbors, so I keep the previous value during the in-order walk and update the minimum. Time `O(n)`.
