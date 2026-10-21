---
title: "LeetCode 82: Remove Duplicates from Sorted List II"
summary: "LeetCode 82 note: every duplicated value goes, the head included, so use a dummy; on a duplicate skip to the next different value and link prev.next past it"
description: "LeetCode 82 record from 2022-10-26"
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
- Submissions: Wrong Answer → Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Wrong Answer → Accepted → Runtime Error ×2 → Accepted ×3

## Approach

Unlike LC 83, duplicated values keep **no copy**, and the head may go, so use a dummy ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1):

- `prev` is the last node known to stay.
- `cur = prev.next`. If `cur` matches the next node, skip every node with that value and point `prev.next` at the first different node (keep `prev`; that node still needs checking).
- Otherwise advance `prev`.

## My Attempts

This took 16 submissions in 2022:

- The first versions had no dummy and no empty-list handling, reading `None.next` on `[]`; one did not even return anything.
- After adding a dummy, one version returned `prev.next`, but `prev` had already moved on, so it was not the head: `[1, 2]` returned `[2]` instead of `[1, 2]`.
- One inner `while` did not check `cur.next` and failed on `[1, 1]`.

## Solution

```python
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = prev = ListNode(0, head)
        while prev.next:
            cur = prev.next
            if cur.next and cur.val == cur.next.val:
                while cur.next and cur.val == cur.next.val:
                    cur = cur.next
                prev.next = cur.next                 # 整段重複的都跳過
            else:
                prev = prev.next
        return dummy.next
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Do not advance `prev` after skipping; the new `prev.next` may be duplicated too.
- Return `dummy.next`, not `prev.next`.

## Interview Explanation

Every duplicate goes, possibly the head, so I use a dummy with `prev` as the last kept node. On a duplicate I skip to the next different value and link `prev.next` past the run; otherwise `prev` advances. Time `O(n)`.
