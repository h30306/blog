---
title: "LeetCode 160: Intersection of Two Linked Lists"
summary: "LeetCode 160 note: each pointer walks its own list then the other's; both cover lenA + lenB steps and reach the intersection, or None, together"
description: "LeetCode 160 record from 2022-08-20"
date: 2022-08-20
tags: ["easy", "hash-table", "linked-list", "two-pointers"]
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
- Submissions: Runtime Error ×2 → Wrong Answer → Time Limit Exceeded → Runtime Error ×7 → Accepted ×2 → Wrong Answer ×2 → Accepted ×2 → Runtime Error → Time Limit Exceeded → Accepted ×2

## Approach

After the intersection the lists share nodes. Pointer `a` walks A then B, and `b` walks B then A ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 6). Both cover `lenA + lenB` steps, so they meet at the intersection; with none they reach `None` together and the loop ends.

## My Attempts

This took 21 submissions in 2022:

- I first stored A's nodes in a hash table; attempt 1 called `append` on a dict (RE); after switching to a set, the loop over B forgot to advance `B` (TLE), and it returned `True` / `False` instead of a node.
- After switching to head swapping, one version wrote `B = B.next if B else B`: when B finished it switched to itself (`None`) and never walked A, so with A `[1, 3]` and B `[3]` (sharing `[3]`) it returned `None`.

## Solution

```python
class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        a, b = headA, headB
        while a is not b:
            a = a.next if a else headB
            b = b.next if b else headA
        return a
```

## Complexity

Time `O(m + n)`, space `O(1)`.

## Mistakes to Avoid

- Compare the nodes themselves (`is`), not values.
- After finishing your own list, switch to **the other list's head**, not your own.

## Interview Explanation

Each pointer walks its own list and then switches to the other's head; both walk `lenA + lenB` steps, so they arrive at the intersection together, or both become `None`. Time `O(m + n)`, space `O(1)`.
