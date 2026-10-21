---
title: "LeetCode 347: Top K Frequent Elements"
summary: "LeetCode 347 note: count first, then take the k most frequent with a size-k heap or a bucket sort indexed by count"
description: "LeetCode 347 record from 2022-10-27"
date: 2022-10-27
tags: ["medium", "array", "hash-table", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-27
- Submissions: Runtime Error → Accepted ×2

## Approach

Count with a `Counter`, then take the `k` most frequent:

- A size-`k` min-heap keyed by count ([Heap]({{< relref "/algorithm/Heap" >}}) Template 1), `O(n log k)`.
- Bucket sort ([Bucket Sort]({{< relref "/algorithm/Bucket-Sort" >}})): counts are at most `n`, so `bucket[c]` holds the values with count `c`; collect from the largest bucket down until `k` values, `O(n)`.

## My Attempts

Attempt 1 called `Counter(nums).most_common().keys()`, but `most_common()` returns a list (AttributeError). `[x for x, _ in Counter(nums).most_common(k)]` passed, in `O(n log n)`.

## Solution

```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        cnt = Counter(nums)
        buckets = [[] for _ in range(len(nums) + 1)]
        for x, c in cnt.items():
            buckets[c].append(x)
        res = []
        for c in range(len(nums), 0, -1):
            res += buckets[c]
            if len(res) >= k:
                return res[:k]
        return res
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `most_common()` returns a list, which has no `.keys()`.
- The follow-up asks for better than `O(n log n)`, so full sorting misses it.

## Interview Explanation

I count, put each value into the bucket for its count (at most n buckets), and collect from the highest bucket down until k values. Time `O(n)`; a size-k heap gives `O(n log k)`.
