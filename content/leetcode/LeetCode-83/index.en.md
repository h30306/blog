---
title: "LeetCode 83: Remove Duplicates from Sorted List"
summary: "LeetCode 83 note: sorted, so duplicates are adjacent; skip cur.next while it equals cur, and advance only otherwise"
description: "LeetCode 83 record from 2022-07-20"
date: 2022-07-20
tags: ["easy", "linked-list"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-07-20
- Submissions: Runtime Error ×2 → Time Limit Exceeded ×2 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted → Runtime Error ×2 → Accepted ×4 → Runtime Error → Accepted ×2

## Approach

In a sorted list duplicates are adjacent. When `cur.next` equals `cur`, skip it and **keep `cur`** (the next may match too); advance only otherwise ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1). The head always stays, so no dummy is needed.

## My Attempts

This was one of my first problems in July 2022, and most of the 18 submissions came from not being used to `ListNode` yet:

- At first I used `self.val`, compared a value with a node (`head.val != head.next`), and returned a list instead of a node: RE and TLE.
- Later, an empty list returned `ListNode(None)` or `ListNode(0)`, adding a node (WA), or `cur.next` went unchecked and `[3, 3]` raised.

## Solution

```python
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:
        cur = head
        while cur and cur.next:
            if cur.val == cur.next.val:
                cur.next = cur.next.next
            else:
                cur = cur.next
        return head
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- An empty list returns `None`, not `ListNode(None)` or `ListNode(0)`.
- Compare `cur.val` with `cur.next.val`, not a value with a node.

## Interview Explanation

The list is sorted, so duplicates sit next to each other: skip `cur.next` when it matches `cur`, advance otherwise. Time `O(n)`, space `O(1)`.
