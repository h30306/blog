---
title: "LeetCode 24: Swap Nodes in Pairs"
summary: "LeetCode 24 note: a dummy plus pairs, rewiring prev.next, a.next and b.next together; swap nodes, not values"
description: "LeetCode 24 record from 2022-10-21"
date: 2022-10-21
tags: ["medium", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-21
- Submissions: Time Limit Exceeded → Wrong Answer ×3 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted ×2 → Runtime Error ×3 → Accepted ×2

## Approach

Each step handles the two nodes after `prev`, `a` and `b` ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 5):

- `prev.next` becomes `b`
- `a.next` becomes `b`'s old next
- `b.next` becomes `a`

Then `prev` moves to `a` (now second in the pair). A dummy handles the head being swapped in the first pair.

## My Attempts

This took 15 submissions in 2022:

- **TLE / WA**: I first tried swapping in one line with `node.val, node.next, node.next.next = ...`, but targets are assigned left to right, so after `node.next` changed, `node.next.next` pointed at the wrong node, creating loops or dropping nodes; attempt 1 also never advanced `node` (TLE), and attempt 2 returned the final `node` (`None`) instead of the head, so `[4]` returned an empty list and `[2, 2]` kept only one node.
- **RE**: reading `head.next` on an empty list.
- Switching to a dummy with separate `a` and `b` variables passed.

## Solution

```python
class Solution:
    def swapPairs(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        prev = dummy
        while prev.next and prev.next.next:
            a, b = prev.next, prev.next.next
            prev.next, a.next, b.next = b, b.next, a
            prev = a
        return dummy.next
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Python's multiple assignment evaluates the whole right side first, so `b.next` is the old value; but targets are assigned **left to right**, so in `node.next, node.next.next = ...` the second target uses the already-updated `node.next`.

## Interview Explanation

With a dummy, each step takes the next two nodes: the previous pair's tail points at `b`, `a` points at `b`'s old next, `b` points at `a`, then move on two. Time `O(n)`.
