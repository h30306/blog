---
title: "LeetCode 3829: Design Ride Sharing System"
summary: "LeetCode 3829 note: one queue each for riders and drivers; cancellations only update a set, and canceled riders at the front are dropped before matching"
description: "LeetCode 3829 record from 2026-02-01"
date: 2026-02-01
tags: ["medium", "queue", "design", "hash-map", "lazy-deletion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-01
- Submissions: Accepted (first try)

## Approach

Riders and drivers are matched in arrival order, so each gets a queue, and a match takes the earliest of each.

The tricky part is `cancelRider`: removing a waiting rider from the **middle** of the queue. Use lazy deletion:

- On cancel, leave the queue alone and remove the rider from a "still waiting" set.
- Before matching, drop riders at the front who are not in the set, until the front rider is still waiting.

## My Solution

```python
from collections import deque

class RideSharingSystem:

    def __init__(self):
        self.riders = deque()
        self.drivers = deque()
        self.waiting = set()                  # riders still waiting

    def addRider(self, riderId: int) -> None:
        self.riders.append(riderId)
        self.waiting.add(riderId)

    def addDriver(self, driverId: int) -> None:
        self.drivers.append(driverId)

    def matchDriverWithRider(self) -> List[int]:
        while self.riders and self.riders[0] not in self.waiting:
            self.riders.popleft()             # drop canceled riders
        if not self.riders or not self.drivers:
            return [-1, -1]
        rider = self.riders.popleft()
        self.waiting.discard(rider)
        return [self.drivers.popleft(), rider]

    def cancelRider(self, riderId: int) -> None:
        self.waiting.discard(riderId)
```

My original version kept a `cancel` set of canceled riders and, on cancel, checked `riderId in self.rider` to see whether the rider was still queued. `in` on a deque is `O(n)`, which gets slow with many riders. Maintaining a "still waiting" set makes both cancel and the check `O(1)`.

## Complexity

Each operation is amortized `O(1)`: every rider is dropped at most once. Space `O(n)`.

## Mistakes to Avoid

- Checking membership with `in` on a deque: `O(n)`.
- Checking "both sides non-empty" before dropping canceled riders: the rider queue may become empty after cleanup, so check afterwards.
- Canceling a rider who was already matched: remove riders from the set when matching too, so a later cancel affects nobody else.

## Interview Explanation

Riders and drivers each have a queue and are matched in arrival order. Canceling a rider means deleting from the middle of the queue, so I use lazy deletion: a set holds riders still waiting, canceling only removes from the set, and before matching I drop front riders no longer in the set. Each rider is dropped at most once, so every operation is amortized `O(1)`.
