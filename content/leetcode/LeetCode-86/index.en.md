---
title: "LeetCode 86: Partition List"
summary: "LeetCode 86 note: two dummies collect nodes below x and at least x, then join them, setting the second part's tail to None"
description: "LeetCode 86 record from 2022-10-26"
date: 2022-10-26
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
First Attempt: 2022-10-26
- Submissions: Runtime Error → Wrong Answer → Accepted ×2 → Runtime Error → Wrong Answer → Accepted

## Approach

The relative order must be kept, so scan once, appending nodes below `x` after the first dummy and the rest after the second ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1). Join the first part's tail to the second part's head, and **set the second part's tail to `None`**, or it may still point into the old list and form a cycle.

## My Attempts

Attempt 1 moved the dummy itself as the tail, so the final `l1.next` was not the head: `[1]`, `x = 2` returned nothing. Later rewrites used an undefined variable `target`, and one failed when everything landed in one part (raising on an empty list).

## Solution

```python
class Solution:
    def partition(self, head: Optional[ListNode], x: int) -> Optional[ListNode]:
        small = s = ListNode()
        big = b = ListNode()
        while head:
            if head.val < x:
                s.next = s = head
            else:
                b.next = b = head
            head = head.next
        b.next = None
        s.next = big.next
        return small.next
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Keep the dummies separate from the moving tail pointers.
- Set the second part's tail to `None`.

## Interview Explanation

Two dummies collect nodes below `x` and the rest in order; then I join them and terminate the second. The original order is preserved. Time `O(n)`.
