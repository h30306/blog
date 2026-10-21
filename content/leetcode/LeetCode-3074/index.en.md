---
title: "LeetCode 3074: Apple Redistribution into Boxes"
summary: "LeetCode 3074 note: apples can be split freely, so take boxes from the largest capacity until the total fits every apple"
description: "LeetCode 3074 record from 2024-03-10"
date: 2024-03-10
tags: ["easy", "array", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2024-03-10
- Submissions: Accepted (first try)

## Approach

A pack may be split across boxes, so only total capacity matters. To use the fewest boxes, take the largest first ([Greedy]({{< relref "/algorithm/Greedy" >}}) Template 1) and stop once the accumulated capacity reaches the apple total.

## My Attempts

Passed on the first try during the 2024 contest by sorting and accumulating from the largest.

## Solution

```python
class Solution:
    def minimumBoxes(self, apple: List[int], capacity: List[int]) -> int:
        need = sum(apple)
        for i, c in enumerate(sorted(capacity, reverse=True), 1):
            need -= c
            if need <= 0:
                return i
        return len(capacity)
```

## Complexity

Time `O(m log m)`, space `O(m)`.

## Mistakes to Avoid

- Apples can be split, so only the total matters.

## Interview Explanation

Since apples can be split, only total capacity matters; I sort boxes by capacity descending and take them until the capacity covers every apple. Time `O(m log m)`.
