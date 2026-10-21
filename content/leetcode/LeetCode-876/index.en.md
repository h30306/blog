---
title: "LeetCode 876: Middle of the Linked List"
summary: "LeetCode 876 note: fast moves two steps and slow one; when fast reaches the end slow is in the middle, the right-middle for even lengths"
description: "LeetCode 876 record from 2022-09-20"
date: 2022-09-20
tags: ["easy", "linked-list", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-20
- Submissions: Runtime Error ×3 → Accepted ×3 → Time Limit Exceeded → Runtime Error → Wrong Answer → Accepted

## Approach

The fast pointer moves twice as fast, so when it finishes, slow is halfway ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3). With `while fast and fast.next`, even lengths take one extra step and `slow` stops at the second of the two middles, as the problem wants.

## My Attempts

My first approach stored the values in a list and indexed the middle, getting the index wrong a few times (`/` gave a float for even lengths, and odd lengths added an extra 1), and it returned a value rather than a node. Rewriting with two pointers later:

- one version never moved `node` inside the loop and read `node.next.next` directly, failing on `[3]`;
- one set `middle = node.next` before stepping two, one step too far, returning `[2]` for `[7, 1, 7, 2]` instead of `[7, 2]`.

## Solution

```python
class Solution:
    def middleNode(self, head: Optional[ListNode]) -> Optional[ListNode]:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        return slow
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Even lengths stop at the second middle; the loop condition decides which.

## Interview Explanation

Fast steps two and slow one; when fast hits the end, slow is in the middle, and `fast and fast.next` stops at the second middle for even lengths. Time `O(n)`.
