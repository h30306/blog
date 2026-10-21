---
title: "LeetCode 237: Delete Node in a Linked List"
summary: "LeetCode 237 note: without the previous node, copy the next node's value over and delete the next node instead"
description: "LeetCode 237 record from 2022-08-22"
date: 2022-08-22
tags: ["medium", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-08-22
- Submissions: Accepted (first try)

## Approach

Only the node to delete is given, not its predecessor, so nothing can skip over it. Instead **copy the next node's value into this one and delete the next node** ([Linked List]({{< relref "/algorithm/Linked-List" >}}), Others). The node is guaranteed not to be the tail, so the next node exists.

## My Solution

```python
class Solution:
    def deleteNode(self, node):
        node.val = node.next.val
        node.next = node.next.next
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- This trick only works when the node is not the tail.

## Interview Explanation

Without the predecessor the node cannot truly remove itself, so I copy the next node's value and skip the next node, which has the same effect. Time `O(1)`.
