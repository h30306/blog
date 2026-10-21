---
title: "LeetCode 3379: Transformed Array"
summary: "LeetCode 3379 note: moving nums[i] steps right or left is nums[(i + nums[i]) % n]; Python's % returns a non-negative result for negatives too"
description: "LeetCode 3379 record from 2026-02-05"
date: 2026-02-05
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2026-02-05
- Submissions: Accepted (first try)

## Approach

Positive moves right and negative moves left by `|nums[i]|`, which together means landing at `i + nums[i]`. Wrap with `% n` for the circular array ([Array]({{< relref "/algorithm/Array" >}}) Template 5); Python's `%` gives `0..n-1` even for negatives, so no separate case is needed. `nums[i] == 0` lands on itself and yields 0, also covered.

## My Solution

```python
class Solution:
    def constructTransformedArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        return [nums[(i + x) % n] for i, x in enumerate(nums)]
```

I originally split positive, negative and zero into three cases; same result.

## Complexity

Time `O(n)`, space `O(n)` for the output.

## Mistakes to Avoid

- In other languages `%` can be negative for negative operands; write `((i + x) % n + n) % n`.

## Interview Explanation

Moving either way lands at `i + nums[i]`, taken mod `n` for the circular array; Python's mod is non-negative even for negatives. Time `O(n)`.
