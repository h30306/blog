---
title: "LeetCode 622: Design Circular Queue"
summary: "LeetCode 622 note: a fixed array plus head and count, every position taken modulo the capacity, and count deciding empty versus full"
description: "LeetCode 622 record from 2026-09-14"
date: 2026-09-14
tags: ["medium", "queue", "design", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-09-14
- Submissions: Accepted (first try)

## Approach

A circular queue uses a fixed array of size `k` and reuses space from the start once the end is reached.

Two variables are enough:

- `head`: the position of the first element.
- `count`: the number of elements.

Every other position can be computed:

| Position | Formula |
|---|---|
| Next write position | `(head + count) % k` |
| Last element | `(head + count - 1) % k` |
| New head after a dequeue | `(head + 1) % k` |

Deciding empty and full with `count` avoids the "is `head == tail` empty or full?" ambiguity.

## My Solution

```python
class MyCircularQueue:

    def __init__(self, k: int):
        self.buf = [0] * k
        self.head = 0
        self.count = 0

    def enQueue(self, value: int) -> bool:
        if self.isFull():
            return False
        self.buf[(self.head + self.count) % len(self.buf)] = value
        self.count += 1
        return True

    def deQueue(self) -> bool:
        if self.isEmpty():
            return False
        self.head = (self.head + 1) % len(self.buf)
        self.count -= 1
        return True

    def Front(self) -> int:
        return -1 if self.isEmpty() else self.buf[self.head]

    def Rear(self) -> int:
        return -1 if self.isEmpty() else self.buf[(self.head + self.count - 1) % len(self.buf)]

    def isEmpty(self) -> bool:
        return self.count == 0

    def isFull(self) -> bool:
        return self.count == len(self.buf)
```

## Complexity

Every operation is `O(1)`; space `O(k)`.

## Mistakes to Avoid

- Using `head` and `tail` pointers without a count: they are equal both when empty and when full.
- Forgetting the `- 1` for `Rear`.
- Clearing array values on dequeue: unnecessary, since later writes overwrite them.

## Interview Explanation

I use an array of size `k` with `head`, the position of the first element, and `count`, the number of elements. Enqueue writes at `(head + count) % k`, dequeue advances `head` modulo `k`, and the last element is at `(head + count - 1) % k`. Empty and full are read directly from `count`, so there is no ambiguity when pointers coincide. Every operation is `O(1)`.
