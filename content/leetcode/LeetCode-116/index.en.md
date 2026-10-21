---
title: "LeetCode 116: Populating Next Right Pointers in Each Node"
summary: "LeetCode 116 note: in a perfect binary tree, walk each level through the next pointers already set on the level above: left.next = right and right.next = next.left, with O(1) extra space"
description: "LeetCode 116 record from 2022-11-18"
date: 2022-11-18
tags: ["medium", "linked-list", "tree", "depth-first-search", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-18
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error → Accepted ×2

## Approach

Every non-leaf in a perfect binary tree has two children, so the next level has only two kinds of links ([Linked List]({{< relref "/algorithm/Linked-List" >}}), Others; [Tree]({{< relref "/algorithm/Tree" >}}) Template 2):

- Children of the same parent: `node.left.next = node.right`.
- Across neighboring parents: `node.right.next = node.next.left`.

With the level above already linked through `next`, walk across it without a queue, starting from the leftmost node on each level.

## My Attempts

The early versions were recursive but **did not return `root`**, so a single node `[8]` returned `None`; one did not handle an empty tree. My accepted version was recursive (`O(log n)` depth); here it is the iterative walk along `next`.

## Solution

```python
class Solution:
    def connect(self, root: 'Optional[Node]') -> 'Optional[Node]':
        leftmost = root
        while leftmost and leftmost.left:
            node = leftmost
            while node:                              # 沿著上一層的 next 走
                node.left.next = node.right
                if node.next:
                    node.right.next = node.next.left
                node = node.next
            leftmost = leftmost.left
        return root
```

## Complexity

Time `O(n)`, extra space `O(1)`.

## Mistakes to Avoid

- The function must return `root`.
- This relies on a perfect tree; an imperfect one (LC 117) must handle missing children.

## Interview Explanation

In a perfect tree the next level has only two link types: siblings under one parent, and a right child to the neighboring parent's left child. I walk each level along the `next` pointers set on the level above, with no queue. Time `O(n)`, extra space `O(1)`.
