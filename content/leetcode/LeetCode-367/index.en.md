---
title: "LeetCode 367: Valid Perfect Square"
summary: "LeetCode 367 note: binary search [1, num] for mid² == num without using sqrt"
description: "LeetCode 367 record from 2022-08-23"
date: 2022-08-23
tags: ["easy", "math", "binary-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-23
- Submissions: Accepted ×2

## Approach

The built-in square root is off limits. `mid²` grows with `mid`, so binary search `[1, num]` ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 4): equal means a perfect square, too small goes right, too large goes left.

## My Attempts

Both submissions passed; the November one actually returned nothing (`None`) when not found, which LeetCode happened to treat as `False`.

## Solution

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:
        l, r = 1, num
        while l <= r:
            mid = (l + r) // 2
            sq = mid * mid
            if sq == num:
                return True
            if sq < num:
                l = mid + 1
            else:
                r = mid - 1
        return False
```

## Complexity

Time `O(log num)`, space `O(1)`.

## Mistakes to Avoid

- Return `False` when not found, not nothing (`None`).

## Interview Explanation

Squares increase monotonically, so I binary search 1 to `num`; a square equal to `num` means yes. Time `O(log num)`.
