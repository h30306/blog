---
title: "LeetCode 3885: Design Event Manager"
summary: "LeetCode 3885 note: a dict of current priorities plus a max-heap with lazy deletion, validated on pop"
description: "LeetCode 3885 record from 2026-03-29"
date: 2026-03-29
tags: ["medium", "heap", "design", "hash-map", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-03-29
- Submissions: Wrong Answer → Time Limit Exceeded → Accepted

## Approach

This is nearly the same as LC 3815 Design Auction System and a textbook lazy-deletion problem:

- `priority[eventId]`: the currently valid priority; polled events are removed from the dict.
- A max-heap of `(-priority, eventId)`: highest priority, then smallest id, at the top.
- An update pushes a new entry and leaves the old one in the heap.
- On a poll, if the top's priority differs from the dict, or the event is no longer in the dict, it is stale: drop it and keep looking.

## My Attempts

### Wrong Answer: empty sets left in the dict

The first version used a `priority -> set(eventId)` dict. Updates removed the event from its old set, but **the key was not deleted once the set became empty**. Later, `max(dict)` could pick an empty set and return `-1`.

### Time Limit Exceeded: `max(dict)` costs O(number of distinct priorities)

Deleting empty sets fixed the answers, but every `pollHighest` scanned all priorities with `max(dict)` and then called `min(set)`, which timed out with many calls.

## Solution

```python
import heapq

class EventManager:

    def __init__(self, events: List[List[int]]):
        self.priority = {}
        self.heap = []
        for event_id, p in events:
            self.priority[event_id] = p
            self.heap.append((-p, event_id))
        heapq.heapify(self.heap)

    def updatePriority(self, eventId: int, newPriority: int) -> None:
        self.priority[eventId] = newPriority
        heapq.heappush(self.heap, (-newPriority, eventId))

    def pollHighest(self) -> int:
        while self.heap:
            neg_p, event_id = heapq.heappop(self.heap)
            if self.priority.get(event_id) == -neg_p:
                del self.priority[event_id]        # now taken
                return event_id
        return -1
```

`heapify` during initialization is `O(n)`, faster than `O(n log n)` from pushing one by one.

## Complexity

Each operation is amortized `O(log n)`; space `O(n + number of updates)`.

## Mistakes to Avoid

- Keeping a "priority → set" dict without deleting empty sets.
- Calling `max(dict)` on every query.
- Forgetting to delete from `priority` after a poll: another old entry for the same event could then look valid and be polled again.

## Interview Explanation

A dict stores each event's current priority, and a heap stores `(-priority, id)`, so the top is the highest priority with the smallest id. Updates push a new entry and leave the old one. On a poll, if the top's priority does not match the dict, or the event was already taken, I drop it and keep looking; a valid one is removed from the dict and returned. Each operation is amortized `O(log n)`.
