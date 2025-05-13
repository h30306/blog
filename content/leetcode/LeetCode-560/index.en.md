---
title: "LeetCode 560: Subarray Sum Equals K"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "daily", "medium", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-19
- Total time: 15:00.00 (TLE)

## Intuition

This is a prefix sum problem, but the constraint `1 <= nums.length <= 2 * 10^4` makes it prone to TLE (Time Limit Exceeded) if we use a brute-force approach.

Initially, I tried using a prefix sum and iterating over all pairs of `i` and `j` to calculate the sum of every subarray. However, since the array size is large, the time complexity of `O(n^2)` is not acceptable.

From the forum, I learned a better approach using a hash map to count the number of occurrences of prefix sums. 

The main idea is:

- While iterating through the array, calculate the cumulative prefix sum (`count`).
- For each element, check whether `count - k` exists in the hash map.
    - If it does, it means there is a subarray that sums to `k`, and we can add the number of times `count - k` has occurred to the result.
- Update the hash map by incrementing the count for the current `count`.

This approach brings the time complexity down to `O(n)` and efficiently solves the problem.


## Approach
### TLE solution
```python
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        n = len(nums)

        ps = [0]* (n+1)

        for i in range(n):
            ps[i+1] = nums[i] + ps[i]

        res = 0
        for i in range(n):
            for j in range(i, n):
                if ps[j+1]-ps[i] == k:
                    res+=1

        return res
```

```python
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        sub_num = {0:1}

        count = res = 0
        for num in nums:
            count += num
            
            if (count - k) in sub_num:
                res += sub_num[count - k]

            sub_num[count] = sub_num.get(count, 0) + 1

        return res

```
## Findings
I was initially constrained by the idea of using prefix sums to find the answer. 

However, I realized that if the goal is to count the occurrences of a specific number, storing the values in a hash map and querying them when needed is often a better approach. 

This strategy not only simplifies the logic but also significantly reduces the time complexity.


## Encountered Problems 