---
title: "LeetCode 637: Average of Levels in Binary Tree"
summary: "LeetCode 637 note: level-order traversal, dividing each level's sum by its count"
description: "LeetCode 637 record from 2022-08-29"
date: 2022-08-29
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
First Attempt: 2022-08-29
- Submissions: Runtime Error ×2 → Accepted ×2 → Time Limit Exceeded → Runtime Error → Wrong Answer → Accepted ×5

## Approach

Walk levels with BFS ([Tree]({{< relref "/algorithm/Tree" >}}) Template 2) and divide each level's sum by its node count. Python 3's `/` returns a float, as required.

## My Attempts

The first two versions stored values the wrong way (IndexError, TypeError); later refactors broke it a few more times (one looped forever) before settling on level-by-level BFS.

## Solution

```python
class Solution:
    def averageOfLevels(self, root: Optional[TreeNode]) -> List[float]:
        res, level = [], [root]
        while level:
            res.append(sum(n.val for n in level) / len(level))
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## Complexity

Time `O(n)`, space `O(w)`.

## Mistakes to Avoid

- At least one node is guaranteed, so the empty tree needs no handling; otherwise start from an empty list.

## Interview Explanation

With BFS level by level, each level's sum over its count is the average. Time `O(n)`.
