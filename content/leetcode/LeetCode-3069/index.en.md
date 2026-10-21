---
title: "LeetCode 3069: Distribute Elements Into Two Arrays I"
summary: "LeetCode 3069 note: simulate the rule: the first two go to separate arrays, then each element joins the array whose last element is larger"
description: "LeetCode 3069 record from 2024-03-03"
date: 2024-03-03
tags: ["easy", "array", "two-pointers", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2024-03-03
- Submissions: Accepted (first try)

## Approach

Simulate the rule directly ([Array]({{< relref "/algorithm/Array" >}}) Template 5): `arr1 = [nums[0]]`, `arr2 = [nums[1]]`, then each number goes by `arr1[-1] > arr2[-1]`, and the two are joined at the end.

## My Solution

```python
class Solution:
    def resultArray(self, nums: List[int]) -> List[int]:
        a, b = [nums[0]], [nums[1]]
        for x in nums[2:]:
            (a if a[-1] > b[-1] else b).append(x)
        return a + b
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Compare the arrays' **last** elements, not their sums.

## Interview Explanation

I simulate the rule, appending each number to the array whose last element is larger, and join them at the end. Time `O(n)`.
