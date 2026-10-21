---
title: "LeetCode 1089: Duplicate Zeros"
summary: "LeetCode 1089 note: count the zeros to know each value's shift, then move from back to front, writing the extra 0 when copying a zero"
description: "LeetCode 1089 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "array", "two-pointers"]
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
- Submissions: Runtime Error → Wrong Answer → Accepted

## Approach

Each value ends at "its index + the zeros before it". Moving **back to front** avoids overwriting values not yet moved ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 2):

- `zeros` starts as the total number of zeros.
- From the end, `nums[i]` goes to `i + zeros` (dropped if out of range).
- When `nums[i]` is 0, first write the duplicate 0 at `i + zeros`, decrement `zeros`, then write the original 0 at `i + zeros`.

## My Attempts

Attempt 1 worked front to back and went out of range; attempt 2 moved back to front but **wrote each zero only once** (no duplicate): `[0, 0, 3]` should become `[0, 0, 0]`; it stayed `[0, 0, 3]`.

## Solution

```python
class Solution:
    def duplicateZeros(self, arr: List[int]) -> None:
        n, zeros = len(arr), arr.count(0)
        for i in range(n - 1, -1, -1):
            if arr[i] == 0:
                if i + zeros < n:
                    arr[i + zeros] = 0                   # 複製出來的 0
                zeros -= 1
            if i + zeros < n:
                arr[i + zeros] = arr[i]
```

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Moving front to back overwrites unprocessed values.
- A zero is written twice, one slot apart.

## Interview Explanation

Each value shifts by the number of zeros before it, so I count the zeros, then move from the back, writing an extra 0 and reducing the shift on each zero. Time `O(n)`, space `O(1)`.
