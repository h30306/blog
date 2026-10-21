---
title: "LeetCode 1791: Find Center of Star Graph"
summary: "LeetCode 1791 note: the center lies on every edge, so the common endpoint of the first two edges is the answer"
description: "LeetCode 1791 record from 2022-11-22"
date: 2022-11-22
tags: ["easy", "graph"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-11-22
- Submissions: Accepted (first try)

## Approach

A star's center connects to every other node, so **every edge** contains it. The endpoint shared by the first two edges is the center, in `O(1)` with no graph building or degree counting ([BFS]({{< relref "/algorithm/BFS" >}}) covers graph basics).

## My Solution

```python
class Solution:
    def findCenter(self, edges: List[List[int]]) -> int:
        a, b = edges[0]
        return a if a in edges[1] else b
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- Counting degrees works too, but two edges suffice.

## Interview Explanation

The center appears on every edge, so the endpoint shared by the first two edges is the answer. Time `O(1)`.
