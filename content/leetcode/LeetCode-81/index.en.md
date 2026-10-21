---
title: "LeetCode 81: Search in Rotated Sorted Array II"
summary: "LeetCode 81 note: with duplicates, nums[l] == nums[mid] hides which half is sorted, so just move l right by one; worst case O(n)"
description: "LeetCode 81 record from 2022-10-26"
date: 2022-10-26
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
First Attempt: 2022-10-26
- Submissions: Accepted → Wrong Answer ×8 → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer ×3 → Accepted → Wrong Answer → Accepted

## Approach

Decide which half is sorted as in LC 33, but now with duplicates ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})). When `nums[l] == nums[mid]`, as in `[1, 1, 1, 3, 1]`, you cannot tell whether the left half is sorted, so move `l` right by one and retry. With all values equal this degrades to `O(n)`.

## My Attempts

This took 19 submissions in 2022, nearly all WAs:

- At first the direction came only from `nums[r] >= target` / `nums[l] <= target`, without deciding which half is sorted: `[2, 2, 3, 0]`, `target = 3` returned `False`.
- After adding the sorted-half check, **`nums[l] == nums[mid]` went unhandled**, so duplicates misidentified the sorted half: `[1, 2, 3, 1, 1, 1, 1]`, `target = 2` returned `False`.
- One version returned nothing at the end, and one returned `-1` instead of `False`.

## Solution

```python
class Solution:
    def search(self, nums: List[int], target: int) -> bool:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return True
            if nums[l] == nums[mid]:                     # 分不出哪一半有序
                l += 1
            elif nums[l] < nums[mid]:                    # 左半有序
                if nums[l] <= target < nums[mid]:
                    r = mid - 1
                else:
                    l = mid + 1
            else:                                        # 右半有序
                if nums[mid] < target <= nums[r]:
                    l = mid + 1
                else:
                    r = mid - 1
        return False
```

## Complexity

Average `O(log n)`, worst case `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Duplicates make `nums[l] == nums[mid]` undecidable; shrink by one.

## Interview Explanation

As without duplicates I decide which half is sorted, but when `nums[l]` equals `nums[mid]` I cannot tell and move the left bound by one. Average `O(log n)`, `O(n)` when all values match.
