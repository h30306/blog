---
title: "LeetCode 203: Remove Linked List Elements"
summary: "LeetCode 203 note: the head may be deleted too, so a dummy head turns every deletion into deleting cur.next; do not advance after deleting"
description: "LeetCode 203 record from 2022-08-21"
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
- Submissions: Time Limit Exceeded → Runtime Error ×2 → Wrong Answer ×2 → Time Limit Exceeded → Wrong Answer → Runtime Error → Time Limit Exceeded ×2 → Accepted ×3

## Approach

The head may equal `val` too, so put a dummy in front ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1). Then look only at `cur.next`: skip it when it must go and **keep `cur` where it is** (the new `cur.next` may need deleting too); advance only otherwise.

## My Attempts

Getting this right in 2022 took 13 submissions, with three kinds of failure:

- **TLE**: attempt 1 moved `cur` only inside the `if`, so it never advanced when nothing was deleted; `[1]`, `val = 3` looped forever.
- **RE / WA**: it checked `cur.val` but deleted `cur.next`. When `cur.next` was `None` that raised; even when it did not, **the head itself could never be deleted**: `[3]`, `val = 3` returned `[3]`. Switching to checking `cur.next.val` then missed the head and the `cur.next is None` case.

Adding a dummy and inspecting only `cur.next` passed.

## Solution

```python
class Solution:
    def removeElements(self, head: Optional[ListNode], val: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        cur = dummy
        while cur.next:
            if cur.next.val == val:
                cur.next = cur.next.next
            else:
                cur = cur.next
        return dummy.next
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The head may be deleted; use a dummy.
- Do not advance `cur` after a deletion.

## Interview Explanation

I add a dummy and only inspect `cur.next`: if it equals `val` I skip it and stay, otherwise I advance. Return `dummy.next`. Time `O(n)`.
