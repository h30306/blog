---
title: "Bucket Sort and the Pigeonhole Principle"
summary: "Split the value range into n - 1 buckets; the largest gap can never fall inside one bucket, so keeping each bucket's minimum and maximum finds the maximum adjacent difference in linear time"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["bucket-sort", "pigeonhole-principle", "sorting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Comparison sorting is at best `O(n log n)`. When you only need **some property** of the sorted order, you may not need to sort at all. Buckets split the value range into pieces, group values by piece, and keep only what is needed (say, each piece's minimum and maximum).

An array as large as the value range (counting sort) uses too much memory when the range is huge; the number of buckets depends only on `n`.

## Template: Maximum adjacent difference (pigeonhole)

With `n` numbers in `[lo, hi]`, the sorted order has `n - 1` adjacent differences summing to `hi - lo`, so **the largest difference is at least `ceil((hi - lo) / (n - 1))`**. With buckets no wider than that, any difference inside one bucket is smaller than the maximum, so the maximum must lie **between two consecutive non-empty buckets**:

```python
lo, hi = min(nums), max(nums)
if lo == hi:
    return 0
n = len(nums)
size = max(1, (hi - lo) // (n - 1))      # bucket width at most the average gap
count = (hi - lo) // size + 1
bmin = [None] * count
bmax = [None] * count
for x in nums:
    b = (x - lo) // size
    bmin[b] = x if bmin[b] is None else min(bmin[b], x)
    bmax[b] = x if bmax[b] is None else max(bmax[b], x)
best, prev = 0, lo
for b in range(count):
    if bmin[b] is not None:
        best = max(best, bmin[b] - prev)  # this bucket's min - previous non-empty bucket's max
        prev = bmax[b]
return best
```

- **Maximum gap** (LC 164): the code above, `O(n)`.

## Key Parameters

- `size` must be `<= (hi - lo) / (n - 1)` so differences within a bucket stay below the maximum; use integer division and clamp to at least 1.
- The first bucket always holds `lo` and the last always holds `hi`.

## Complexity

Time `O(n)`, space `O(n)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **An array as large as the value range**: values reach `10^9`, Memory Limit Exceeded (LC 164).
- **Just sorting**: it passes, but the problem asks for linear time (LC 164).

## Related LeetCode

- `LC 164` Maximum Gap
