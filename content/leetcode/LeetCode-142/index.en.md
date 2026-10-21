---
title: "LeetCode 142: Linked List Cycle II"
summary: "LeetCode 142 note: after fast and slow meet, send one back to head and step both one at a time; they meet again at the cycle entry"
description: "LeetCode 142 record from 2022-11-14"
date: 2022-11-14
tags: ["medium", "hash-table", "linked-list", "two-pointers", "floyds-cycle-finding-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-14
- Submissions: Accepted ×2

## Approach

First find the meeting point with fast and slow pointers ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3). Let `a` be head-to-entry, `b` entry-to-meeting point, and `c` the cycle length: slow traveled `a + b` and fast twice that, so the extra `a + b` is a multiple of `c`, giving `a = k·c - b`.

So walking `a` more steps from the meeting point returns to the entry. Send one pointer back to `head` and step both one at a time; they arrive at the entry together.

## My Solution

```python
class Solution:
    def detectCycle(self, head: Optional[ListNode]) -> Optional[ListNode]:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
            if slow is fast:
                slow = head
                while slow is not fast:
                    slow, fast = slow.next, fast.next
                return slow
        return None
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- In the second phase both pointers step one at a time.
- A set of visited nodes also works, but uses `O(n)` space.

## Interview Explanation

Fast and slow pointers find a meeting point; the math shows head-to-entry equals meeting-point-to-entry modulo the cycle length, so one pointer restarts from the head and both step one at a time until they meet at the entry. Time `O(n)`, space `O(1)`.
