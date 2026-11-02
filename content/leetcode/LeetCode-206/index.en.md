---
title: "LeetCode 206: Reverse Linked List"
summary: "LeetCode 206 note: three pointers prev / cur / nxt; save the next node, then point cur.next back at prev"
description: "LeetCode 206 record from 2022-08-21"
date: 2022-08-21
tags: ["easy", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-21
- Submissions: Runtime Error → Accepted → Wrong Answer → Accepted ×2
- 2026-11-01 rewrite: Accepted → Wrong Answer → Accepted

## Approach

Point each `cur.next` back to the previous node ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 2). Save `cur.next` before overwriting it, or the rest of the list is lost. At the end `prev` is the new head; for an empty list `prev` is `None`, also correct.

## My Attempts

Attempt 1 used an undefined variable (NameError); a later rewrite missed the empty list and read `head.next` on `[]`.

## Solution

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev, cur = None, head
        while cur:
            nxt = cur.next
            cur.next = prev
            prev, cur = cur, nxt
        return prev
```

## 2026-11 Rewrite

On 11-01 I wrote both an iterative and a recursive version:

1. Iterative: accepted on the first try.
2. Recursive: the base case was first written `if not head or head.next`, missing a `not`, so any list of length 2 or more came back unchanged, e.g. `[1,2]` returned `[1,2]`. Changing it to `not head.next` passed.

The recursive version:

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head or not head.next:
            return head
        new_head = self.reverseList(head.next)
        head.next.next = head
        head.next = None
        return new_head
```

After the recursive call, `head.next` is the last node of the reversed rest, so `head.next.next = head` appends `head` behind it, and `head.next = None` cuts the old link. The recursion depth is `O(n)`, so it uses more space than the iterative version.

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Save `cur.next` before changing it.
- An empty list needs no special case: the loop is skipped and `None` is returned.

## Interview Explanation

With `prev` and `cur`, each step saves the next node, points `cur.next` at `prev`, and moves both forward. `prev` ends as the new head. Time `O(n)`, space `O(1)`.
