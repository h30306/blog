---
title: "LeetCode 2843: Count Symmetric Integers"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-11
tags: ["LeetCode", "blog", "daily", "easy", "digit DP"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-11
- Total time: 5:00.00

## Intuition

I was considering using Digit DP to solve this problem, but I noticed that the problem constraint specifies the maximum number is only up to 10^5. 

Therefore, we can simply use brute-force to iterate through all numbers from `start` to `end`. For each number, we skip it if it's odd. If it's even, we find the middle index and compare the sum of digits from the start to the middle with the sum from the middle to the end.

This approach has a time complexity of `O(n)` and a space complexity of `O(1)`.


## Approach
```python
class Solution:
    def countSymmetricIntegers(self, low: int, high: int) -> int:
        
        res = 0
        for num in range(low, high+1):
            str_num = str(num)

            if len(str_num)%2:
                continue
            
            half_index = len(str_num)//2
            if sum(map(int, list(str_num[:half_index]))) == sum(map(int, list(str_num[half_index:]))):
                res+=1

        return res
```

## Findings
N/A

## Encountered Problems 
N/A