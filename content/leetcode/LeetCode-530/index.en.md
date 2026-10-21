---
title: "LeetCode 530: Minimum Absolute Difference in BST"
summary: "LeetCode 530 note: a BST's in-order is ascending, so the minimum difference is between in-order neighbors; remember the previous value and compare"
description: "LeetCode 530 record from 2022-08-25"
date: 2022-08-25
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
First Attempt: 2022-08-25
- Submissions: Accepted ×2

## Approach

A BST's in-order traversal is sorted, and in a sorted sequence the closest pair is adjacent ([Tree]({{< relref "/algorithm/Tree" >}}) Template 3). Remember the previous value during the in-order walk and update the answer with each difference. This is the same problem as LC 783.

## My Solution

```python
class Solution:
    def getMinimumDifference(self, root: Optional[TreeNode]) -> int:
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
