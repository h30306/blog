---
title: "LeetCode 506: Relative Ranks"
summary: "LeetCode 506 note: sort indices by score descending, give medals to the top three and rank strings to the rest, writing back into the original positions"
description: "LeetCode 506 record from 2022-08-25"
date: 2022-08-25
tags: ["easy", "array", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-25
- Submissions: Accepted ×2

## Approach

Sort indices by score from high to low (or pop them from a max-heap, [Heap]({{< relref "/algorithm/Heap" >}})); rank `r` (0-based) gets `Gold Medal`, `Silver Medal` or `Bronze Medal` for the top three and `str(r + 1)` otherwise, written back at the original index.

## My Solution

```python
class Solution:
    def findRelativeRanks(self, score: List[int]) -> List[str]:
        medals = ["Gold Medal", "Silver Medal", "Bronze Medal"]
        res = [""] * len(score)
        order = sorted(range(len(score)), key=lambda i: -score[i])
        for r, i in enumerate(order):
            res[i] = medals[r] if r < 3 else str(r + 1)
        return res
```

## Complexity

Time `O(n log n)`, space `O(n)`.

## Mistakes to Avoid

- Write each result at its original position, not in sorted order.

## Interview Explanation

I sort indices by score descending and write medals or rank strings back at the original indices. Time `O(n log n)`.
