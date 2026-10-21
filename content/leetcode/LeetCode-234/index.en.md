---
title: "LeetCode 234: Palindrome Linked List"
summary: "LeetCode 234 note: find the middle with fast and slow pointers, reverse the second half, and compare from both ends with O(1) extra space"
description: "LeetCode 234 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "linked-list", "two-pointers", "stack", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-22
- Submissions: Runtime Error → Time Limit Exceeded → Accepted ×2

## Approach

A list cannot be walked backward, so **reverse the second half** ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Templates 2 and 3):

1. Find the middle with fast and slow pointers.
2. Reverse from the middle on.
3. Compare from the head and from the reversed half's head together until the second half ends (with an odd length the middle needs no comparison).

## My Attempts

Attempt 1 had a syntax error; attempt 2's loop pointer never advanced, so `[1]` looped forever (TLE). My accepted version copied the values into a list; here it is the `O(1)`-space approach.

## Solution

```python
class Solution:
    def isPalindrome(self, head: Optional[ListNode]) -> bool:
        slow = fast = head
        while fast and fast.next:
            slow, fast = slow.next, fast.next.next
        prev = None
        while slow:                                  # 反轉後半段
            slow.next, prev, slow = prev, slow, slow.next
        while prev:
            if prev.val != head.val:
                return False
            prev, head = prev.next, head.next
        return True
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Compare only until the second half ends; the first half's tail still points at the middle node.
- This modifies the list; if that is not allowed, copy the values into an array (`O(n)` space).

## Interview Explanation

I find the middle with fast and slow pointers, reverse the second half, and compare from the head and the reversed head together; all equal means a palindrome. Time `O(n)`, extra space `O(1)`.
