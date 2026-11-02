---
title: "LeetCode 437: Path Sum III"
summary: "LeetCode 437 note: prefix sums on a tree with a hash map: look up prefix - target before adding the current prefix, and undo it when leaving the node"
description: "LeetCode 437 record from 2026-10-28"
date: 2026-10-28
tags: ["medium", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-28
- Submissions: Wrong Answer → Accepted

## Approach

Paths only go downward, so each path is a segment of some root-to-node path. This is "subarray sum equals K" on a tree ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) Template 3):

- During DFS keep `prefix`, the sum from the root to the current node.
- The number of paths ending at the current node with sum `target` equals the number of ancestors whose prefix sum is `prefix - target`.
- Keep a hash map of prefix-sum counts **on the current root-to-node path**, starting with `{0: 1}` for paths that start at the root.

When leaving a node, remove its prefix sum, or other branches would see sums that are not their ancestors.

## My Attempts

1. Added the current prefix to the map before looking up `prefix - target`. With `target = 0` the lookup finds the node itself, counting a zero-length path. For `[-2]` with `target = 0` it returned 1; the answer is 0.
2. Swapping the lookup and the insert passed.

## Solution

```python
class Solution:
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> int:
        count = defaultdict(int)
        count[0] = 1
        res = 0

        def dfs(node, prefix):
            nonlocal res
            if not node:
                return
            prefix += node.val
            res += count[prefix - targetSum]
            count[prefix] += 1
            dfs(node.left, prefix)
            dfs(node.right, prefix)
            count[prefix] -= 1

        dfs(root, 0)
        return res
```

## Complexity

Time `O(n)`, space `O(h)` (the recursion and the map only hold one path at a time). Brute force, searching down from every node, is `O(n^2)`.

## Mistakes to Avoid

- Look up first, then insert. Inserting first counts the empty path when `target = 0`.
- Undo with `count[prefix] -= 1` on the way back; the map must contain only ancestors.
- Do not forget `{0: 1}`, or paths starting at the root are never counted.

## Interview Explanation

Paths go downward only, so each is a segment of a root-to-node path and prefix sums apply. I keep the running prefix in DFS; the paths ending at the current node are the ancestors with prefix `prefix - target`, counted in a hash map seeded with `{0: 1}`. I look up before inserting the current prefix and remove it when leaving the node, so the map holds only ancestors. Time `O(n)`.
