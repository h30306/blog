---
title: "LeetCode 1339: Maximum Product of Splitted Binary Tree"
summary: "LeetCode 1339 note: compute the total, enumerate every subtree sum, and leave the input untouched"
description: "LeetCode 1339 record from 2026-01-09"
date: 2026-01-09
tags: ["medium", "tree", "binary-tree", "dfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-09
- Submissions: Accepted (first try)

## Approach

Cutting one edge splits off one whole subtree. If that subtree sums to `s` and the whole tree to `total`, the product is `s * (total - s)`.

So all you need is **the sum of every subtree**, then one pass to take the maximum.

The problem asks you to maximize first and take the modulo afterwards, not while computing.

## My Solution: write subtree sums back into node.val

```python
from collections import deque

class Solution:
    def maxProduct(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return 0
            node.val += dfs(node.left) + dfs(node.right)
            return node.val

        total = dfs(root)

        ans = 0
        q = deque([root])
        while q:
            node = q.popleft()
            ans = max(ans, (total - node.val) * node.val)
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)
        return ans % (10 ** 9 + 7)
```

Correct, and Python integers do not overflow, so comparing before the modulo works.

Possible improvements:

- **Writing subtree sums into `node.val` destroys the input.** Store them separately in an interview.
- The second BFS is unnecessary: the DFS can collect every subtree sum.

## Improved: collect subtree sums in one DFS

```python
class Solution:
    def maxProduct(self, root: Optional[TreeNode]) -> int:
        sums = []

        def dfs(node):
            if not node:
                return 0
            s = node.val + dfs(node.left) + dfs(node.right)
            sums.append(s)
            return s

        total = dfs(root)
        return max(s * (total - s) for s in sums) % (10 ** 9 + 7)
```

The root's sum is also in `sums`, but its product is `total * 0 = 0`, so it never wins.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Taking the modulo before comparing: the ordering changes after the modulo.
- In Java/C++, use `long`; the total is at most `5 * 10^8`, so the product can reach about `(2.5 * 10^8)^2`.
- Modifying `node.val` without saying so; an interviewer may ask about it.

## Interview Explanation

Cutting one edge splits off a subtree, and the product is the subtree sum times the rest. One post-order DFS computes the total and collects every subtree sum; then I take the maximum of `s * (total - s)` and apply the modulo only at the end. Time and space are `O(n)`.
