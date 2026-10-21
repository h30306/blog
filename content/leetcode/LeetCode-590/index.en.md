---
title: "LeetCode 590: N-ary Tree Postorder Traversal"
summary: "LeetCode 590 note: post-order is each child then the node; iteratively, run a root-then-children-right-to-left pre-order and reverse the whole result"
description: "LeetCode 590 record from 2022-08-27"
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
- Submissions: Runtime Error → Accepted ×5

## Approach

Post-order handles each child in order and the node last ([Tree]({{< relref "/algorithm/Tree" >}})). An iterative trick: the order "root, last child, ..., first child" reversed is exactly post-order. So pop and record, push children **in order**, and reverse at the end.

## My Attempts

Attempt 1 used an undefined variable; after that the recursive version passed directly.

## Solution

```python
class Solution:
    def postorder(self, root: 'Node') -> List[int]:
        res, stack = [], [root] if root else []
        while stack:
            node = stack.pop()
            res.append(node.val)
            stack.extend(node.children)
        return res[::-1]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- The reversal trick requires pushing children in their original order.

## Interview Explanation

Post-order reversed is root, then children from last to first, so I traverse in that order with a stack and reverse the result. Time `O(n)`.
