---
title: "LeetCode 1399: Count Largest Group"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-23
tags: ["LeetCode", "blog", "daily", "easy", "hash map"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-23
- Total time: 15:00.00

## Intuition

At first, I didn't fully understand the problem...  
But after reading a good explanation in the comments, I realized the goal is to group numbers based on the sum of their digits, and return the count of groups that have the largest size.  

My intuition was to use a hash map to record the mapping from **digit sum → group size**, and a constant `max_count` to keep track of the largest group size.  
After iterating through all integers from `1` to `n`, we can determine the maximum group size.  
Then, we iterate through the hash map to count how many groups have this size — that will be the answer.

This solution runs in `O(n)` time, since we just iterate through the numbers once.


## Approach

```python
class Solution:
    def countLargestGroup(self, n: int) -> int:
        seen = {}
        max_count = 0
        for i in range(1, n+1):
            digit_sum = sum(map(int, list(str(i))))
            count = seen.get(digit_sum, 0)
            max_count = max(max_count, count+1)
            seen[digit_sum] = count + 1

        return len([v for v in seen.values() if v == max_count])
```

## Findings

NA

## Encountered Problems 

NA