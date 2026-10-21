---
title: "LeetCode 100: Same Tree"
summary: "LeetCode 100 note: two empty trees are equal, one empty and one not differ, and otherwise compare values and recurse on both sides"
description: "LeetCode 100 record from 2022-08-02"
date: 2022-08-02
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
First Attempt: 2022-08-02
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Runtime Error → Accepted → Wrong Answer → Runtime Error → Wrong Answer → Accepted ×4

## Approach

Three cases ([Tree]({{< relref "/algorithm/Tree" >}}) Template 1):

- Both empty: equal.
- Exactly one empty: different.
- Both present: equal values and equal left and right subtrees.

## My Attempts

The failing versions all mishandled empty trees: returning nothing (`None`) or `False` for two empty trees, or `True` when only one was empty, e.g. `[1]` and `[]`.

## Solution

```python
class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        if not p or not q:
            return p is q                           # 兩個都是 None 才相同
        return p.val == q.val and self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

## Complexity

Time `O(min(m, n))`, space `O(h)`.

## Mistakes to Avoid

- Two empty trees return `True`; do not leave that path without a return.
- One empty and one not is `False`.

## Interview Explanation

I handle empty trees first: equal only if both are empty. Otherwise I compare the values and recurse on both subtrees. Time `O(n)`.
