---
title: "LeetCode 1229: Meeting Scheduler"
summary: "LeetCode 1229 note: sort both people's slots, then find intersections with two pointers as in 986; the first intersection that is long enough is the earliest slot"
description: "LeetCode 1229 record from 2026-02-10"
date: 2026-02-10
tags: ["medium", "two-pointers", "sorting", "array"]
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
- Submissions: Wrong Answer ×3 → Accepted ×2

## Approach

Like [LeetCode 986]({{< relref "/leetcode/LeetCode-986" >}}), this intersects two interval lists, except **the input here is not sorted**.

1. Sort each person's slots by start.
2. Two pointers: the intersection is `[max(start1, start2), min(end1, end2)]`; if its length is `>= duration`, return `[start, start + duration]`.
3. The slot that ends first cannot meet anything else, so advance its pointer.

The pointers visit intersections in time order, so **the first one long enough is the earliest**.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1 | Hard-coded the length as `+ 8` (the example's duration), compared length with `>`, and did not sort. For `[[0, 10]]`, `[[0, 10]]`, `duration = 3`, the answer is `[0, 3]`; it returned `[0, 8]` |
| Attempt 2 | Switched to `+ duration` but still used `>`, skipping intersections exactly `duration` long. For `[[0, 5]]`, `[[0, 5]]`, `duration = 5`, the answer is `[0, 5]`; it returned `[]` |
| Attempt 3 | Switched to `>=` but still did not sort. For `slots1 = [[10, 15], [0, 5]]`, `slots2 = [[0, 5]]`, `duration = 2`, the answer is `[0, 2]`; this compared `[10, 15]` with slots2's `[0, 5]`, found no overlap, skipped `[0, 5]` because it ends first, and returned `[]` |

Adding the sort passed. I later removed the "skip slots that are too short" loops, since the intersection length check already covers them.

## Solution

```python
class Solution:
    def minAvailableDuration(self, slots1: List[List[int]], slots2: List[List[int]], duration: int) -> List[int]:
        slots1.sort()
        slots2.sort()
        i = j = 0
        while i < len(slots1) and j < len(slots2):
            start = max(slots1[i][0], slots2[j][0])
            end = min(slots1[i][1], slots2[j][1])
            if end - start >= duration:
                return [start, start + duration]
            if slots1[i][1] < slots2[j][1]:
                i += 1                             # slots1[i] ends first
            else:
                j += 1
        return []
```

## Complexity

Time `O(n log n + m log m)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Unsorted input: the problem only guarantees one person's slots don't overlap, not their order.
- A length exactly equal to `duration` works, so use `>=`.
- Hard-coding numbers from the example.

## Interview Explanation

This is interval intersection with unsorted input, so I sort both people's slots and use two pointers to find intersections, returning the start plus `duration` once one is long enough. The pointers visit intersections in time order, so the first one found is the earliest. The slot that ends first advances. Sorting dominates at `O(n log n)`.
