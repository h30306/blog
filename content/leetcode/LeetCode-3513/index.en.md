---
title: "LeetCode 3513: Number of Unique XOR Triplets I"
summary: "LeetCode Problem Solving"
description: "LeetCode Bi-Weekly Contest 154"
date: 2025-04-12
series: ["LeetCode Bi-Weekly Contest 154"]
series_order: 2
tags: ["LeetCode", "blog", "bi-weekly", "medium", "unsolved", "bit"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-12
- Total time: 20:00.00 (TLE)

## Intuition

My initial idea was to use a triple for-loop (`O(n^3)`) to iterate through all possible combinations of `nums`, and store the XOR results in a set called `seen`. However, this approach would obviously result in a TLE (Time Limit Exceeded) due to the three nested loops.

Then, I attempted to apply Digit DP, thinking it could help reduce duplicate calculations. For example:

- (0, 0, 0) → 3 XOR 3 XOR 3 = 3  
- (0, 0, 1) → 3 XOR 3 XOR 1 = 1  
- (0, 0, 2) → 3 XOR 3 XOR 2 = 2  
- (0, 1, 2) → 3 XOR 1 XOR 2 = 0

We don't need to recalculate expressions like `3 XOR 3` if the result has already been cached using `lru_cache`. 

However, the issue is that, unlike many classic Digit DP problems where the result space is relatively small, the set of possible XOR results in this problem is quite large. As a result, `lru_cache` suffers from a high cache miss rate, and the performance gain is minimal. Eventually, this still leads to TLE.

I believe the only feasible solution here involves bit manipulation, though I haven't found a clear explanation or an optimal approach yet.

## Approach
```python
class Solution:
    def uniqueXorTriplets(self, nums: List[int]) -> int:
        
        from functools import lru_cache

        n = len(nums)

        @lru_cache(None)
        def dfs(position, num_index, xor_result):
            if position == 3:
                return {xor_result}

            result = set()
            for idx in range(num_index, n):
                result.update(
                    dfs(
                        position + 1,
                        idx,
                        xor_result ^ nums[idx]
                    )
                )

            return result

        return len(dfs(0, 0, 0))
```
## Findings
1. The set of possible `xor_result` values is too large, resulting in a high cache miss rate in this approach, which eventually leads to a TLE.


## Encountered Problems 