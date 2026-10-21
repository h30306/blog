---
title: "LeetCode 671: Second Minimum Node In a Binary Tree"
summary: "LeetCode 671 note: the root is the minimum; the second minimum is the smallest value larger than the root, and only subtrees equal to the root need searching"
description: "LeetCode 671 record from 2022-08-29"
date: 2022-08-29
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
First Attempt: 2022-08-29
- Submissions: Wrong Answer ×4 → Accepted ×3 → Wrong Answer ×6 → Accepted ×3

## Approach

Each node equals the smaller of its two children, so **the root is the minimum**. The second minimum is the smallest value larger than the root ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1):

- A node larger than the root: nothing smaller lies below it (children are never smaller), so return it.
- A node equal to the root: the answer may lie below, so keep searching.

## My Attempts

The early versions looked only at the root's two children and took `max(left, right)`, but the second minimum can be deeper: for `[2, 2, 6, 3, 2]` the left child 2 has a 3 below it, so the answer is 3; they returned 6. Later versions missed "all values equal" or "a single node", returning `inf` or the root's value instead of `-1`.

## Solution

```python
class Solution:
    def findSecondMinimumValue(self, root: Optional[TreeNode]) -> int:
        def find(node):
            if not node:
                return -1
            if node.val > root.val:
                return node.val
            l, r = find(node.left), find(node.right)
            if l == -1 or r == -1:
                return max(l, r)
            return min(l, r)
        return find(root)
```

## Complexity

Time `O(n)`, space `O(h)`.

## Mistakes to Avoid

- The second minimum may be deep; do not look only at the root's children.
- If every value is the same, return `-1`.

## Interview Explanation

The root is the minimum, so I look for the smallest value above it: a larger node returns immediately, nodes equal to the root keep searching, and I take the smaller valid result. Time `O(n)`.
