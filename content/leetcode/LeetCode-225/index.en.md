---
title: "LeetCode 225: Implement Stack using Queues"
summary: "LeetCode 225 note: one queue suffices: after a push, rotate all earlier elements to the back so the new element sits at the front"
description: "LeetCode 225 record from 2022-08-21"
date: 2022-08-21
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
First Attempt: 2022-08-21
- Submissions: Runtime Error → Wrong Answer ×2 → Accepted

## Approach

Only queue operations are allowed (append at the back, remove from the front). After `push(x)`, move the `n - 1` elements ahead of `x` from the front to the back, leaving `x` at the front ([Queue and Design]({{< relref "/algorithm/Queue-and-Design" >}})). Then `pop` and `top` read the front in `O(1)`, and `push` costs `O(n)`.

## My Attempts

I used a Python list as the stack outright, **without implementing it on queues as asked**. The two WAs in between returned `self.l[0]` (the first element pushed) from `top` instead of `self.l[-1]`.

## Solution

```python
class MyStack:
    def __init__(self):
        self.q = deque()

    def push(self, x: int) -> None:
        self.q.append(x)
        for _ in range(len(self.q) - 1):
            self.q.append(self.q.popleft())

    def pop(self) -> int:
        return self.q.popleft()

    def top(self) -> int:
        return self.q[0]

    def empty(self) -> bool:
        return not self.q
```

## Complexity

`push` is `O(n)`, the rest `O(1)`; space `O(n)`.

## Mistakes to Avoid

- The problem asks for queue operations only; using a list as a stack passes but misses the point.
- The stack top is the last element pushed, not the first.

## Interview Explanation

With queue operations only, after each push I rotate the earlier elements to the back so the new element is at the front, making pop and top read the front. Push is `O(n)`, the rest `O(1)`.
