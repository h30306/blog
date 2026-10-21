---
title: "LeetCode 164: Maximum Gap"
summary: "LeetCode 164 note: the maximum gap is at least the average gap, so with buckets no wider than that it lies between consecutive non-empty buckets; keep each bucket's min and max for O(n)"
description: "LeetCode 164 record from 2025-04-14"
date: 2025-04-14
tags: ["medium", "bucket-sort", "radix-sort", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-14
- Submissions: Runtime Error → Accepted (sorting) → Memory Limit Exceeded ×2 (2025-04-15, 2025-04-20)

## Approach

The problem asks for linear time, so no sorting. Use the pigeonhole principle ([Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})):

- With `n` numbers in `[lo, hi]`, the `n - 1` sorted adjacent differences sum to `hi - lo`, so the maximum difference is **at least** the average `(hi - lo) / (n - 1)`.
- Split the range into buckets no wider than the average; two numbers in one bucket differ by less than the average, so that **cannot be the maximum**.
- So the maximum is "some non-empty bucket's minimum minus the previous non-empty bucket's maximum", and each bucket only needs its minimum and maximum.

## My Attempts

1. Attempt 1 simply sorted; an extra parenthesis gave RE, and the fixed version passed, but that is `O(n log n)`, not what the problem asks.
2. Later, aiming for linear time, I allocated a boolean array as large as the value range to mark values seen, then scanned it for the largest gap. Values reach `10^9`, so both tries hit Memory Limit Exceeded.
3. The right approach makes the number of buckets depend on `n`, not on the value range.

## Solution

```python
class Solution:
    def maximumGap(self, nums: List[int]) -> int:
        lo, hi, n = min(nums), max(nums), len(nums)
        if n < 2 or lo == hi:
            return 0
        size = max(1, (hi - lo) // (n - 1))        # bucket width at most the average gap
        count = (hi - lo) // size + 1
        bmin, bmax = [None] * count, [None] * count
        for x in nums:
            b = (x - lo) // size
            bmin[b] = x if bmin[b] is None else min(bmin[b], x)
            bmax[b] = x if bmax[b] is None else max(bmax[b], x)
        best, prev = 0, lo
        for b in range(count):
            if bmin[b] is not None:
                best = max(best, bmin[b] - prev)
                prev = bmax[b]
        return best
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Do not allocate an array the size of the value range.
- Compute the bucket width with integer division clamped to at least 1, so it is never 0.
- Compare only consecutive non-empty buckets; skip empty ones.

## Interview Explanation

The maximum gap is at least the average gap, so I split the range into buckets no wider than the average; a difference within one bucket cannot be the maximum. Each bucket keeps its minimum and maximum, and one final scan takes each non-empty bucket's minimum minus the previous non-empty bucket's maximum. Time and space `O(n)`.
