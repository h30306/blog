---
title: "Segment Tree and Fenwick Tree"
summary: "Point updates with range queries: a Fenwick tree (binary indexed tree) jumps by i & -i, and a segment tree recursively halves the range; both take O(log n) per operation"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["segment-tree", "binary-indexed-tree", "design"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) answers range sums in `O(1)`, but changing one value means rebuilding the prefix array in `O(n)`. When the array changes, use a structure that supports partial updates:

| Structure | Update | Query | Good for |
|---|---|---|---|
| Prefix sum | `O(n)` | `O(1)` | No modifications |
| Fenwick tree | `O(log n)` | `O(log n)` | Point updates + prefix sums (subtract for a range) |
| Segment tree | `O(log n)` | `O(log n)` | Any mergeable range operation (sum, max, min), extensible to range updates |

## Template 1: Fenwick tree (binary indexed tree)

`tree[i]` covers a range of length `i & -i` (the lowest 1 bit of `i`). Indices start at 1:

```python
class Fenwick:
    def __init__(self, n):
        self.tree = [0] * (n + 1)

    def add(self, i, delta):             # nums[i] += delta, i starts at 1
        while i < len(self.tree):
            self.tree[i] += delta
            i += i & -i                  # up: the next cell whose range covers i

    def prefix(self, i):                 # sum of nums[1..i]
        s = 0
        while i > 0:
            s += self.tree[i]
            i -= i & -i                  # left: drop the range this cell covers
        return s
```

A range sum is `prefix(r) - prefix(l - 1)`. When the problem says "set to `val`", compute the difference `val - nums[i]` first and `add` it, which means keeping a copy of the array.

## Template 2: Segment tree

Node `node` covers `[start, end]`, with children `2 * node + 1` and `2 * node + 2`, in an array of size `4n`:

```python
def build(node, start, end):
    if start == end:
        tree[node] = nums[start]
        return
    mid = (start + end) // 2
    build(2 * node + 1, start, mid)
    build(2 * node + 2, mid + 1, end)
    tree[node] = tree[2 * node + 1] + tree[2 * node + 2]

def query(node, start, end, l, r):
    if r < start or end < l:             # no overlap
        return 0
    if l <= start and end <= r:          # fully covered
        return tree[node]
    mid = (start + end) // 2
    return query(2 * node + 1, start, mid, l, r) + query(2 * node + 2, mid + 1, end, l, r)
```

An update walks down to the leaf like the build, then recomputes every parent on the way back.

- **Mutable range sums** (LC 307): either works; Fenwick is shorter, and a segment tree extends more easily.

## Key Parameters

- Fenwick indices start at 1, and `i & -i` is the lowest 1 bit of `i`.
- Segment tree ranges are inclusive `[start, end]`; `mid` belongs to the left half.

## Complexity

Build in `O(n)` (adding one by one into a Fenwick tree is `O(n log n)`), each update and query `O(log n)`, space `O(n)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Both children computed as the same node**: the right child was written `2 * node + 1`, same as the left (LC 307).
- **No `return` after recursing**: both halves were queried but their sum was never returned, giving `None` (LC 307).

## Related LeetCode

- `LC 307` Range Sum Query - Mutable
