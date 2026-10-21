---
title: "LeetCode 162: Find Peak Element"
summary: "LeetCode 162 note: nums[mid] < nums[mid + 1] guarantees a peak to the right (rising until the edge at worst), otherwise one at or left of mid"
description: "LeetCode 162 record from 2022-11-11"
date: 2022-11-11
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
First Attempt: 2022-11-11
- Submissions: Runtime Error → Wrong Answer → Runtime Error → Accepted → Runtime Error → Accepted ×2 → Wrong Answer → Accepted

## Approach

Treat both outsides as negative infinity ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})). Look at `mid` and `mid + 1`:

- `nums[mid] < nums[mid + 1]`: uphill to the right, so a peak exists there (if it rises all the way, the last element is a peak), `l = mid + 1`.
- Otherwise it is downhill from `mid`, so a peak exists at or left of `mid`, `r = mid`.

Neighbors are never equal, so there are no flat stretches.

## My Attempts

The early versions compared both `mid - 1` and `mid + 1`, repeatedly going out of range (IndexError); one typed `num` for `nums`; the last WA returned a non-peak index, e.g. not 2 for `[0, 2, 4]`.

## Solution

```python
class Solution:
    def findPeakElement(self, nums: List[int]) -> int:
        l, r = 0, len(nums) - 1
        while l < r:
            mid = (l + r) // 2
            if nums[mid] < nums[mid + 1]:
                l = mid + 1
            else:
                r = mid
        return l
```

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- With `while l < r`, `mid + 1` is always in range.

## Interview Explanation

I compare the middle with its right neighbor: uphill means a peak lies to the right, otherwise at or left of the middle. When the interval shrinks to one index, that is a peak. Time `O(log n)`.
