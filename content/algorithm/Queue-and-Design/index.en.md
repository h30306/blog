---
title: "Queue and Design Problems"
summary: "Circular queues, zigzag iterators, FIFO matching with cancellation, and the data structure combinations that design problems keep using"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["queue", "design", "iterator", "lazy-deletion"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Design problems ask you to implement a class whose methods have time complexity requirements. The key is to **list what each operation needs first, then pick a combination of data structures that satisfies all of them**.

| Need | Data structure |
|---|---|
| First in, first out | `deque` |
| Membership, cancellation | `set` / `dict` |
| Maximum / minimum at any time | heap |
| Deleting or updating in the middle | lazy deletion, or a dict of current valid values |
| Fixed capacity with reused space | circular array |

## Template 1: Circular Queue

Use a fixed-size array plus `head` (position of the first element) and `count` (number of elements), with positions taken modulo the capacity:

```python
class CircularQueue:
    def __init__(self, k):
        self.buf = [0] * k
        self.head = self.count = 0

    def push(self, x):
        if self.count == len(self.buf):
            return False
        self.buf[(self.head + self.count) % len(self.buf)] = x
        self.count += 1
        return True

    def pop(self):
        if self.count == 0:
            return False
        self.head = (self.head + 1) % len(self.buf)
        self.count -= 1
        return True
```

### Key Parameters:

- Use `head + count` rather than two pointers `head + tail`: it avoids the ambiguity of both pointers coinciding when the queue is empty and when it is full.
- The last element is at `(head + count - 1) % k` (LC 622).

## Template 2: Interleaving Several Sources

Keep each source in a queue, take from whoever's turn it is, and put it back at the end if anything remains:

```python
from collections import deque

q = deque(iter(v) for v in sources if v)     # one iterator per source
def next_value():
    it = q.popleft()
    x = next(it)
    ...                                       # q.append(it) if it has more
```

LC 281 is the two-source version. A queue of "sources not yet exhausted" generalizes directly to `k` sources.

## Template 3: FIFO Matching with Cancellation

Keep a queue per side and match the earliest of each. A cancellation does not delete from the middle of the queue; it is recorded in a `canceled` set, and **canceled entries at the front are dropped right before matching** (lazy deletion):

```python
while riders and riders[0] in canceled:
    canceled.discard(riders.popleft())
```

Use a set to check whether someone is still waiting; `in` on a deque is `O(n)` (LC 3829).

## Template 4: A queue from stacks, a stack from a queue

- **Two stacks as a queue** (LC 232): push into `inbox`; refill `outbox` from `inbox` only when `outbox` is empty, amortized `O(1)`.
- **One queue as a stack** (LC 225): after `push(x)`, rotate the earlier `n - 1` elements to the back so `x` is at the front.

## Design Problems Already Covered

| Problem | Data structure combination | Post |
|---|---|---|
| LC 716 Max Stack | stack + heap + lazy deletion with unique ids | Stack |
| LC 3815, 3885 | dict + heap lazy deletion | Heap |
| LC 2102 | two heaps | Heap |
| LC 3508 Implement Router | deque + set + sorted time list per destination | Binary Search |
| LC 3709 | prefix sums + bisect | Binary Search |

## Common Mistakes

- Using `in` on a deque or list for membership: `O(n)`.
- Computing the last position of a circular array without subtracting 1 before the modulo.
- Giving an iterator's `hasNext` side effects: it can work, but repeated calls must return the same answer.
- **Using a list directly as the stack, or `pop(0)` as the queue**: it passes, but it is not the requested implementation, and `pop(0)` is `O(n)` (LC 225, 232).

## Related LeetCode

- `LC 622` Design Circular Queue
- `LC 281` Zigzag Iterator
- `LC 3829` Design Ride Sharing System
- `LC 1290` Convert Binary Number in a Linked List to Integer
- `LC 225` Implement Stack using Queues
- `LC 232` Implement Queue using Stacks
- `LC 387` First Unique Character in a String
