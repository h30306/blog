---
title: "LeetCode 109: Convert Sorted List to Binary Search Tree"
summary: "LeetCode 109 note: take the middle found with fast and slow pointers as the root and recurse on both halves; the height balances naturally"
description: "LeetCode 109 record from 2022-11-19"
date: 2022-11-19
tags: ["medium", "linked-list", "divide-and-conquer", "tree", "binary-search-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-19
- Submissions: Wrong Answer ×2 → Runtime Error ×3 → Accepted ×4

## Approach

A balanced BST has its root in the middle ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3):

1. Find the middle with fast and slow pointers, remembering the node before it to cut off the left half.
2. The middle becomes the root; recurse on the left and right halves.

Every level splits at the middle, so the two sides differ by at most one and the height is balanced.

## My Attempts

The first two versions grew the tree outward from the middle with two pointers, padding with `TreeNode(None)` when the sides differed in length, which added nodes whose value was `None`: `[1, 3]` had in-order `[1, 3, None]`. Switching to recursive halving passed.

## Solution

```python
class Solution:
    def sortedListToBST(self, head: Optional[ListNode]) -> Optional[TreeNode]:
        if not head:
            return None
        if not head.next:
            return TreeNode(head.val)
        prev, slow, fast = None, head, head
        while fast and fast.next:
            prev, slow, fast = slow, slow.next, fast.next.next
        prev.next = None                           # 切斷左半邊
        return TreeNode(slow.val, self.sortedListToBST(head), self.sortedListToBST(slow.next))
```

## Complexity

Time `O(n log n)` (finding middles costs `O(n)` per level), space `O(log n)`. Converting to an array first gives `O(n)` time.

## Mistakes to Avoid

- Keep the node before the middle so the left half can be cut off.
- Return directly for a single node, or the left half cannot be split.

## Interview Explanation

I use fast and slow pointers to find the middle as the root, cut the left half off before it, and recurse on both halves. Always splitting in the middle keeps the height balanced. Time `O(n log n)`.
