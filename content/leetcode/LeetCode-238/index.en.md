---
title: "LeetCode 238: Product of Array Except Self"
summary: "LeetCode 238 note: each answer is the product of everything to the left times everything to the right; two passes, no division"
description: "LeetCode 238 record from 2022-10-27"
date: 2022-10-27
tags: ["medium", "array", "prefix-sum"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-27
- Submissions: Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Output Limit Exceeded → Accepted → Runtime Error → Accepted ×5

## Approach

`res[i] = (nums[0] × ... × nums[i - 1]) × (nums[i + 1] × ... × nums[n - 1])`, a **prefix product** times a **suffix product** ([Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) with multiplication). The first pass stores the left product in `res[i]` (**excluding** `nums[i]`); the second pass, right to left, multiplies in the running `right` product. No division, so zeros need no special case.

## My Attempts

- The first 2022-10 version had a variable bug (UnboundLocalError).
- The second wrote the reverse pass as `range(len(nums), -1)`, **an empty range**, so no suffix product was applied; the prefix product was `res[i - 1] * nums[i]`, **including the element itself**: `[1, 3]` returned `[1, 3]` instead of `[3, 1]`.
- With the range fixed the prefix still included the element, returning `[3, 3]`. Using `nums[i - 1]` was correct, but a leftover `print` caused Output Limit Exceeded until removed.

## Solution

```python
class Solution:
    def productExceptSelf(self, nums: List[int]) -> List[int]:
        n = len(nums)
        res = [1] * n
        left = 1
        for i in range(n):
            res[i] = left
            left *= nums[i]
        right = 1
        for i in range(n - 1, -1, -1):
            res[i] *= right
            right *= nums[i]
        return res
```

## Complexity

Time `O(n)`, space `O(1)` excluding the output.

## Mistakes to Avoid

- The prefix product excludes the element: `res[i] = res[i - 1] * nums[i - 1]`, not `nums[i]`.
- A reverse loop is `range(n - 1, -1, -1)`; `range(n, -1)` is empty.
- Division is not allowed, and zeros may appear.

## Interview Explanation

Each answer is the product of everything left of it times everything right of it. One pass stores the left products, a reverse pass multiplies in a running right product; no division and `O(1)` extra space.
