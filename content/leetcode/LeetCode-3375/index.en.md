---
title: "LeetCode 3375: Minimum Operations to Make Array Values Equal to K"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-09
tags: ["LeetCode", "blog", "daily"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---


## Meta Data

First Attempt: 2025/04/09
- Total time: 08:41.14

## Thought Process

The problem describes a situation where we are asked to find an integer `h` such that all integers greater than `h` are identical — but this is just a misdirection. Actually, we can simplify the problem: there should be no duplicate numbers in the array, and we have to find `h` each time.

So the actual problem becomes: how many times do we find a number `h` such that `h == k`?

To solve this, we can use a set to track seen numbers and iterate through `nums`. When the current number is greater than `k` and not already in the set, we add it and count one operation.

After the iteration, we’ll know how many operations are needed. The only case we need to handle carefully is when a number is equal to `k` — this doesn’t require an extra operation. So we only need to focus on numbers greater than `k`.

## My Approach

```python
class Solution:
    def minOperations(self, nums: List[int], k: int) -> int:
        seen = set()
        op = 0
        for num in nums:
            if num > k and num not in seen:
                seen.add(num)
                op+=1
            elif num<k:
                return -1

        return op
```

## Encountered Problems 
1. Some test cases failed when I tried to handle the case where num == k. I attempted to use a variable equal to record whether a num == k appeared, and returned op + (not equal). However, this added an extra 1 to the result even when unnecessary, which caused the test to fail.



