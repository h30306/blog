---
title: "Prefix Sum"
summary: "Introduction to Prefix Sum"
description: "Algorithm Learning"
date: 2025-04-19
tags: ["blog", "algorithm", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

**Prefix Sum** is an algorithmic technique used to quickly calculate the sum or value of a subarray. 
For example, given an array `nums = [2, 4, 5, 7]`, if we want to find the sum from `nums[i]` to `nums[j]`, using brute force would take `O(n)` time for each query. 
However, by iterating through the array once and building a prefix sum array, we can then answer each query in `O(1)` time.


## Core Idea

The core idea is to build an array where each element stores the cumulative sum of all previous elements. 
So for index `i`, the value at `prefix[i + 1]` will be the sum of elements from index `0` to `i` in the original array.

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]
```
If we want to find the sum from index `i` to `j`, we can simply use:
```python
sum_ = prefix[j+1] - prefix[i]
```
The first element in the prefix array represents an empty prefix (i.e., sum of `0` elements), so we use `prefix[j + 1]` to include the value at index `j`, and subtract `prefix[i]` to exclude the sum before index `i`.

## Template

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]

sum_ = prefix[j+1] - prefix[i]
```

### Explanation of the key parameters:

## Examples

classic prefix sum
```python
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

## LeetCode