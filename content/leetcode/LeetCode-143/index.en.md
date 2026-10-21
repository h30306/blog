---
title: "LeetCode 143: Reorder List"
summary: "LeetCode 143 note: find the middle, reverse the second half, and merge the two alternately, cutting the first half's tail"
description: "LeetCode 143 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "linked-list", "two-pointers", "stack", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Runtime Error ×3 → Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted → Time Limit Exceeded → Accepted ×3

## Approach

Head, tail, second, second-to-last, ... is the first half merged alternately with the reversed second half ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Templates 2 and 3):

1. Find the middle with fast and slow pointers and cut after it.
2. Reverse the second half.
3. Merge alternately; the first half is at least as long as the second.

## My Attempts

This took 14 submissions in 2022. It combines three operations, which I split into three functions, but small errors kept appearing:

- Finding the middle with `while fast and fast.next.next` raised when `fast.next` was `None` for a single node, e.g. `[8]`.
- After reversing it returned `prev.next` instead of `prev`, dropping a node.
- One version never cut the first half, so merging linked back into the second half and formed a cycle; `[9, 1]` never finished.

## Solution

```python
class Solution:
    def reorderList(self, head: Optional[ListNode]) -> None:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        second, slow.next = slow.next, None          # 切斷前半段
        prev = None
        while second:                                # 反轉後半段
            second.next, prev, second = prev, second, second.next
        first, second = head, prev
        while second:                                # 交錯合併
            n1, n2 = first.next, second.next
            first.next, second.next = second, n1
            first, second = n1, n2
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Always cut the first half, or merging links back into the second half and forms a cycle.
- Modify in place; there is no return value.

## Interview Explanation

I split at the middle with fast and slow pointers, reverse the second half, and interleave the two in place. Time `O(n)`, space `O(1)`.
