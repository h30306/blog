---
title: "LeetCode 92: Reverse Linked List II"
summary: "LeetCode 92 note: walk a dummy to the node before left, then move the following nodes one at a time to just after it, right - left times"
description: "LeetCode 92 record from 2022-11-26"
date: 2022-11-26
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
First Attempt: 2022-11-26
- Submissions: Accepted ×2 → Wrong Answer → Accepted

## Approach

Walk a dummy to node `left - 1`, `pre` (the dummy itself when `left = 1`). `cur = pre.next` starts the range and ends up as its tail. Then, `right - left` times, take the node after `cur` and insert it right after `pre` ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 2).

## My Attempts

The first two submissions passed. A later rewrite split the list into three parts, reversed the middle and reconnected, but reconnected the range's original first node `middle` (the tail after reversing) instead of the reversed head `prev`. For `[8, 4]`, `left = 1`, `right = 2` the answer is `[4, 8]`; it returned `[8]`.

## Solution

```python
class Solution:
    def reverseBetween(self, head: Optional[ListNode], left: int, right: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        pre = dummy
        for _ in range(left - 1):
            pre = pre.next
        cur = pre.next
        for _ in range(right - left):
            nxt = cur.next                           # 拿出 cur 後面那個
            cur.next = nxt.next
            nxt.next = pre.next                      # 插到 pre 後面
            pre.next = nxt
        return dummy.next
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- With `left = 1` the head changes, so start from a dummy.
- `cur` stays the same node, moving further back each time.

## Interview Explanation

I walk a dummy to the node before `left`, then repeatedly move the next node in the range to its front, `right - left` times, which reverses the range in one pass. Time `O(n)`.
