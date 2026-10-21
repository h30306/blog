---
title: "LeetCode 1184: Distance Between Bus Stops"
summary: "LeetCode 1184 note: a circular route has two directions; clockwise is the sum between start and destination, counterclockwise is the total minus that"
description: "LeetCode 1184 record from 2022-10-18"
date: 2022-10-18
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-10-18
- Submissions: Wrong Answer ×4 → Accepted ×4

## Approach

A ring has only two routes: clockwise covers `distance[a:b]` (with `a = min(start, destination)` and `b = max(...)`), counterclockwise is `total - clockwise`; take the shorter. **Order the endpoints first**, or the slice is empty when `start > destination`.

## My Attempts

The first four ignored `start > destination`, **so `distance[start:destination]` was empty** and the clockwise distance came out 0: `[2, 2]`, `start = 1`, `destination = 0` returned 0 instead of 2. Adding the swap passed.

## Solution

```python
class Solution:
    def distanceBetweenBusStops(self, distance: List[int], start: int, destination: int) -> int:
        a, b = min(start, destination), max(start, destination)
        clockwise = sum(distance[a:b])
        return min(clockwise, sum(distance) - clockwise)
```

## Complexity

Time `O(n)`, space `O(1)` apart from the `O(n)` slice.

## Mistakes to Avoid

- `start` may exceed `destination`; swap first.

## Interview Explanation

A ring has two directions; I order the endpoints, take the clockwise sum between them and the total minus it, and return the smaller. Time `O(n)`.
