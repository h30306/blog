---
title: "LeetCode 3815: Design Auction System"
summary: "LeetCode 3815 note: one max-heap per item, push a new entry on every bid change, and drop stale entries on query"
description: "LeetCode 3815 record from 2026-01-18"
date: 2026-01-18
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
First Attempt: 2026-01-18
- Submissions: Wrong Answer → Time Limit Exceeded → Wrong Answer → Accepted

## Approach

Support adding, updating, and removing bids, and query an item's bidder with the highest amount, breaking ties by the largest userId.

- `bids[itemId][userId] = amount`: the currently valid bids.
- `heaps[itemId]`: a min-heap of `(-amount, -userId)`, whose top is "largest amount, then largest userId".

Updates and removals never touch the heap; they only change `bids`. On a query, check whether the top matches the current bid in `bids`; if not, it is stale, so pop it (lazy deletion).

## My Attempts

### Wrong Answer: the wrong user on ties

```python
return sorted(candidate)[0]       # the problem wants the largest userId; this takes the smallest
```

### Time Limit Exceeded: scanning every bid on each query

After switching to `[-1]` the answers were right, but `getHighestBidder` called `max(...)` and scanned for candidates every time, which is `O(number of bids)` and timed out with many queries.

### Wrong Answer: no return when the heap empties

After switching to a heap with lazy deletion, nothing was returned after the `while heap:` loop ended, so the function returned `None`.

## Solution

```python
import heapq
from collections import defaultdict

class AuctionSystem:

    def __init__(self):
        self.bids = defaultdict(dict)          # itemId -> {userId: amount}
        self.heaps = defaultdict(list)         # itemId -> [(-amount, -userId)]

    def addBid(self, userId: int, itemId: int, bidAmount: int) -> None:
        self.bids[itemId][userId] = bidAmount
        heapq.heappush(self.heaps[itemId], (-bidAmount, -userId))

    def updateBid(self, userId: int, itemId: int, newAmount: int) -> None:
        self.addBid(userId, itemId, newAmount)

    def removeBid(self, userId: int, itemId: int) -> None:
        del self.bids[itemId][userId]

    def getHighestBidder(self, itemId: int) -> int:
        heap = self.heaps[itemId]
        current = self.bids[itemId]
        while heap:
            neg_amount, neg_user = heap[0]
            if current.get(-neg_user) == -neg_amount:
                return -neg_user
            heapq.heappop(heap)                # stale: removed or re-priced
        return -1
```

`updateBid` behaves exactly like `addBid`, so it reuses it.

## Complexity

Each operation is amortized `O(log n)`, where `n` is the number of entries pushed. Space `O(n)`.

## Mistakes to Avoid

- Reading the tie rule backwards: this problem wants the **largest** userId.
- Not returning a default after the lazy-deletion loop.
- Checking only that the user still exists, not the amount: after a re-price, the old entry would look valid.

## Interview Explanation

A dict holds each item's currently valid bids, and each item also has a heap of `(-amount, -userId)`, whose top is the highest amount with the largest userId on ties. Adds and updates push a new entry; removals only change the dict. On a query, if the top does not match the dict, it is stale and gets popped; an empty heap returns `-1`. Each operation is amortized `O(log n)`.
