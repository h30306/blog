---
title: "LeetCode 1122: Relative Sort Array"
summary: "LeetCode 1122 note: count first, emit values in arr2's order, then append the remaining values in ascending order"
description: "LeetCode 1122 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "sorting", "counting-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Wrong Answer ×2 → Accepted ×2

## Approach

Count `arr1` with a `Counter` ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1). Following `arr2`, emit each value as many times as it appears and remove it from the counts. Append the values not in `arr2` in **ascending** order with their multiplicities. With values in `0..1000`, a size-1001 counting array also works.

## My Attempts

- Attempt 1 emitted the leftovers with `C.most_common()`, **ordered by frequency rather than value**: `[6, 0, 9]`, `[9]` returned `[9, 6, 0]` instead of `[9, 0, 6]`.
- Attempt 2 used `sorted(C.keys())`, correctly ordered but **with each value only once**: `[2, 2, 6]`, `[6]` returned `[6, 2]`. `sorted(C.elements())` passed.

## Solution

```python
class Solution:
    def relativeSortArray(self, arr1: List[int], arr2: List[int]) -> List[int]:
        cnt = Counter(arr1)
        res = []
        for x in arr2:
            res += [x] * cnt.pop(x)
        for x in sorted(cnt):
            res += [x] * cnt[x]
        return res
```

## Complexity

Time `O(n + k log k)`, space `O(n)`.

## Mistakes to Avoid

- The remaining values go in ascending order, not by frequency.
- Keep the remaining values' multiplicities.

## Interview Explanation

I count first, emit arr2's values in order with their counts, then append the remaining values ascending with their counts. Time `O(n + k log k)`.
