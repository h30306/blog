---
title: "LeetCode 724: Find Pivot Index"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "blog", "daily", "easy", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-19
- Total time: 20:00.00

## Intuition

Initially, I used two prefix sum arrays — one from left to right, and one from right to left. 

Then, I iterated from the left index to the end, and if the sum from the left prefix array matched the sum from the right prefix array, I returned that index.

However, I realized that we don't actually need two prefix sum arrays. We only need the prefix sum from right to left. 

For the left-to-right part, we can simply maintain a running total using a constant variable to store the sum of the left-side numbers.


## Approach

```python
class Solution:
    def pivotIndex(self, nums: List[int]) -> int:
        n = len(nums)

        ps = [0] * (n + 1)

        for i in range(n-1, -1, -1):
            ps[i] = ps[i+1] + nums[i]
        
        
        count = 0
        for i in range(0, n):
            if ps[i+1] == count:
                return i
            count += nums[i]

        return -1
```

## Findings
NA

## Encountered Problems 
Array indexing can be tricky when working with prefix sums. 

When iterating from left to right, we have to use `ps[i + 1]` to check the cumulative sum. This is because the first element in the `ps` array represents the sum of zero elements (i.e., an empty prefix). 

As a result, if we want to compare the sum corresponding to index `0` in the original array, we need to use `ps[1]`. 

If we incorrectly use `ps[0]`, it would be like referencing a pivot index of `-1`, which doesn't exist. Therefore, to correctly compare prefix sums with actual indices in `nums`, we should always reference `ps[i + 1]`.