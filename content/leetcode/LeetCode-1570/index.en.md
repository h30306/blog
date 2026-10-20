---
title: "LeetCode 1570: Dot Product of Two Sparse Vectors"
summary: "LeetCode 1570 note: store only non-zero (index, value) pairs, and compute the dot product by merging the two index-sorted lists with two pointers, multiplying only on equal indices"
description: "LeetCode 1570 record from 2026-02-10"
date: 2026-02-10
tags: ["medium", "two-pointers", "design", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-02-10
- Submissions: Accepted (first try)

## Approach

A sparse vector is mostly zeros, so store only non-zero `(index, value)` pairs. Built in index order, the list is already sorted.

Only matching indices contribute to the dot product, so merge with two pointers:

- Same index: multiply, add, and advance both.
- Otherwise advance the one with the smaller index (the other side is 0 there).

**Follow-up, only one vector is sparse**: walk the sparse side and binary-search the matching index on the other (or index it directly), `O(k log m)` where `k` is the sparse side's non-zero count.

## My Attempts

My accepted version stored the full array and multiplied with `zip`, `O(n)` per call, which ignores the sparsity. The interview point of this problem is how to store and merge, so I switched to storing only non-zero elements.

## Solution

```python
class SparseVector:
    def __init__(self, nums: List[int]):
        self.pairs = [(i, x) for i, x in enumerate(nums) if x != 0]

    def dotProduct(self, vec: "SparseVector") -> int:
        a, b = self.pairs, vec.pairs
        i = j = 0
        res = 0
        while i < len(a) and j < len(b):
            if a[i][0] == b[j][0]:
                res += a[i][1] * b[j][1]
                i += 1
                j += 1
            elif a[i][0] < b[j][0]:
                i += 1
            else:
                j += 1
        return res
```

Another common version stores `{index: value}` and looks up each key of the smaller dict in the other. It is shorter; the two-pointer version needs no hashing, only the index-sorted lists.

## Complexity

Construction `O(n)`, dot product `O(k1 + k2)` (non-zero counts), space `O(k)`.

## Mistakes to Avoid

- Storing the full array: it ignores sparsity.
- Advancing the wrong pointer on different indices: advance the smaller index.

## Interview Explanation

I store only the non-zero `(index, value)` pairs, sorted by index. The dot product merges the two lists with two pointers, multiplying on equal indices and otherwise advancing the smaller index. Time is the total non-zero count. If only one side is sparse, I walk the sparse side and binary-search or index the other.
