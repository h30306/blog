---
title: "LeetCode 515: Find Largest Value in Each Tree Row"
summary: "LeetCode 515 note: BFS level order, taking the maximum of each level; start from -inf"
description: "LeetCode 515 record from 2026-10-24"
date: 2026-10-24
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-10-24
- Submissions: Accepted (first try)

## Approach

BFS level order ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2), keeping one maximum per level. Values can be negative (down to `-2^31`), so each level starts from `-inf`.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def largestValues(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []
        res = []
        queue = deque([root])
        while queue:
            best = -inf
            for _ in range(len(queue)):
                node = queue.popleft()
                best = max(best, node.val)
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            res.append(best)
        return res
```

## Complexity

Time `O(n)`, space `O(w)`.

## Mistakes to Avoid

- Starting each level's maximum at 0 is wrong when a whole level is negative.
- Return `[]` for an empty tree.

## Interview Explanation

I go level by level with BFS and take the maximum of each level starting from `-inf`, since values can be negative. Time `O(n)`, space is the widest level. A DFS with depth works too: `res[depth] = max(res[depth], val)`.
