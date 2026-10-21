---
title: "LeetCode 2: Add Two Numbers"
summary: "LeetCode 2 note: digits are stored in reverse, so add from the head digit by digit with a carry, looping until both lists end and no carry remains"
description: "LeetCode 2 record from 2022-02-19"
date: 2022-02-19
tags: ["medium", "linked-list", "math", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-02-19
- Submissions: Runtime Error ×14 → Wrong Answer → Accepted → Runtime Error ×3 → Wrong Answer ×3 → Accepted ×2

## Approach

The ones digit is at the head, so addition starts from the head ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 1). A dummy collects the result; each digit is `(a + b + carry) % 10` and the new carry is `// 10`. Looping on `l1 or l2 or carry` handles both unequal lengths and a final carry at once.

## My Attempts

This was from my first LeetCode attempts in February 2022, 24 submissions:

- The first dozen REs came from not knowing `ListNode`: calling `''.join` on a list node, converting to strings and reversing, or reading `.val` on `None`.
- Once I could use the list, one version moved the dummy itself as the tail, so `return res.next` was no longer the head and returned nothing.
- One version dropped the final carry: `[6] + [7]` should be `[3, 1]`; it returned `[3]`.

## Solution

```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:
        tail = dummy = ListNode()
        carry = 0
        while l1 or l2 or carry:
            s = carry + (l1.val if l1 else 0) + (l2.val if l2 else 0)
            carry, digit = divmod(s, 10)
            tail.next = tail = ListNode(digit)
            l1 = l1.next if l1 else None
            l2 = l2.next if l2 else None
        return dummy.next
```

## Complexity

Time `O(max(m, n))`, space `O(1)` besides the output.

## Mistakes to Avoid

- A final carry becomes a node too.
- Keep the tail pointer separate from the dummy, or the head is lost.

## Interview Explanation

With reversed digits I add from the head with a carry, building the result after a dummy. The loop runs until both lists end and no carry remains, so unequal lengths and a final carry need no extra code. Time `O(max(m, n))`.
