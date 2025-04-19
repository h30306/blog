---
title: "LeetCode 1534: Count Good Triplets"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-14
tags: ["LeetCode", "blog", "daily", "easy"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-14
- Total time: 2:00.00
Second Attempt: 2025-04-19
- Total time: 120:00:00.00

## Intuition

It's natural to consider using brute force to solve this problem.  
Given that the range of `nums` is relatively small, an `O(n^3)` solution is acceptable and should not result in a TLE.

### 20250419 update

Got a hint from the forum — we don't need to iterate through the array three times. Instead, we can just iterate through `j` and `k`, then use the constraints to determine the valid boundary range for `i`. By leveraging prefix sums, we can efficiently count how many valid `i`s exist. There are two key insights in this approach:

---

#### 1. Finding the valid range of `arr[i]`

Based on the constraints:

- `|arr[i] - arr[j]| <= a`
- `|arr[i] - arr[k]| <= c`

We can derive the lower and upper bounds of `arr[i]` as follows:

- The **minimum** value `arr[i]` can take is the maximum of:
  - `arr[j] - a`
  - `arr[k] - c`
  - `0`
  
- The **maximum** value `arr[i]` can take is the minimum of:
  - `arr[j] + a`
  - `arr[k] + c`
  - `max(arr)`

This gives us the valid range `[left, right]` of values that `arr[i]` can be.

---

#### 2. Prefix sum setup

Unlike traditional prefix sums that are computed from the start, this approach **dynamically builds the prefix sum while iterating through index `j`**. 

Why? Because `i` must always be less than `j`. So we only need to count occurrences of values before `j`.

For example, with `arr = [3, 0, 1, 1, 9, 7]`, when `j = 3` and `k = 0`, the prefix sum will still be all zeros — because we haven't added any `arr[i]` yet. But after finishing all `k` iterations for this `j`, we update the prefix sum by incrementing all indices `≥ arr[j]`.

Suppose `arr[j] = 3`, then after the update, the prefix sum will be:
```
ps = [0, 0, 0, 1, 1, 1, 1, 1, 1, 1]
```
Now, in future `(j, k)` iterations, when we calculate the range `[left, right]`, we can use this prefix sum to efficiently count how many previous `i`s (i.e., values before `j`) fall within the valid range. For instance, if any future `(j, k)` combination results in a valid range that includes `3`, the prefix sum tells us that there's one valid `i` candidate.

---

This strategy makes the algorithm efficient by reducing a potential `O(n^3)` brute-force solution down to `O(n^2)` using prefix sums and value range filtering.


## Approach

### O(n^3)
```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        res = 0
        n = len(arr)
        for i in range(n):
            for j in range(i+1, n):
                for k in range(j+1, n):
                    if abs(arr[i]-arr[j]) <= a and abs(arr[j]-arr[k]) <= b and abs(arr[i]-arr[k]) <= c:
                        res +=1

        return res
```

### O(n^2)
```python
class Solution:
    def countGoodTriplets(self, arr: List[int], a: int, b: int, c: int) -> int:
        
        # iter j,k and use prefix sum to count i
        limit = max(arr)+1

        n = len(arr)
        ps = [0]*limit
        res = 0

        for j in range(n):
            for k in range(j+1, n):
                if abs(arr[j]-arr[k]) <= b:
                    left = max(arr[j] - a, arr[k] - c, 0)
                    right = min(arr[j] + a, arr[k] + c, limit-1)
                    if left <= right:
                        res += ps[right] - (0 if left == 0 else ps[left-1])

            for idx in range(arr[j], limit):
                ps[idx] += 1

        return res
```

## Findings
The trick is to use a dynamically updated prefix sum to get the count while iterating through the elements.

## Encountered Problems 
NA