---
title: "LeetCode 88: Merge Sorted Array"
summary: "LeetCode 88 note: merge from the back with O(1) extra space"
description: "LeetCode 88 record from the 2026-10-18 merge sort practice ladder"
date: 2026-10-18
tags: ["easy", "two-pointers", "merge-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-10-18
Source: merge sort practice ladder, step 0

## Approach

`nums1` has length `m + n`, and the last `n` slots are empty. Both arrays are already sorted, so only the merge step of merge sort is needed.

Filling from the front would overwrite elements of `nums1` that have not been read yet. Filling from the back avoids that: the write position `k` never passes the unread position `i`.

## My First Attempt

```python
i = m - 1
j = n - 1
k = m + n - 1

while i >= 0 or j >= 0:
    if j == -1 or (nums1[i] > nums2[j] and i >= 0):
        nums1[k] = nums1[i]
        i -= 1
    else:
        nums1[k] = nums2[j]
        j -= 1
    k -= 1
```

The output is correct, but two things can be improved:

- **Check order**: when `i == -1`, it reads `nums1[-1]` before checking `i >= 0`. Python's negative index happens to hide this, but in Java/C++ it goes out of bounds. Put the bounds check first so short-circuiting protects the access.
- **The loop runs too long**: once `nums2` is used up, the remaining elements of `nums1` are already in place. At that point `k == i`, so the loop copies elements onto themselves. `while j >= 0` is enough.

## Solution

```python
class Solution:
    def merge(self, nums1: list[int], m: int, nums2: list[int], n: int) -> None:
        i, j, k = m - 1, n - 1, m + n - 1
        while j >= 0:
            if i >= 0 and nums1[i] > nums2[j]:
                nums1[k] = nums1[i]
                i -= 1
            else:
                nums1[k] = nums2[j]
                j -= 1
            k -= 1
```

### Alternative: front to back with a buffer

This is the standard merge from merge sort, reused directly in LC 912:

```python
a = nums1[:m]
i = j = 0
for k in range(m + n):
    if j >= n or (i < m and a[i] <= nums2[j]):
        nums1[k] = a[i]
        i += 1
    else:
        nums1[k] = nums2[j]
        j += 1
```

## Complexity

| Approach | Time | Extra space |
|---|---|---|
| Back to front | `O(m + n)` | `O(1)` |
| Front to back with buffer | `O(m + n)` | `O(m)` |
| Concatenate and re-sort | `O((m + n) log(m + n))` | not recommended |

## Mistakes to Avoid

- Reading the array before checking the bounds.
- Filling from the front without a buffer and overwriting unread elements.

## Interview Explanation

Both arrays are sorted, so I only need the merge step. The free space in `nums1` is at the end, so I fill from the back, placing the larger of the two current values each time. That never overwrites anything unread, giving `O(m + n)` time and `O(1)` extra space. I can stop once `nums2` is empty, because the rest of `nums1` is already in place.
