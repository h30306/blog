---
title: "LeetCode 75: Sort Colors"
summary: "LeetCode 75 note: the Dutch flag, with 0s left of low and 2s right of high; after swapping a 2 to high, do not advance, since the swapped-in value is unchecked"
description: "LeetCode 75 record from 2022-10-26"
date: 2022-10-26
tags: ["medium", "array", "two-pointers", "sorting", "quicksort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-26
- Submissions: Accepted ×2 → Runtime Error → Wrong Answer ×3 → Runtime Error ×5 → Wrong Answer → Accepted ×5

## Approach

Three pointers ([Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) Template 1): `[0, low)` holds 0s, `(high, n)` holds 2s, and `i` is the current index:

- `nums[i] == 0`: swap with `low`, advance both (what comes back is a 1).
- `nums[i] == 2`: swap with `high`, `high -= 1`, and **keep `i`** (the swapped-in value is unchecked).
- `nums[i] == 1`: advance `i`.

## My Attempts

My first accepted version counted the 0s, 1s and 2s and refilled the array (two passes). Practicing the one-pass version with `for i in range(len(nums))`, **`i` still advanced after swapping with `high`**, so the incoming value went unchecked and `[2, 1]` stayed unchanged; a few versions also misspelled variable names.

## Solution

```python
class Solution:
    def sortColors(self, nums: List[int]) -> None:
        low, i, high = 0, 0, len(nums) - 1
        while i <= high:
            if nums[i] == 0:
                nums[low], nums[i] = nums[i], nums[low]
                low += 1
                i += 1
            elif nums[i] == 2:
                nums[high], nums[i] = nums[i], nums[high]
                high -= 1
            else:
                i += 1
```

## Complexity

Time `O(n)` in one pass, space `O(1)`.

## Mistakes to Avoid

- Do not advance `i` after swapping with `high`.
- Loop while `i <= high`, not `i < n`.

## Interview Explanation

With the Dutch-flag pointers, 0s swap left and 2s swap right; after a right swap the incoming value is unchecked, so the index stays. One pass, `O(n)`.
