---
title: "LeetCode 503: Next Greater Element II (Monotonic Stack)"
summary: "Monotonic stack on a circular array"
description: "Two clean monotonic-stack approaches for the circular next greater element"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "monotonic-stack", "stack", "array", "circular-array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Metadata

Difficulty: Medium
First Attempt: 2025-08-09
- Total time: 00:00.00

## Intuition

Because the array is circular, we can conceptually traverse it twice. In the second pass we do not push new indices into the stack. By then, any index that already found its next greater element in the first pass has been popped. The remaining indices are exactly those that still need a next greater element.

Another clean approach is to iterate from back to front over a doubled range (from 2n-1 down to 0) while maintaining a decreasing monotonic stack of indices. While the top of the stack is less than or equal to the current value, pop it. The next greater for the current index is then the top of the stack if it exists. Using modulo connects the two ends to handle circularity naturally.

## Approach

Approach 1 — Two-pass forward monotonic stack
- Idea: First pass fills next greater for as many indices as possible. Second pass only resolves the remaining indices; do not push in the second pass.
- Complexity: Time O(n), Space O(n).

```python
class Solution:
    def nextGreaterElements(self, nums: List[int]) -> List[int]:
        
        stack = []
        res = [-1] * len(nums)

        for i in range(len(nums)):
            while stack and nums[i] > nums[stack[-1]]:
                idx = stack.pop()
                res[idx] = nums[i]
            stack.append(i)

        for i in range(len(nums)):
            while stack and nums[i] > nums[stack[-1]]:
                idx = stack.pop()
                if res[idx] == -1:
                    res[idx] = nums[i]


        return res
```

Approach 2 — Reverse traversal with modulo (decreasing stack)
- Idea: Scan indices from 2n-1 down to 0, keep a decreasing stack of indices. For each idx = i % n, pop smaller-or-equal values, then the top (if any) is the next greater.
- Complexity: Time O(n), Space O(n).

```python
class Solution:
    def nextGreaterElements(self, nums: List[int]) -> List[int]:
        
        stack = []
        n = len(nums)
        res = [-1] * n

        for i in range(n * 2 - 1, -1 , -1):
            idx = i % n
            while stack and nums[stack[-1]] <= nums[idx]:
                stack.pop(-1)

            if stack:
                res[idx] = nums[stack[-1]]
            stack.append(idx)

        return res
```

## Findings

- The problem reduces cleanly to a decreasing monotonic stack.
- Two equivalent patterns: forward two-pass vs. single reverse pass with modulo.
- Using indices (not values) in the stack prevents ambiguity with duplicates.

## Encountered Problems

- Easy to mistakenly push during the second forward pass; that breaks correctness/time.
- Off-by-one when iterating 2n-1 down to 0; ensure modulo and bounds are correct.
- Remember to pop while top <= current to handle duplicates correctly. 