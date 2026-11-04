---
title: "LeetCode 153: Find Minimum in Rotated Sorted Array"
summary: "LeetCode 153 note: compare mid with the right end: nums[mid] > nums[r] puts the minimum to the right, otherwise mid may be it, so r = mid"
description: "LeetCode 153 record from 2022-10-28"
date: 2022-10-28
tags: ["medium", "array", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-28
- Submissions: Wrong Answer → Accepted ×2 → Wrong Answer ×6 → Accepted → Wrong Answer ×2 → Accepted ×4
- 2026-11-03 rewrite: Accepted ×4

## Approach

The minimum is the rotation point. Compare `nums[mid]` with `nums[r]` ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})):

- `nums[mid] > nums[r]`: the break is right of `mid`, so `l = mid + 1`.
- Otherwise `[mid, r]` is increasing and the minimum is at `mid` or to its left, so `r = mid`.

With `while l < r`, the final `l == r` is the minimum. Comparing with the right end is safer: comparing with the left end needs a special case for an unrotated array.

## My Attempts

The first nine WAs compared `nums[mid]` with the **left** end using incomplete conditions, failing even a two-element rotation like `[5, 4]` (returned 5). Comparing with the right end is much simpler.

## Solution

```python
class Solution:
    def findMin(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] > nums[r]:
                l = mid + 1
            else:
                r = mid
        return nums[l]
```

## 2026-11 Rewrite

Four submissions on 2026-11-03, all accepted:
1. `return min(nums)`. That is `O(n)` and the problem asks for `O(log n)`, so it does not count.
2. Closed interval: `right = mid - 1` when `nums[mid] <= nums[-1]`, else `left = mid + 1`, then return `nums[left]`.
3. The same predicate with `while left < right` and `right = mid`. The answer is always inside the range, so `right` can start at `n - 1`.
4. Version 2 again.

This time the comparison is against `nums[-1]` rather than `nums[r]` above. Read left to right, `nums[i] <= nums[-1]` is False…False True…True: the left segment is entirely greater than `nums[-1]`, the right segment is not. So the first True is the minimum and the first-True template applies directly. The new LC 33 version uses the same segment test.

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- `r = mid`, not `mid - 1`: `mid` itself may be the minimum.

## Interview Explanation

The minimum is the break point: if the middle exceeds the right end the break is to the right, otherwise the minimum is at or left of the middle, so I shrink the right bound to it. Where the bounds meet is the minimum. Time `O(log n)`.
