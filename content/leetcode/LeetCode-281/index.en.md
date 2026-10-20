---
title: "LeetCode 281: Zigzag Iterator"
summary: "LeetCode 281 note: a queue of unfinished sources, take one value in turn and put the source back if anything remains; it generalizes to k sources"
description: "LeetCode 281 record from 2026-04-29"
date: 2026-04-29
tags: ["medium", "queue", "design", "iterator"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-04-29
- Submissions: Accepted (first try)

## Approach

Output one element from each array in turn; once one runs out, output the rest of the other.

## My Solution: two deques and a whose-turn flag

```python
def hasNext(self) -> bool:
    if self.next_pop == "v1":
        if self.queue1:
            return True
        elif self.queue2:
            self.next_pop = "v2"
            return True
        return False
    ...
```

`hasNext` also handles "if it is this side's turn but it is empty, switch sides". It passes, but the logic for the two sides is duplicated, and the follow-up "what about `k` arrays?" would need many changes.

## Better: a queue of sources

The queue holds sources that still have elements, together with each source's current position. Each `next` takes the source at the front and reads one value; if the source has more, it goes back to the end of the queue:

```python
from collections import deque

class ZigzagIterator:
    def __init__(self, v1: List[int], v2: List[int]):
        self.q = deque((v, 0) for v in (v1, v2) if v)

    def next(self) -> int:
        v, i = self.q.popleft()
        if i + 1 < len(v):
            self.q.append((v, i + 1))
        return v[i]

    def hasNext(self) -> bool:
        return bool(self.q)
```

Supporting `k` arrays only means putting `k` sources in the queue at construction, and `hasNext` no longer has side effects.

## Complexity

`next` and `hasNext` are `O(1)`; space `O(k)`, excluding the input arrays.

## Mistakes to Avoid

- Putting empty arrays in the queue: a later `next` reads out of range.
- Giving `hasNext` side effects: repeated calls must return the same result.

## Interview Explanation

A queue stores each source that still has elements, plus its current position. Each `next` reads one value from the source at the front and puts it back at the end if it has more, which naturally alternates and drops exhausted sources. `hasNext` just checks whether the queue is empty. Generalizing to `k` arrays means putting all `k` sources in the queue, and every operation stays `O(1)`.
