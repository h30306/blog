---
title: "LeetCode 148: Sort List"
summary: "LeetCode 148 note: split in half with fast and slow pointers, sort each half recursively and merge; O(n log n) with no extra array"
description: "LeetCode 148 record from 2022-11-17"
date: 2022-11-17
tags: ["medium", "linked-list", "two-pointers", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-11-17
- Submissions: Accepted → Time Limit Exceeded ×3 → Accepted ×2

## Approach

Lists have no random access, so merge sort fits best ([Merge Sort]({{< relref "/algorithm/Merge-Sort" >}}) Template 3):

1. Find the middle with fast and slow pointers and cut there ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3). Fast starts at `head.next` so two nodes split into one and one.
2. Sort both halves recursively.
3. Merge the two sorted lists with a dummy.

## My Attempts

My first accepted version in 2022 was insertion sort (`O(n²)`, which happened to pass); later versions swapping values pairwise were also `O(n²)` and hit TLE three times. Rewriting it as merge sort in 2026 gave the right complexity.

## Solution

```python
class Solution:
    def sortList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head or not head.next:
            return head
        slow, fast = head, head.next
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        mid, slow.next = slow.next, None
        left, right = self.sortList(head), self.sortList(mid)
        tail = dummy = ListNode()
        while left and right:
            if left.val <= right.val:
                tail.next, left = left, left.next
            else:
                tail.next, right = right, right.next
            tail = tail.next
        tail.next = left or right
        return dummy.next
```

## Complexity

Time `O(n log n)`, space `O(log n)` (recursion depth).

## Mistakes to Avoid

- Start fast at `head.next`, or two nodes never split and the recursion never ends.
- Set `slow.next` to `None` when cutting.

## Interview Explanation

Lists suit merge sort: I cut at the middle found with fast and slow pointers, sort both halves recursively, and merge them with a dummy. Time `O(n log n)`, with only `O(log n)` recursion space.
