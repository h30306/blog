---
title: "LeetCode 328: Odd Even Linked List"
summary: "LeetCode 328 note: build one list from odd positions and one from even positions, then append the even list to the odd one; remember to cut the even list's tail"
description: "LeetCode 328 record from 2026-11-01"
date: 2026-11-01
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
First Attempt: 2026-11-01
- Submissions: Accepted (first try)

## Approach

Split by **position** (not by value) into an odd-position list and an even-position list, keeping relative order, then append the even list after the odd list.

## My Attempts

Accepted on the first try. I collected the two lists with two dummy heads and set the even list's tail to `None` at the end ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1):

```python
class Solution:
    def oddEvenList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        odd_dummy, even_dummy = ListNode(), ListNode()
        o, e = odd_dummy, even_dummy
        curr, i = head, 1
        while curr:
            if i % 2:
                o.next = curr
                o = curr
            else:
                e.next = curr
                e = curr
            curr = curr.next
            i += 1
        e.next = None
        o.next = even_dummy.next
        return odd_dummy.next
```

## Solution: no dummy, two pointers leapfrogging

```python
class Solution:
    def oddEvenList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head:
            return None
        odd, even = head, head.next
        even_head = even
        while even and even.next:
            odd.next = even.next
            odd = odd.next
            even.next = odd.next
            even = even.next
        odd.next = even_head
        return head
```

## Complexity

Time `O(n)`, extra space `O(1)`.

## Mistakes to Avoid

- The last even node's `next` may still point at an odd node; not cutting it creates a cycle.
- Split by position, not by node value.

## Interview Explanation

I chain the odd-position and even-position nodes into two lists in their original order, then link the odd list's tail to the even list's head and set the even tail to `None`. Only pointers change, so it is `O(n)` time and `O(1)` space.
