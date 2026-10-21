---
title: "LeetCode 2487: Remove Nodes From Linked List"
summary: "LeetCode 2487 note: the kept nodes are non-increasing left to right; keep a monotonic stack, pop anything smaller than the new node, then link what remains"
description: "LeetCode 2487 record from 2024-05-06"
date: 2024-05-06
tags: ["medium", "linked-list", "stack", "recursion", "monotonic-stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-05-06
- Submissions: Accepted ×3

## Approach

A node stays when nothing to its right is larger. Scan left to right with a stack ([Stack]({{< relref "/algorithm/Stack" >}}), monotonic stack): when a node arrives, every smaller node on top now has something larger to its right, so pop them. The stack ends non-increasing bottom to top; link it in order ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 2 mentions the alternative of reversing first).

## My Solution

```python
class Solution:
    def removeNodes(self, head: Optional[ListNode]) -> Optional[ListNode]:
        stack = []
        while head:
            while stack and stack[-1].val < head.val:
                stack.pop()
            stack.append(head)
            head = head.next
        for a, b in zip(stack, stack[1:]):
            a.next = b
        stack[-1].next = None
        return stack[0]
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Pop only **strictly smaller** nodes; equal ones stay.
- Set the last node's `next` to `None`.

## Interview Explanation

Kept nodes have nothing larger to their right, so I keep a monotonic stack that pops smaller nodes when a new one arrives, then link the remaining nodes in order. Time `O(n)`.
