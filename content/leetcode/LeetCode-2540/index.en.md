---
title: "LeetCode 2540: Minimum Common Value"
summary: "LeetCode 2540 note: one pointer per sorted array, advance the smaller side, and the first match is the answer"
description: "LeetCode 2540 record from 2026-01-31"
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

Both arrays are sorted. Keep one pointer in each and compare from the smallest:

- Equal: this is the smallest common value; return it.
- Not equal: the smaller value cannot appear later in the other array (later values are only larger), so advance the smaller side.

## My Solution

```python
class Solution:
    def getCommon(self, nums1: List[int], nums2: List[int]) -> int:
        i = j = 0
        while i < len(nums1) and j < len(nums2):
            if nums1[i] == nums2[j]:
                return nums1[i]
            if nums1[i] < nums2[j]:
                i += 1
            else:
                j += 1
        return -1
```

My original checked "is this already the last element" before advancing and broke out if so. That is unnecessary: once a pointer reaches the end, the `while` condition stops the loop.

## Complexity

Time `O(n + m)`, space `O(1)`.

## Mistakes to Avoid

- Advancing the larger side: it skips the answer.
- Intersecting sets and taking the minimum: it works, but uses `O(n)` space and ignores the sorting.

## Interview Explanation

Both arrays are sorted, so I compare from the front with two pointers. Equal values give the smallest common value; otherwise the smaller value cannot be found in the other array anymore, so I advance its side. If either side runs out first, I return `-1`. Time `O(n + m)`, space `O(1)`.
