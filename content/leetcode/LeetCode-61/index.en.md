---
title: "LeetCode 61: Rotate List"
summary: "LeetCode 61 note: count the length and close a ring, take k %= n, walk n - k - 1 steps from the head to the new tail, and break there"
description: "LeetCode 61 record from 2022-10-22"
date: 2022-10-22
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
First Attempt: 2022-10-22
- Submissions: Accepted ×2

## Approach

Rotating right by `k` moves the last `k` nodes to the front. `k` may exceed the length, so take `k %= n` first ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 4).

Connect the tail back to the head into a ring; walking `n - k - 1` steps from the head reaches the new tail, whose next is the new head. Break there.

## My Solution

```python
class Solution:
    def rotateRight(self, head: Optional[ListNode], k: int) -> Optional[ListNode]:
        if not head:
            return None
        n, tail = 1, head
        while tail.next:
            n, tail = n + 1, tail.next
        k %= n
        if k == 0:
            return head
        tail.next = head                             # 接成環
        new_tail = head
        for _ in range(n - k - 1):
            new_tail = new_tail.next
        new_head, new_tail.next = new_tail.next, None
        return new_head
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Reduce `k` modulo the length first, or it loops around many times.
- Return directly for an empty list or `k % n == 0`.

## Interview Explanation

I count the length and find the tail, reduce `k` modulo the length, close the ring, then walk `n - k - 1` steps to the new tail and break it. Time `O(n)`.
