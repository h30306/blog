---
title: "LeetCode 141: Linked List Cycle"
summary: "LeetCode 141 note: Floyd's cycle detection, fast two steps and slow one; with a cycle they must meet, each advancing from its own position"
description: "LeetCode 141 record from 2022-08-20"
date: 2022-08-20
tags: ["easy", "hash-table", "linked-list", "two-pointers", "floyds-cycle-finding-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-20
- Submissions: Time Limit Exceeded ×3 → Wrong Answer → Accepted → Runtime Error ×3 → Wrong Answer → Runtime Error → Wrong Answer → Runtime Error ×2 → Accepted ×2 → Runtime Error ×3 → Accepted

## Approach

With a cycle, once both are inside it the fast pointer closes the gap by one each step and must catch up; without one, fast reaches `None` first ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3).

## My Attempts

This took 19 submissions in 2022:

- **TLE**: I wrote `slow = head.next` and `fast = head.next.next`, **recomputing from `head` every time**, so both pointers stayed put; a cycle on `[3, 3]` never finished.
- **RE**: reading `None.next` on empty or acyclic lists, e.g. `[]` and `[3, 3, 5]`.
- Using `while fast and fast.next` and advancing each pointer from its own position passed.

## Solution

```python
class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
            if slow is fast:
                return True
        return False
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Each step uses `slow.next` and `fast.next.next`, not recomputed from `head`.
- Empty and single-node lists are stopped by the `while` condition.

## Interview Explanation

Fast moves two steps and slow one; with a cycle fast must catch slow inside it, and fast reaching `None` means no cycle. Time `O(n)`, space `O(1)`.
