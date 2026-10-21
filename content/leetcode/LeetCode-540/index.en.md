---
title: "LeetCode 540: Single Element in a Sorted Array"
summary: "LeetCode 540 note: before the single element every pair starts at an even index, so binary search whether nums[mid] equals nums[mid + 1] at an even mid"
description: "LeetCode 540 record from 2022-11-27"
date: 2022-11-27
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
First Attempt: 2022-11-27
- Submissions: Wrong Answer ×2 → Accepted

## Approach

Before the single element each pair starts at an **even** index; after it, at an odd index ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})). Make `mid` even and check `nums[mid] == nums[mid + 1]`:

- Equal: everything before is complete pairs, so the answer is to the right, `l = mid + 2`.
- Not equal: the answer is at `mid` or to its left, `r = mid`.

## My Attempts

I originally scanned pairs (`O(n)`, while the problem asks for `O(log n)`). The first two versions missed a single element at the end: the loop finished without returning, so `[7, 7, 8]` returned `None` instead of 8, and a lone `[3]` did too.

## Solution

```python
class Solution:
    def singleNonDuplicate(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if mid % 2:
                mid -= 1                                # 調成偶數
            if nums[mid] == nums[mid + 1]:
                l = mid + 2
            else:
                r = mid
        return nums[l]
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- The problem requires `O(log n)`; scanning pairs is `O(n)`.
- If the single element is last, a pairwise loop never finds it and needs a final return.

## Interview Explanation

Pairs before the single element start at even indices, so I align `mid` to even and compare it with the next: equal means the answer is to the right, otherwise at or left of `mid`. Time `O(log n)`.
