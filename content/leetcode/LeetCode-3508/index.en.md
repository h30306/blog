---
title: "LeetCode 3508: Implement Router"
summary: "LeetCode 3508 note: a queue for FIFO, a set for duplicates, and an increasing time list per destination queried with bisect"
description: "LeetCode 3508 record from 2025-04-06"
date: 2025-04-06
tags: ["medium", "design", "binary-search", "queue", "hash-map"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-06
- Submissions: Runtime Error → Time Limit Exceeded (2025-04-06) → Wrong Answer → Accepted (2025-08-01)

## Approach

Each operation needs a different structure:

| Operation | Need | Structure |
|---|---|---|
| `addPacket` | detect duplicates | a `set` of `(source, destination, timestamp)` |
| `forwardPacket`, dropping the oldest when full | FIFO | a `deque` |
| `getCount` | packets for a destination within a time range | one time list per destination, plus bisect |

Key observation: `addPacket` timestamps are guaranteed **non-decreasing**, and removals always take the oldest packet. So **each destination's time list is already sorted** and only ever shrinks from the front.

## My Attempts

### April: Runtime Error and TLE

The first version kept everything in one list:

- `packet in self.packets` for duplicates is `O(n)`.
- `pop(0)` is `O(n)`.
- `getCount` scanned every packet, also `O(n)`.
- `forwardPacket` did not handle the empty case, so `pop(0)` on an empty list raised a Runtime Error.

After handling the empty case, it timed out.

### August: WA, binary search `hi` one too small

The rewrite used a set, a deque, and a deque of times per destination. The hand-written binary search set `right = len(packets) - 1` with a half-open `while left < right`. When every time is below `startTime`, the right answer is `len`, but this version can return at most `len - 1`. Changing it to `right = len(packets)` passed.

## Solution

The accepted version binary-searched a `deque`, but indexing into the middle of a `deque` is not `O(1)`. Here it is a list plus a "start pointer"; removing from the front just advances the pointer:

```python
import bisect
from collections import defaultdict, deque

class Router:

    def __init__(self, memoryLimit: int):
        self.limit = memoryLimit
        self.queue = deque()
        self.seen = set()
        self.times = defaultdict(list)       # destination -> increasing times
        self.start = defaultdict(int)        # destination -> first index still stored

    def addPacket(self, source: int, destination: int, timestamp: int) -> bool:
        packet = (source, destination, timestamp)
        if packet in self.seen:
            return False
        if len(self.queue) == self.limit:
            self.forwardPacket()
        self.queue.append(packet)
        self.seen.add(packet)
        self.times[destination].append(timestamp)
        return True

    def forwardPacket(self) -> List[int]:
        if not self.queue:
            return []
        packet = self.queue.popleft()
        self.seen.remove(packet)
        self.start[packet[1]] += 1           # the oldest is always at the front
        return list(packet)

    def getCount(self, destination: int, startTime: int, endTime: int) -> int:
        arr = self.times[destination]
        lo = self.start[destination]
        return bisect.bisect_right(arr, endTime, lo) - bisect.bisect_left(arr, startTime, lo)
```

The third argument `lo` makes `bisect` start from the first packet not yet removed.

## Complexity

`addPacket` and `forwardPacket` are `O(1)`, `getCount` is `O(log n)`. Space `O(n)`.

## Mistakes to Avoid

- Using linear list operations for duplicates, removal, and counting.
- Not handling an empty `forwardPacket`.
- Setting `hi` to `len - 1` in a half-open binary search.
- Dropping the oldest packet before the duplicate check: a duplicate must not cause any packet to be dropped, so **check duplicates first**.

## Interview Explanation

A deque handles FIFO and a set handles duplicates. Since timestamps never decrease and removals always take the oldest, each destination's time list is naturally sorted and only shrinks from the front, so I represent it as a list plus a start pointer. A query subtracts `bisect_left` from `bisect_right` to count packets in the range. Add and forward are `O(1)`, queries `O(log n)`.
