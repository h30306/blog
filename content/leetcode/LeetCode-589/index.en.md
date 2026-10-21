---
title: "LeetCode 589: N-ary Tree Preorder Traversal"
summary: "LeetCode 589 note: n-ary pre-order records the node then each child in order; flatten recursive results with extend, not by appending a list"
description: "LeetCode 589 record from 2022-08-27"
date: 2022-08-27
tags: ["easy", "stack", "tree", "depth-first-search"]
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
- Submissions: Runtime Error → Accepted ×2 → Runtime Error ×2 → Wrong Answer ×4 → Runtime Error ×2 → Accepted → Runtime Error → Wrong Answer → Accepted ×5 → Runtime Error → Accepted ×4

## Approach

Pre-order visits the node, then each child in order ([Tree]({{< relref "/algorithm/Tree" >}})). Iteratively, pop and record, pushing children **in reverse** so the first child comes out first.

## My Attempts

This took 24 submissions, mostly from the wrong shape of recursive results:

- `[root.val] + list(map(self.preorder, root.children))` **inserted each child's list as one element**, giving the nested `[1, [8]]` instead of `[1, 8]`.
- Taking only the first element `[0]` of each child's result dropped deeper nodes: `[8, None, 3, None, 8]` returned `[8, 3]` instead of `[8, 3, 8]`.
- After trying many ways to flatten, a loop with `extend` passed.

## Solution

```python
class Solution:
    def preorder(self, root: 'Node') -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            stack.extend(reversed(node.children))
        return res
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Recursively, flatten the children's results: `[root.val]` followed by each child's list.
- Iteratively, push children onto the stack in reverse.

## Interview Explanation

Pre-order is the node, then each child in order. With a stack I record on pop and push children in reverse so the first child is handled first. Time `O(n)`.
