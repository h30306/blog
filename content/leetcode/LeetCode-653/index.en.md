---
title: "LeetCode 653: Two Sum IV - Input is a BST"
summary: "LeetCode 653 note: traverse while keeping a set of seen values; finding k - val in it means a pair exists"
description: "LeetCode 653 record from 2022-08-29"
date: 2022-08-29
tags: ["easy", "hash-table", "two-pointers", "tree", "depth-first-search"]
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
- Submissions: Runtime Error → Accepted ×3 → Wrong Answer → Runtime Error → Accepted

## Approach

Like Two Sum, keep a set of values seen ([Hash Table]({{< relref "/algorithm/Hash-Table" >}})). At each node, check whether `k - val` has appeared and return `True` if so, then add the node's value. In-order plus two pointers also exploits the BST order, but a set is simplest.

## My Attempts

Attempt 1 had an undefined variable. My accepted version had an extra `if k == 0: return False`, but `k` can be 0 with both -1 and 1 in the tree, so that check is actually wrong and simply was not tested; a November rewrite returned nothing in one version.

## Solution

```python
class Solution:
    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        seen, stack = set(), [root]
        while stack:
            node = stack.pop()
            if not node:
                continue
            if k - node.val in seen:
                return True
            seen.add(node.val)
            stack += [node.left, node.right]
        return False
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Check before adding, or a node pairs with itself.
- `k` can be 0 (say -1 and 1); do not treat `k == 0` as impossible.

## Interview Explanation

I traverse the tree with a set of seen values, checking `k - val` at each node before adding its own value. Time and space `O(n)`.
