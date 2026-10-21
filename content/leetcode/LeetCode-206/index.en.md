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

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Save `cur.next` before changing it.
- An empty list needs no special case: the loop is skipped and `None` is returned.

## Interview Explanation

With `prev` and `cur`, each step saves the next node, points `cur.next` at `prev`, and moves both forward. `prev` ends as the new head. Time `O(n)`, space `O(1)`.
