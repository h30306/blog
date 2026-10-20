---
title: "LeetCode 1290: Convert Binary Number in a Linked List to Integer"
summary: "LeetCode 1290 note: walk head to tail, shifting the running value left by one and adding the new bit"
description: "LeetCode 1290 record from 2025-07-14"
date: 2025-07-14
tags: ["easy", "linked-list", "bit-manipulation", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-07-14
- Submissions: Accepted (first try)

## Approach

The linked list holds a binary number from the most significant bit to the least.

## My Solution: store in an array, then compute backwards

```python
values = []
while head:
    values.append(head.val)
    head = head.next
res = 0
for i, bit in enumerate(values[::-1]):
    res += bit * (2 ** i)
```

Correct, but it uses an extra array and a reversal.

## Better: compute while walking

Starting from the most significant bit, **shift the result left by one** (multiply by 2) for each new bit, then add the bit. It is the same idea as decimal `123 = ((1 × 10) + 2) × 10 + 3`:

```python
class Solution:
    def getDecimalValue(self, head: Optional[ListNode]) -> int:
        res = 0
        while head:
            res = (res << 1) | head.val
            head = head.next
        return res
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Accumulating `2 ** i` from the head: the head is the most significant bit, not the least, so you would need the length or a reversal first.

## Interview Explanation

The list starts at the most significant bit, so I compute while walking: for each bit, shift the result left by one and add the bit; at the tail, that is the answer. No array or length is needed, so time is `O(n)` and space `O(1)`.
