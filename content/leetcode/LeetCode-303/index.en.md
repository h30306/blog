---
title: "LeetCode 303: Range Sum Query - Immutable"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "blog", "easy", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2025-04-19
- Total time: 2:00.00

## Intuition

Just a simple [Prefix Sum]({{< relref "algorithm/Prefix-Sum/index.en.md" >}}) problem

## Approach

```python
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

## Findings
NA

## Encountered Problems 
NA