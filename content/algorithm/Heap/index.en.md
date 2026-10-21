---
title: "Heap and Priority Queue"
summary: "heapq basics, Top-K, lazy deletion, two heaps, k-way merge, sweep line, and Dijkstra"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["heap", "priority-queue", "greedy", "dijkstra"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

A heap (priority queue) inserts and removes the minimum in `O(log n)` and shows the minimum in `O(1)` at any time.

Signals:

- You **repeatedly** need the current minimum or maximum while the set keeps changing.
- The problem mentions "k-th largest", "k closest", "ends earliest", or "priority".
- You merge several **already sorted** sequences.

If you need the minimum only once, sort or call `min()` instead.

## Python heapq Basics

```python
import heapq

h = []
heapq.heappush(h, 3)          # O(log n)
smallest = h[0]               # O(1), peek only
smallest = heapq.heappop(h)   # O(log n)
heapq.heapify(arr)            # O(n), in place
```

### Key Parameters:

- **Min-heap only**: for a max-heap, push negated values, e.g. `heappush(h, -x)`.
- **Tuples compare field by field**: `(priority, tie-breaker, data)`. When the first field ties, the second is compared, so put something comparable there, such as an index.
- **Strings cannot be negated**: for mixed orders like "higher score first, smaller name first on ties", define a class with `__lt__` (LC 2102).

## Template 1: Top-K with a size-k heap

For the k largest, keep a **min-heap** of size k: the top is the smallest of those k, and a new value replaces it only if larger.

```python
h = []
for x in nums:
    heapq.heappush(h, x)
    if len(h) > k:
        heapq.heappop(h)      # drop the smallest of the k
# h[0] is the k-th largest
```

Time `O(n log k)`.

## Template 2: Lazy Deletion

`heapq` cannot delete or change an element in the middle. Instead, **push a new entry on every update, leave the old one in place, and discard stale entries when they reach the top.**

```python
current = {}                  # key -> current valid value

def update(key, value):
    current[key] = value
    heapq.heappush(h, (-value, key))

def top():
    while h:
        neg_value, key = h[0]
        if current.get(key) == -neg_value:
            return key        # valid
        heapq.heappop(h)      # stale, discard
    return -1
```

### Key Parameters:

- The validity check must detect stale entries: usually compare against the current value in a dict (LC 3815, 3885) or an `online` array (LC 3607).
- Each entry is pushed and popped at most once, so the amortized cost stays `O(log n)`.
- **Return a default when the heap is empty**, or the function returns `None`.

## Template 3: Two Heaps

Two heaps hold two states, and elements move between them:

- **Free / busy** (LC 2402 Meeting Rooms III): free rooms ordered by number, busy rooms by end time. Before each meeting, move every finished room from busy to free.
- **Top k / the rest** (LC 2102): the top k in a min-heap whose top is the k-th; the rest in a max-heap whose top is the (k+1)-th.
- **Median** (LC 295): the smaller half in a max-heap, the larger half in a min-heap.

## Template 4: K-way Merge

To merge k sorted sequences, keep only the current head of each in the heap:

```python
h = [(lst[0], i, 0) for i, lst in enumerate(lists) if lst]
heapq.heapify(h)
while h:
    val, i, j = heapq.heappop(h)
    # process val
    if j + 1 < len(lists[i]):
        heapq.heappush(h, (lists[i][j + 1], i, j + 1))
```

Time `O(N log k)`. LC 632 also tracks the current maximum while merging; LC 759 finds gaps while merging.

## Template 5: Sweep Line with an End-time Heap

Sort by start time; the heap holds the end times of events in progress:

```python
intervals.sort()
h = []
for start, end in intervals:
    while h and h[0] <= start:    # half-open [start, end): reuse when end == start
        heapq.heappop(h)
    heapq.heappush(h, end)
    best = max(best, len(h))      # LC 253: most events at once
```

LC 1353 is a variant: each day, attend the event in the heap that ends earliest.

## Template 6: Dijkstra

The heap holds `(distance so far, node)`; always expand the node with the smallest distance.

- **Maximum probability path** (LC 1514): probabilities are between 0 and 1, so multiplying only makes them smaller. Push negated probabilities into a min-heap; it works like non-negative edge weights.
- **Lexicographic tie-break on distance** (LC 499): use `(distance, path string)` together as the priority.

## Complexity

| Operation | Time |
|---|---|
| `heappush` / `heappop` | `O(log n)` |
| peek `h[0]` | `O(1)` |
| `heapify` | `O(n)` |
| Top-K | `O(n log k)` |
| K-way merge | `O(N log k)` |

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Calling `min()` on a whole set for every query**: it times out with many queries; switch to a heap with lazy deletion (LC 3607, ten TLEs).
- **Not returning `-1` when the lazy-deletion heap empties** (LC 3815).
- **Leaving empty sets in a dict**: `max(dict)` picks a key with no elements left (LC 3885).
- **Wrong end time for a delayed meeting**: it is "when the room frees up + meeting length", not `max(free_time + end, end)` (LC 2402).
- **Using `<` instead of `<=` for half-open intervals**: a room can be reused when one meeting ends exactly as the next starts (LC 253).
- **Starting a running maximum at 0**: it fails with negative values (LC 632).
- **Taking the wrong end after sorting**: `[:3]` when the three largest were needed (LC 3572).
- **Pruning Dijkstra with `<`**: equal-distance states are pushed again and again, causing Memory Limit Exceeded (LC 1514).
- **Reverse simulation one step at a time**: when the gap is large, jump with a modulo (LC 1354).
- **Not processing new values once the Top-K heap is full**: use `heappushpop`, capping the size at `k`, not `k + 1` (LC 215).
- **Flipping the difference's sign in a negated max-heap**: push back a negative value (LC 1046).
- **Reading `h[0]` after equal stones cancel everything**: the heap may be empty (LC 1046).
- **Forgetting to restore the original order after Top-K** (LC 2099).

## Related LeetCode

- `LC 253` Meeting Rooms II
- `LC 1353` Maximum Number of Events That Can Be Attended
- `LC 2402` Meeting Rooms III
- `LC 632` Smallest Range Covering Elements from K Lists
- `LC 759` Employee Free Time
- `LC 3607` Power Grid Maintenance
- `LC 3815` Design Auction System
- `LC 3885` Design Event Manager
- `LC 2102` Sequentially Ordinal Rank Tracker
- `LC 1514` Path with Maximum Probability
- `LC 499` The Maze III
- `LC 1354` Construct Target Array With Multiple Sums
- `LC 420` Strong Password Checker
- `LC 3507` Minimum Pair Removal to Sort Array I
- `LC 3572` Maximize Y‑Sum by Picking a Triplet of Distinct X‑Values
- `LC 2762` Continuous Subarrays
- `LC 658` Find K Closest Elements
- `LC 1878` Get Biggest Three Rhombus Sums in a Grid
- `LC 215` Kth Largest Element in an Array
- `LC 973` K Closest Points to Origin
- `LC 1046` Last Stone Weight
- `LC 347` Top K Frequent Elements
- `LC 506` Relative Ranks
- `LC 2335` Minimum Amount of Time to Fill Cups
- `LC 1464` Maximum Product of Two Elements in an Array
- `LC 2357` Make Array Zero by Subtracting Equal Amounts
- `LC 2099` Find Subsequence of Length K With the Largest Sum
- `LC 2231` Largest Number After Digit Swaps by Parity
