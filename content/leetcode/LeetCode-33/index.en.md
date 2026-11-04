---
title: "LeetCode 33: Search in Rotated Sorted Array"
summary: "LeetCode 33 note: after rotation one side of mid is always sorted; check whether the target lies in it and search there, otherwise search the other side"
description: "LeetCode 33 record from 2022-10-21"
date: 2022-10-21
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
First Attempt: 2022-10-21
- Submissions: Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted → Wrong Answer ×4 → Accepted → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted → Runtime Error → Accepted ×4
- 2026-11-03 rewrite: Accepted ×2

## Approach

Splitting at `mid`, at least one of `[l, mid]` and `[mid, r]` is sorted ([Binary Search]({{< relref "/algorithm/Binary-Search" >}})):

- `nums[l] <= nums[mid]`: the left half is sorted. Go left if the target lies in `[nums[l], nums[mid])`, otherwise right.
- Otherwise the right half is sorted. Go right if the target lies in `(nums[mid], nums[r]]`, otherwise left.

Only **the sorted half** can tell whether the target is inside.

## My Attempts

My first accepted version in 2022 was actually a linear scan (`O(n)`). The dozen WAs while practicing binary search all chose the wrong direction:

- One decided with `nums[mid] >= target` first and then checked a range, but the half it checked was not necessarily sorted: `[8, 9, 10, 3]`, `target = 10` should be 2; it returned -1.
- One moved left whenever `nums[r] >= target`, the reverse direction: `[1, 5]`, `target = 5` returned -1.

## Solution

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        l, r = 0, len(nums) - 1
        while l <= r:
            mid = (l + r) // 2
            if nums[mid] == target:
                return mid
            if nums[l] <= nums[mid]:                     # 左半有序
                if nums[l] <= target < nums[mid]:
                    r = mid - 1
                else:
                    l = mid + 1
            else:                                        # 右半有序
                if nums[mid] < target <= nums[r]:
                    l = mid + 1
                else:
                    r = mid - 1
        return -1
```

## 2026-11 Rewrite

Wrote it a new way on 2026-11-03 and passed on the first try (resubmitted the same code in the afternoon). Instead of deciding which half is sorted, define a monotone predicate `valid(mid)` and binary-search for the first True:

- `nums[-1]` splits the array into two segments: values `> nums[-1]` form the left segment, values `<= nums[-1]` the right one.
- If `mid` and `target` are in different segments: return True when `mid` is in the right segment (the target is in the left one, so the answer is left of `mid`), otherwise False.
- If they are in the same segment, that segment is sorted: return `nums[mid] >= target`.

Read left to right, `valid` is False…False True…True, so the first True is where the target belongs; finally check `nums[left] == target`.

```python
class Solution:
    def search(self, nums: List[int], target: int) -> int:
        def valid(mid):
            mid_right = nums[mid] <= nums[-1]
            target_right = target <= nums[-1]
            if mid_right != target_right:
                return mid_right
            return nums[mid] >= target

        left, right = 0, len(nums) - 1
        while left <= right:
            mid = (left + right) // 2
            if valid(mid):
                right = mid - 1
            else:
                left = mid + 1
        return left if left < len(nums) and nums[left] == target else -1
```

The binary search itself is pure template; all the thinking goes into the predicate. The dozen-plus WAs in 2022 were all wrong directions while splitting into halves, and this version has none of those branches. With no rotation every element is in the right segment and the predicate becomes a plain lower bound.

## Complexity

Time `O(log n)`, space `O(1)`.

## Mistakes to Avoid

- First decide which half is sorted, then whether the target is in it; comparing `nums[mid]` with the target alone cannot choose a direction.
- `nums[l] <= nums[mid]` needs the equality (when `l == mid`).

## Interview Explanation

After rotation one side of `mid` is always sorted; I find which, check whether the target falls in its range, and search there or the other side. Time `O(log n)`.
