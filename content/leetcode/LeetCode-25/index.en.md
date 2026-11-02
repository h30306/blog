---
title: "LeetCode 25: Reverse Nodes in k-Group"
summary: "LeetCode 25 note: count the length to know how many full groups to reverse, k nodes each; a dummy head avoids special-casing the first group, and the old group head becomes its tail"
description: "LeetCode 25 record from 2026-11-01"
date: 2026-11-01
tags: ["hard", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-11-01
- Submissions: Accepted (first try)

## Approach

Count the length first; `n // k` is the number of groups to reverse, and a final group shorter than `k` stays as it is.

Use a dummy head ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1), with `curr` pointing at the previous group's tail:

1. Reverse the `k` nodes starting at `curr.next` (Template 2). After reversing, the group's old head becomes its tail.
2. Point `curr.next` at the new head and the new tail at the start of the next group.
3. Move `curr` to this group's new tail and continue.

## My Attempts

Accepted on the first try.

## Solution

```python
class Solution:
    def reverseKGroup(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        n = 0
        node = head
        while node:
            n += 1
            node = node.next

        dummy = ListNode(0, head)
        curr = dummy
        for _ in range(n // k):
            group_head = curr.next
            prev, node = None, group_head
            for _ in range(k):
                nxt = node.next
                node.next = prev
                prev = node
                node = nxt
            curr.next = prev            # new head of this group
            group_head.next = node      # new tail links to the next group
            curr = group_head
        return dummy.next
```

My submission put the reversal in a helper returning `(new head, new tail, next group start)`; same idea.

## Complexity

Time `O(n)`, extra space `O(1)`.

## Mistakes to Avoid

- Do not reverse a final group shorter than `k`. Counting the length first is simplest; probing `k` steps ahead per group also works.
- After reversing, the old head is the tail; keep a reference to it to link the next group.
- With a dummy head, the first group needs no special handling of the new `head`.

## Interview Explanation

I count the length to know how many groups to reverse. With a dummy head and `curr` at the previous group's tail, I reverse the next `k` nodes, link the previous tail to the new head and the group's old head (now its tail) to the next group, then move `curr` to that tail. Time `O(n)`, space `O(1)`.
