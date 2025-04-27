---
title: "LeetCode 1094: Car Pooling"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-27
tags: ["LeetCode", "blog", "difference array", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-27
- Total time: 10:00.00

## Intuition

This is a classic **difference array** problem.  
However, since we don't know the maximum length of the array in advance,  
we have two options:
- **Option 1**: Pre-initialize a fixed-size array (e.g., length 1001).
- **Option 2**: Use a **hash map** to record the difference at each index,  
  and later sort the keys to process the prefix sum.

Using a hash map is cleaner and avoids unnecessary extra space.

## Approach

Since we use a hash map and need to sort the keys,  
the time complexity will be **O(n log n)** due to the sorting step.  
If we pre-initialize a fixed-size array (and directly iterate without sorting),  
the time complexity can be reduced to **O(n)**.

```python
class Solution:
    def carPooling(self, trips: List[List[int]], capacity: int) -> bool:
        diff_map = {}
        
        for num, start, end in trips:
            diff_map[start] = diff_map.get(start, 0) + num
            diff_map[end] = diff_map.get(end, 0) - num

        start = 0

        for position in sorted(diff_map.keys()):
            start += diff_map[position]
            if start > capacity:
                return False

        return True
```

- Add `num` at the pickup location (`start`).
- Subtract `num` at the drop-off location (`end`).
- Sort the time points and apply prefix sum to simulate the change in passengers.
- If at any point the current number of passengers exceeds `capacity`, return `False`.

Otherwise, the trip plan is valid.

## Findings

N/A

## Encountered Problems

N/A