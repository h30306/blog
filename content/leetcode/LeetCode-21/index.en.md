---
title: "LeetCode 21: Merge Two Sorted Lists"
summary: "LeetCode 21 note: the dummy node, and why Python assignment is not a copy"
description: "LeetCode 21 record from the 2026-10-18 merge sort practice ladder"
date: 2026-10-18
tags: ["easy", "linked-list", "two-pointers", "merge-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-10-18
Source: merge sort practice ladder, prerequisite for LC 148 and LC 23

## Approach

Same as the array merge: each step attaches the smaller of the two list heads to the result. On a linked list, only the `next` pointers change, so no buffer is needed.

A dummy node as the head of the result removes the special case of choosing the first node.

## My First Attempt

```python
dummy = tail = ListNode()

while list1 or list2:
    if not list1 or (list2 and list2.val < list1.val):
        tail.next = list2
        list2 = list2.next
    else:
        tail.next = list1
        list1 = list1.next
    tail = tail.next

return dummy.next
```

The output is correct and the checks are in the right order: `not list1` is checked before reading `.val`. One improvement: once one list is empty, the rest of the other list is already sorted and can be attached in one step.

## The Question I Had: isn't `dummy = tail = ListNode()` a deep copy?

No. **No copy of any kind happens.** This line creates one node and makes both `dummy` and `tail` point to it.

The key is telling two operations apart:

| Operation | Example | Affects other names pointing to the same object? |
|---|---|---|
| Mutate the object | `tail.next = x`, `lst.append(x)`, `a[i] = x` | yes |
| Rebind the name | `tail = tail.next`, `x = ...` | no |

On the first `tail.next = list1`, `tail` and `dummy` point to the same node, so `dummy.next` is set too. After that, `tail = tail.next` only moves `tail`; `dummy` stays at the head.

`a = b = 1` also points both names at one object. Ints are immutable, so there is no way to mutate them, and the sharing is never visible.

The version that bites most often in practice is building a DP table:

```python
dp = [[0] * 3] * 2                 # both rows are the same list
dp = [[0] * 3 for _ in range(2)]   # each row is a new list
```

## Solution

```python
class Solution:
    def mergeTwoLists(self, list1: ListNode | None, list2: ListNode | None) -> ListNode | None:
        dummy = tail = ListNode()
        while list1 and list2:
            if list2.val < list1.val:
                tail.next = list2
                list2 = list2.next
            else:
                tail.next = list1
                list1 = list1.next
            tail = tail.next
        tail.next = list1 or list2
        return dummy.next
```

## Complexity

Time `O(m + n)`, space `O(1)`. Only pointers change; no new nodes are created.

## Mistakes to Avoid

- Reading `.val` before checking that the node exists.
- Assuming `dummy = tail = ...` creates two nodes.

## Interview Explanation

I use a dummy node as the head of the result and `tail` as its end. Each step compares the two list heads, attaches the smaller one to `tail`, and moves forward. When one list runs out, the rest of the other is already sorted, so I attach it directly. Time is `O(m + n)`, and since I only rewire pointers, extra space is `O(1)`.
