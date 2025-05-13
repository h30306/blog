---
title: "LeetCode 3528: Unit Conversion I"
summary: "LeetCode Problem Solving"
description: "LeetCode Bi-Weekly Contest 155"
date: 2025-04-26
series: ["LeetCode Bi-Weekly Contest 155"]
series_order: 2
tags: ["LeetCode", "bi-weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-26
- Total time: 10:00.00

## Intuition

Brute-force:  
Simply iterate through the `conversions` list and count the results.

## Approach

```python
class Solution:
    def baseUnitConversions(self, conversions: List[List[int]]) -> List[int]:
        n = len(conversions)+1
        base = [1]*n
        
        for (start, end, times) in conversions:
            base[end] = (base[start]*times)%(10**9 + 7)
            
        
        return base
```

## Findings

NA

## Encountered Problems 

NA