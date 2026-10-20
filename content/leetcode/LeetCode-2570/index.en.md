---
title: "LeetCode 2570: Merge Two 2D Arrays by Summing Values"
summary: "LeetCode 2570 note: merge two id-sorted arrays with two pointers, adding values when ids match"
description: "LeetCode 2570 record from 2026-01-31"
date: 2026-01-31
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-01-31
- Submissions: Accepted (first try)

## Approach

Both arrays are sorted by id with unique ids in each. It is merging two sorted sequences (like LC 88), except matching ids add their values:

- Same id: output `[id, sum of both values]` and advance both pointers.
- Different: output the smaller id and advance that pointer.
- Once one side runs out, append the rest of the other.

## My Solution

```python
class Solution:
    def mergeArrays(self, nums1: List[List[int]], nums2: List[List[int]]) -> List[List[int]]:
        i = j = 0
        res = []
        while i < len(nums1) and j < len(nums2):
            if nums1[i][0] == nums2[j][0]:
                res.append([nums1[i][0], nums1[i][1] + nums2[j][1]])
                i += 1
                j += 1
            elif nums1[i][0] < nums2[j][0]:
                res.append(nums1[i])
                i += 1
            else:
                res.append(nums2[j])
                j += 1
        return res + nums1[i:] + nums2[j:]
```

My original handled "one side is exhausted" inside the same loop (`while i < n or j < m` with three cases inside). Looping only while both sides have elements and appending the rest afterwards is shorter.

## Complexity

Time `O(n + m)`, space `O(n + m)`.

## Mistakes to Avoid

- Collecting into a dict and sorting: it works, but ignores that the inputs are sorted and adds `O(k log k)`.
- Forgetting to append the leftovers after the loop.

## Interview Explanation

Both arrays are sorted by id, so I merge with two pointers: equal ids add their values and advance both; otherwise I output the smaller id and advance it. When one side runs out, I append the rest of the other. Time `O(n + m)`.
