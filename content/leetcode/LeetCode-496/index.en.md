---
title: "LeetCode 496: Next Greater Element I (Monotonic Stack)"
summary: "Monotonic decreasing stack over nums2 to build next-greater map; answer queries for nums1."
description: "Use a monotonic stack to compute next greater elements in linear time; includes complexity and common pitfalls."
date: 2025-08-09
tags: ["leetcode", "daily", "easy", "array", "stack", "monotonic-stack", "hash-map", "next-greater-element"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
  draft: false
---

## Meta Data

Difficulty: Easy
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

Traverse `nums2` with a monotonic decreasing stack. When the current number is greater than the stack top, pop and record the current number as the next greater element for the popped value. This precomputes a value→next-greater map that we can use to answer each `nums1` query in O(1).

## Approach

- Maintain a decreasing stack of values from `nums2`.
- For each `num` in `nums2`:
  - While stack is not empty and `stack[-1] < num`, pop `top` and set `map_[top] = num`.
  - Push `num` onto the stack.
- For each value in `nums1`, return `map_.get(value, -1)`.

```python
class Solution:
    def nextGreaterElement(self, nums1: List[int], nums2: List[int]) -> List[int]:

        stack = []
        map_ = {}

        for num in nums2:
            while stack and stack[-1] < num:
                value = stack.pop()
                map_[value] = num

            stack.append(num)

        return [map_.get(num, -1) for num in nums1]
```

### Complexity

- Time: O(n + m) where n = len(nums2), m = len(nums1)
- Space: O(n) for the stack and map

## Findings

- The decreasing stack ensures each element is pushed/popped at most once → linear time.
- Mapping by value is valid because `nums2` contains unique elements in this problem.
- Returning `-1` for missing keys naturally handles elements with no greater element to the right.

## Encountered Problems

- Mixing up indices vs values when building the map leads to wrong lookups.
- If elements were not unique, mapping by value would be ambiguous; here uniqueness in `nums2` avoids that issue.
- Forgetting to process the remaining stack is fine here because those values correctly map to `-1` by default. 