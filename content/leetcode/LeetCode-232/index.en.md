---
title: "LeetCode 232: Implement Queue using Stacks"
summary: "LeetCode 232 note: two stacks, where in receives pushes and out is refilled from in only when empty, amortized O(1)"
description: "LeetCode 232 record from 2022-08-22"
date: 2022-08-22
tags: ["easy", "stack", "design", "queue"]
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
- Submissions: Accepted (first try)

## Approach

`inbox` takes pushes and `outbox` serves `pop` and `peek` ([Queue and Design]({{< relref "/algorithm/Queue-and-Design" >}})). When `outbox` is empty, pop everything from `inbox` into it, reversing the order so the oldest element is on top. Each element moves once, so operations are amortized `O(1)`. **Never refill a non-empty `outbox`**, or the order breaks.

## My Attempts

Passed on the first try, but using a list with `pop(0)` as the queue, **not the two stacks the problem asks for**, and `pop(0)` is `O(n)`.

## Solution

```python
class MyQueue:
    def __init__(self):
        self.inbox, self.outbox = [], []

    def push(self, x: int) -> None:
        self.inbox.append(x)

    def _move(self):
        if not self.outbox:
            while self.inbox:
                self.outbox.append(self.inbox.pop())

    def pop(self) -> int:
        self._move()
        return self.outbox.pop()

    def peek(self) -> int:
        self._move()
        return self.outbox[-1]

    def empty(self) -> bool:
        return not self.inbox and not self.outbox
```

## Complexity

Amortized `O(1)`, space `O(n)`.

## Mistakes to Avoid

- Refill only when `outbox` is empty.
- `empty` requires both stacks to be empty.

## Interview Explanation

With two stacks, pushes go to the first and pops and peeks come from the second, which is refilled from the first only when empty, reversing the order into FIFO. Each element moves at most once, so operations are amortized `O(1)`.
