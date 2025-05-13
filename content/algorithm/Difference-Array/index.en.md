---
title: "Difference Array"
summary: "Introduction to Difference Array"
description: "Algorithm Learning"
date: 2025-04-27
tags: ["blog", "algorithm", "difference array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

The Difference Array is an algorithmic technique used when a problem requires us to update values over an interval.  
Instead of updating every value individually, we can optimize by **only recording changes at the start and end indices**.  
Later, by applying a **prefix sum** from left to right, we can reconstruct the full updated array.

## Core Idea

If we directly update all the values within an interval, the time complexity would be `O(n^2)`.  
Take the following 2D array example: each element `[start, end, amount]` means we should add or subtract `amount` from `start` to `end`.  
If we want to determine whether the final array values are larger than a certain number `k`,  
a brute-force method would be:

```python
origin = [1, 3, 2]
k = 5
operations = [[0, 1, 1], [1, 2, -1], [0, 2, 1]]

for start, end, amount in operations:
    for idx in range(start, end + 1):
        origin[idx] += amount

return max(origin) <= k
```

This is an `O(n * m)` operation (where `m` is the number of operations and `n` is the array length).

However, we can use the **difference array** technique to eliminate the inner loop,  
recording only the changes at specific points, and then reconstructing the result with a prefix sum:

```python
difference_array = [0] * (len(origin) + 1)

for start, end, amount in operations:
    difference_array[start] += amount
    difference_array[end + 1] -= amount

diff = 0
for i in range(len(origin)):
    diff += difference_array[i]
    status = origin[i] + diff
    if status >= k:
        return False

return True
```

This reduces the complexity to `O(n + m)`.


## Template

**1. Initialization**
```python
difference_array = [0] * (len(nums) + 1)
```
Create a difference array with a length one greater than the original array,  
used to mark the incremental changes at each index.

**2. Apply operations**
```python
for start, end, amount in operations:
    difference_array[start] += amount
    difference_array[end + 1] -= amount
```
Only increment at `start` and decrement at `end + 1`,  
representing a cumulative change over the interval.

**3. Prefix sum to recover the final state**
```python
result = []
diff = 0
for i in range(len(nums)):
    diff += difference_array[i]
    result.append(nums[i] + diff)
```
Use a prefix sum to reconstruct the final updated array based on the recorded changes.

### Don't know the length of nums

If we don't now the length of nums, for example only the operation was provided, we can use a hash map to record the difference by index, and then sort by hash map keys to get the prefix sum
```python
diff_map = default_dict(int)
for start, end, amount in differences:
    diff_map[start] += 1
    diff_map[end+1] -=1

diff = 0
for key in sorted(diff_map.keys()):
    diff += diff_map[key]
```
### Explanation of the key parameters:

## Examples

## LeetCode