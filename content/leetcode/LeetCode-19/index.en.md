---
title: "LeetCode 19: Remove Nth Node From End of List"
summary: "LeetCode 19 note: from a dummy, move fast n + 1 steps ahead, then move both to the end; slow stops before the node to delete"
description: "LeetCode 19 record from 2022-10-20"
date: 2022-10-20
tags: ["medium", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-20
- Submissions: Accepted → Runtime Error → Accepted ×2 → Runtime Error ×2 → Wrong Answer ×4 → Accepted → Runtime Error

## Approach

Fast goes first so the two pointers keep a fixed gap; when fast reaches the end, slow is just before the n-th node from the end ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 4). Starting from a **dummy** means deleting the head (`n` equal to the length) needs no special case.

## My Attempts

The first version passed, but later rewrites kept failing when deleting the head: without a dummy I had to special-case "fast reaches the end after `n` steps", and I tried `return []`, `ListNode([])`, `ListNode(None)` and `ListNode(0)`, none of which is an empty list. For `[3]`, `n = 1` the answer is an empty list. A dummy removes the special case.

## Solution

```python
class Solution:
    def removeNthFromEnd(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        fast = slow = dummy
        for _ in range(n + 1):
            fast = fast.next
        while fast:
            fast, slow = fast.next, slow.next
        slow.next = slow.next.next
        return dummy.next
```

## Complexity

Time `O(n)`, space `O(1)`, in one pass.

## Mistakes to Avoid

- When the head is deleted, return `None` (an empty list), not `[]`, `ListNode([])` or `ListNode(0)`.
- Starting from a dummy removes the special case for deleting the head.

## Interview Explanation

From a dummy, fast takes `n + 1` steps first, then both move until fast is `None`; slow is then before the target, which I skip. One pass, time `O(n)`.
