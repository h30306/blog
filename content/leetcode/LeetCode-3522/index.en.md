---
title: "LeetCode 3522: Calculate Score After Performing Instructions"
summary: "LeetCode Problem Solving"
description: "LeetCode Weekly"
date: 2025-04-20
series: ["LeetCode Weekly Contest 446"]
series_order: 1
tags: ["LeetCode", "blog", "weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-20
- Total time: 11:48.00

## Intuition

se a brute-force approach: walk through the `instructions` array and perform the corresponding action (`add` or `jump`).  
If the `step` position goes out of bounds (either negative or greater than or equal to the length of the list), immediately stop the loop and return the score accumulated up to that point.  
We also need to track visited steps using a `seen` set to prevent infinite loops.

## Approach

```python
class Solution:
    def calculateScore(self, instructions: List[str], values: List[int]) -> int:
        score = 0
        step = 0
        seen = set()
        n = len(instructions)
        
        while True:
            seen.add(step)
            if instructions[step] == "add":
                score += values[step]
                step+=1
                if step in seen:
                    break
            
            elif instructions[step] == "jump":
                step += values[step]
                if step in seen:
                    break
                    
            if step < 0 or step>= n:
                break
                
        return score
```

## Findings

NA

## Encountered Problems 

NA